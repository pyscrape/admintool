admintool
=========

An administration tool for Software Carpentry bootcamps.

## Goals

A dummy database is stored (as SQL) in `roster.sql`,
and queries that we commonly run against it are stored in `Makefile`.
(Run `make` on its own in the root directory to see a list of targets.)
We would eventually like this tool to be able to display all the things the `Makefile` can,
and also allow:

1.  Manual entry of individual records in all of the database tables.
2.  Batch entry of people and tasks from CSV files in the style of the [Add Multiple Users][] plugin for WordPress.

## Quick Start

1.  Install [SQLAlchemy][], [Flask][], and [Nose][].
2.  `python app.py`.
3.  Go to [http://127.0.0.1:5000/](http://127.0.0.1:5000/).

## A Better Way

1.  Install [pip and virtualenv][].
2.  `virtualenv venv`
3.  `source venv/bin/activate`
4.  `pip install -r requirements.txt`
5.  `python app.py`
6.  Go to [http://127.0.0.1:5000/](http://127.0.0.1:5000/).

## Running Tests

Just run `nosetests` from the root of the repository.

## Environment Variables

The following environment variables can be set to change the behavior
of the app.

* `SWCARPENTRY_ADMIN_PATH` is a path to a directory containing
  `roster.sql`, and in which `roster.db` will be created if it
  doesn't already exist. By default, it's the same as the root directory of
  the repository, in which case test data will be used.

* `FLASK_CONFIG` is the base server configuration to use. It can be
  `default`, `testing`, or `production`; by default, it's `default`.

<!-- Links -->

  [Add Multiple Users]: http://addmultipleusers.happynuclear.com/
  [SQLAlchemy]: http://www.sqlalchemy.org/
  [Flask]: http://flask.pocoo.org/
  [Nose]: https://nose.readthedocs.org/
  [pip and virtualenv]: http://flask.pocoo.org/docs/installation/#virtualenv
  [swcarpentry/admin]: https://github.com/swcarpentry/admin
