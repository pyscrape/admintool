import os
from flask import Flask

from config import config

def create_app(config_name):
    app = Flask(__name__)

    # configuration
    config_object = config[config_name]

    app.config.from_object(config_object)
    config_object.init_app(app)

    # Init Extensions


    # Init Blueprints
    from .main import main as main_bp
    app.register_blueprint(main_bp)

    return app

def create_dbs():
    from .main import cities
    from . import db
    cities.create_db()
    if not os.path.exists(db.ROSTER_DB_PATH):
        db.create_roster_db()
