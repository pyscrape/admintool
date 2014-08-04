import os
import sys
import sqlite3
from sqlalchemy import create_engine
from sqlalchemy.pool import StaticPool, NullPool
from sqlalchemy.orm import sessionmaker

ROOT = os.path.abspath(os.path.dirname(__file__))
path = lambda *x: os.path.normpath(os.path.join(ROOT, *x))

RUNNING_TESTS = 'nose' in sys.modules

SWCARPENTRY_ADMIN_PATH = os.environ.get('SWCARPENTRY_ADMIN_PATH')
if RUNNING_TESTS or SWCARPENTRY_ADMIN_PATH is None:
    SWCARPENTRY_ADMIN_PATH = os.curdir

ROSTER_DB = 'roster.test.db' if RUNNING_TESTS else 'roster.db'
ROSTER_DB_PATH = os.path.join(SWCARPENTRY_ADMIN_PATH, ROSTER_DB)

_engine = None
_Session = None

def get_engine():
    global _engine

    if _engine is None:
        _engine = create_engine(
            'sqlite:///%s' % ROSTER_DB_PATH,
            connect_args={'check_same_thread':False},
            poolclass=NullPool if RUNNING_TESTS else StaticPool
        )
    return _engine

def get_session():
    global _Session

    if _Session is None:
        _Session = sessionmaker(bind=get_engine())
    return _Session()

def add_users(users):
  #Here we would want to actually insert the users list into the database.
  #Using SQLAlchemy is a little beyond my Python expertise, so I think it is
  #best if I leave that to someone who knows what they are doing instead of
  #hacking some poor solution together that'll need to be redone anyway.
  return True

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

if RUNNING_TESTS:
    def setup():
        if os.path.exists(ROSTER_DB_PATH):
            os.unlink(ROSTER_DB_PATH)
        create_roster_db()

    def teardown():
        global _Session
        global _engine

        if _Session:
            _Session.close_all()
            _Session = None
        if _engine:
            _engine.dispose()
            _engine = None
        if os.path.exists(ROSTER_DB_PATH):
            os.unlink(ROSTER_DB_PATH)

if __name__ == '__main__':
    print 'Using the database at %s.' % ROSTER_DB_PATH
