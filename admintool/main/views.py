#!/usr/bin/env python
# -*- coding: utf-8 -*-

import json
from flask import render_template, request, abort, Response

from ..models import Person, Facts
from ..utils import safe_float, safe_int
from .. import db

from . import main
from . import cities


@main.route('/cities.json')
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


@main.route('/')
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

    return render_template('main/index.html', people=people)
