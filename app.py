from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello():
    return "TODO: Put something here."

if __name__ == '__main__':
    app.run()
