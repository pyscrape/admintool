## Requirements

* Python 2.7
* (Optional) [pip and virtualenv][]
* (Optional) The [swcarpentry/admin][] repository

## Quick Start

If you are using `virtualenv`, go into the root directory of this repository and run:

```
virtualenv venv
source venv/bin/activate
pip install -r requirements.txt
python app.py
```

If you are *not* using `virtualenv`:

1.  Install `SQLAlchemy` and `Flask`.
2.  `python app.py`

Either way, you can then visit http://127.0.0.1:5000/ to use the web
interface.

  [pip and virtualenv]: http://flask.pocoo.org/docs/installation/#virtualenv
  [swcarpentry/admin]: https://github.com/swcarpentry/admin
