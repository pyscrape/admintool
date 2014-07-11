#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
from admintool import create_app, create_dbs
from admintool.models import Airport, Event, Facts, Person, Site, Task

from flask.ext.script import Manager, Shell

create_dbs()
app = create_app(os.getenv('FLASK_CONFIG') or 'default')

manager = Manager(app)

def make_shell_context():
    return dict(app=app,
                Airport=Airport,
                Event=Event,
                Facts=Facts,
                Person=Person,
                Site=Site,
                Task=Task)

manager.add_command('shell', Shell(make_context=make_shell_context))

if __name__ == '__main__':
    manager.run()