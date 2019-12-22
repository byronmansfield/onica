#!/usr/bin/env python3

from flask import Flask, request

app = Flask(__name__)


@app.route("/")
def hello():
    return "Hello World from %s" % request.remote_addr


@app.route("/status")
def status():
    return "I'm Alive!"


if __name__ == "__main__":
    app.run()
