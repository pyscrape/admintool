import os
from flask import Flask, render_template, request

import db
import cities
from roster import Person, Facts

app = Flask(__name__)

@app.route('/')
def home():
    python = bool(request.args.get('python'))
    r = bool(request.args.get('r'))

    people = db.get_session().query(Person).join(Person.facts).\
             filter(Facts.active == True)

    if python:
        people = people.filter(Facts.python == True)
    if r:
        people = people.filter(Facts.r == True)

    return render_template('index.html', people=people)

class Config(object):
    DEBUG = True
    TESTING = True
    PROPAGATE_EXCEPTIONS = True

if __name__ == '__main__':
    cities.create_db()
    if not os.path.exists(db.ROSTER_DB_PATH):
        db.create_roster_db()

    app.config.from_object(Config)
    app.run()
