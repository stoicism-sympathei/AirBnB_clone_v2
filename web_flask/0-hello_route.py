#!/usr/bin/python3
""" This is the 1st Flask setup script. """

from flask import Flask

app = Flask(__name__)


@app.route('/airbnb-onepage/', strict_slashes=False)
def hello():
    """
        Flask route at /airbnb-onepage/.
        Displays 'Hello HBNB!'.
    """
    return "Hello HBNB!"


if __name__ == '__main__':
    app.run(host="127.0.0.1", port=5000)

