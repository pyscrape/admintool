import os
from flask import Flask

import db

app = Flask(__name__)

@app.route('/')
def hello():
    session = db.get_session()
    return "TODO: Put something here."

class Config(object):
    DEBUG = True
    TESTING = True
    PROPAGATE_EXCEPTIONS = True

if __name__ == '__main__':
    if not os.path.exists(db.ROSTER_DB_PATH):
        db.create_roster_db()

    app.config.from_object(Config)
    app.run()
