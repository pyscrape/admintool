import os
import sqlite3
from sqlalchemy import create_engine
from sqlalchemy.pool import StaticPool
from sqlalchemy.orm import sessionmaker

ROOT = os.path.abspath(os.path.dirname(__file__))
path = lambda *x: os.path.normpath(os.path.join(ROOT, *x))

SWCARPENTRY_ADMIN_PATH = os.environ.get('SWCARPENTRY_ADMIN_PATH')
if SWCARPENTRY_ADMIN_PATH is None:
    SWCARPENTRY_ADMIN_PATH = os.curdir

ROSTER_DB_PATH = os.path.join(SWCARPENTRY_ADMIN_PATH, 'roster.db')

_engine = None
_Session = None

def get_engine():
    global _engine

    if _engine is None:
        _engine = create_engine(
            'sqlite:///%s' % ROSTER_DB_PATH,
            connect_args={'check_same_thread':False},
            poolclass=StaticPool
        )
    return _engine

def get_session():
    global _Session

    if _Session is None:
        _Session = sessionmaker(bind=get_engine())
    return _Session()

def create_roster_db():
    '''
    Create roster.db in the Software Carpentry admin directory by
    feeding it roster.sql.

    This is normally done by the Makefile, but doing it ourselves
    here relieves many users of an annoying dependency on make.
    '''

    roster_sql_path = os.path.join(os.path.dirname(ROSTER_DB_PATH),
                                   'roster.sql')
    print "Reading from %s." % roster_sql_path
    print "Creating %s." % ROSTER_DB_PATH

    conn = sqlite3.connect(ROSTER_DB_PATH)
    c = conn.cursor()
    c.executescript(open(roster_sql_path).read())
    c.close()
    conn.close()

if __name__ == '__main__':
    print 'Using the database at %s.' % ROSTER_DB_PATH
