#!/usr/bin/env python
# -*- coding: utf-8 -*-
import os

from flask import Flask
from flask_httpauth import HTTPTokenAuth

app = Flask(__name__)
auth = HTTPTokenAuth("Token")


@auth.verify_token
def verify_token(token):
    return token == os.getenv("TOKEN")

@app.route("/")
@auth.login_required
def main_route():
   return "server flying!!"

@app.route("/health")
def health_route():
   return "it's alive"

if __name__ == '__main__':
    app.run("0.0.0.0", port=80)
