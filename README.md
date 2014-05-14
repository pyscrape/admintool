## Requirements

* Python 2.7
* [pip and virtualenv][]
* The [swcarpentry/admin][] repository

## Quick Start

Things will work most smoothly if your admin repository is reachable at
`../admin` relative to this repository. If it's not, you should set
your `SWCARPENTRY_ADMIN_PATH` environment variable to the location of
the admin repository on your machine.

Then, from the root directory of this repository, run:

```
virtualenv venv
source venv/bin/activate
pip install -r requirements.txt
python app.py
```

At this point you can visit http://127.0.0.1:5000/ to use the web
interface.

  [pip and virtualenv]: http://flask.pocoo.org/docs/installation/#virtualenv
  [swcarpentry/admin]: https://github.com/swcarpentry/admin
