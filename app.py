import os
import json
from flask import Flask, render_template, request, abort, Response

import db
import cities
from roster import Person, Facts
from utils import safe_float, safe_int

app = Flask(__name__)

@app.route('/cities.json')
def cities_json():
    MIN_QUERY_LENGTH = 2
    NUM_RESULTS = 5

    query = request.args.get('q', '')
    if len(query) < MIN_QUERY_LENGTH: abort(400)
    return Response(json.dumps([
        {'name': city.full_name,
         'lat': city.latitude,
         'long': city.longitude}
        for city in cities.find(query)[:NUM_RESULTS]
    ]), mimetype='application/json')


@app.route('/')
def home():
    latitude = safe_float(request.args.get('city_lat'))
    longitude = safe_float(request.args.get('city_long'))
    radius = safe_int(request.args.get('radius'))
    closest = safe_int(request.args.get('closest'))
    python = bool(request.args.get('python'))
    r = bool(request.args.get('r'))

    people = db.get_session().query(Person).join(Person.facts).\
             join(Facts.airport).\
             filter(Facts.active == True)

    if python:
        people = people.filter(Facts.python == True)
    if r:
        people = people.filter(Facts.r == True)

    if latitude is not None and longitude is not None and radius:
        people = (
            person for person in people
            if person.facts.airport.is_within_radius_of(
                radius,
                latitude,
                longitude,
                units='km'
            )
        )
    elif latitude is not None and longitude is not None and closest:
        # not searching radius but rather closest people
        people = sorted(people,
            key=lambda x: x.facts.airport.distance_from(latitude, longitude))[:closest]

    return render_template('index.html', people=people)

def create_dbs():
    cities.create_db()
    if not os.path.exists(db.ROSTER_DB_PATH):
        db.create_roster_db()

if __name__ == '__main__':
    create_dbs()

    from config import config
    config_name = os.environ.get('FLASK_CONFIG', 'default')
    app.config.from_object(config[config_name])
    app.run()
