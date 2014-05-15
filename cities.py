import os
import urllib2
import zipfile
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column, Text, Integer, Float
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

ROOT = os.path.abspath(os.path.dirname(__file__))
path = lambda *x: os.path.normpath(os.path.join(ROOT, *x))

CITIES_BASE = 'cities5000'
CITIES_URL = 'http://download.geonames.org/export/dump/%s.zip' % CITIES_BASE
CITIES_ZIP_PATH = path('%s.zip' % CITIES_BASE)
CITIES_TXT_PATH = path('%s.txt' % CITIES_BASE)
CITIES_DB_PATH = path('%s.db' % CITIES_BASE)
CITIES_DB_URL = 'sqlite:///%s' % CITIES_DB_PATH
SCHEMA_VERSION = 3

Base = declarative_base()

class Meta(Base):
    __tablename__ = 'Meta'

    version = Column(Integer, nullable=False, primary_key=True)

class City(Base):
    __tablename__ = 'City'

    id = Column(Integer, nullable=False, primary_key=True)
    name = Column(Text, nullable=False)
    country = Column(Text, nullable=False)
    state = Column(Text, nullable=False)
    latitude = Column(Float, nullable=False)
    longitude = Column(Float, nullable=False)

    @property
    def full_name(self):
        return '%s (%s, %s)' % (self.name, self.state, self.country)

_engine = None
_Session = None

def get_engine():
    global _engine

    if _engine is None:
        _engine = create_engine(CITIES_DB_URL)
    return _engine

def get_session():
    global _Session

    if _Session is None:
        _Session = sessionmaker(bind=get_engine())
    return _Session()

def find(name):
    return get_session().query(City).filter(City.name.contains(name))

def destroy_db():
    global _engine
    global _Session

    _engine = None
    _Session = None

    os.unlink(CITIES_DB_PATH)

def create_db():
    if os.path.exists(CITIES_DB_PATH):
        session = get_session()
        try:
            if session.query(Meta)[0].version != SCHEMA_VERSION:
                raise Exception('schema mismatch, rebuild database')
            return
        except Exception, e:
            session.close()
            destroy_db()

    print "Creating %s.db." % CITIES_BASE
    get_cities_txt()
    engine = get_engine()
    Base.metadata.create_all(engine)
    session = get_session()
    for line in open(CITIES_TXT_PATH, 'r'):
        parts = line.split('\t')
        city = City(
            id=parts[0],
            name=parts[1].decode('utf-8'),
            latitude=parts[4],
            longitude=parts[5],
            country=parts[8],
            state=parts[10]
        )
        session.add(city)
    session.add(Meta(version=SCHEMA_VERSION))
    session.commit()

def get_cities_txt():
    if os.path.exists(CITIES_TXT_PATH): return
    get_cities_zip()
    print "Extracting %s.txt" % CITIES_BASE
    with zipfile.ZipFile(CITIES_ZIP_PATH) as zf:
        zf.extract('%s.txt' % CITIES_BASE, path())

def get_cities_zip():
    if os.path.exists(CITIES_ZIP_PATH): return
    print "Downloading %s." % CITIES_URL
    f = urllib2.urlopen(CITIES_URL)
    open(CITIES_ZIP_PATH, 'wb').write(f.read())

if __name__ == '__main__':
    create_db()
