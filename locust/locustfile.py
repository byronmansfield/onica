#!/usr/bin/env python3

"""
Locust Load Test for Onica Code Exercise
"""

from locust import HttpLocust, TaskSet, Task

import gevent
import time
import json
import random


class UserBehavior(TaskSequence):


    def __init__(self, parent):
        super(UserBehavior, self).__init__(parent)
        self.headers = {}


    def on_start(self):
        self.headers = {"Content-Type":"application/json", "User-Agent":"locust"}


    @task
    def index(self):
        self.client.get("/")


class WebsiteUser(HttpLocust):
    task_set = UserBehavior
    min_wait = 2000
    max_wait = 4000
