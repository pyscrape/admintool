import os
import sys
import db
import sqlite3

ROSTER_SQL_PATH = os.path.join(os.path.dirname(db.ROSTER_DB_PATH),
                               'roster.sql')

print "Reading from %s." % ROSTER_SQL_PATH
print "Creating %s." % db.ROSTER_DB_PATH

conn = sqlite3.connect(db.ROSTER_DB_PATH)
c = conn.cursor()
c.executescript(open(ROSTER_SQL_PATH).read())
c.close()

print "Done."
