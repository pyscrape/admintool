import os
import sys
import sqlite3

if len(sys.argv) < 2:
    print "usage: %s </path/to/roster.sql>" % sys.argv[0]
    sys.exit(1)

print "creating roster.db."

conn = sqlite3.connect('roster.db')
c = conn.cursor()

c.executescript(open(sys.argv[1]).read())
c.close()

print "done."
