import os
from werkzeug.serving import run_simple
from werkzeug.wrappers import Request, Response

import app

# https://github.com/mitsuhiko/werkzeug/blob/master/examples/httpbasicauth.py
class Application(object):
    def __init__(self, users, realm='login required'):
        self.users = users
        self.realm = realm

    def check_auth(self, username, password):
        return username in self.users and self.users[username] == password

    def auth_required(self, request):
        return Response('Could not verify your access level for that URL.\n'
                        'You have to login with proper credentials', 401,
                        {'WWW-Authenticate': 'Basic realm="%s"' % self.realm})

    def dispatch_request(self, request):
        return Response('Logged in as %s' % request.authorization.username)

    def __call__(self, environ, start_response):
        request = Request(environ)
        auth = request.authorization
        if not auth or not self.check_auth(auth.username, auth.password):
            response = self.auth_required(request)
        else:
            response = app.app
        return response(environ, start_response)

if __name__ == '__main__':
    BIND_ADDRESS = os.environ.get('BIND_ADDRESS', 'localhost')
    PORT = int(os.environ.get('PORT', '5000'))
    USER, PASS = os.environ.get('USERPASS', ':').split(':')

    if not USER or not PASS:
        raise Exception('Invalid setting for USERPASS.')

    app.create_dbs()
    application = Application({USER: PASS})
    run_simple(BIND_ADDRESS, PORT, application)
