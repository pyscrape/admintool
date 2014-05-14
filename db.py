import os
import sys
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

ROOT = os.path.abspath(os.path.dirname(__file__))
path = lambda *x: os.path.normpath(os.path.join(ROOT, *x))

ROSTER_DB_PATH = os.environ.get('ROSTER_DB_PATH')

if not ROSTER_DB_PATH and os.path.exists(path('..', 'admin')):
    ROSTER_DB_PATH = path('..', 'admin', 'roster.db')

if not ROSTER_DB_PATH:
    print "The 'admin' directory does not appear to be alongside "
    print "this one, and ROSTER_DB_PATH isn't defined! Please ensure "
    print "at least one of these conditions is satisfied."
    sys.exit(1)

_engine = None
_Session = None

def get_engine():
    global _engine

    if _engine is None:
        _engine = create_engine('sqlite:///%s' % ROSTER_DB_PATH)
    return _engine

def get_session():
    global _Session

    if _Session is None:
        _Session = sessionmaker(bind=get_engine())
    return _Session()

if __name__ == '__main__':
    print 'Using the database at %s.' % ROSTER_DB_PATH
