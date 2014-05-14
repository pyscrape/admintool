import os
from flask import Flask, render_template

import db

app = Flask(__name__)

@app.route('/')
def home():
    session = db.get_session()
    return render_template('index.html')

class Config(object):
    DEBUG = True
    TESTING = True
    PROPAGATE_EXCEPTIONS = True

if __name__ == '__main__':
    if not os.path.exists(db.ROSTER_DB_PATH):
        db.create_roster_db()

    app.config.from_object(Config)
    app.run()
