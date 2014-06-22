#!/usr/bin/env python
# -*- coding: utf-8 -*-

""" test_config.py

Testing configurations
"""


from unittest import TestCase

from config import config
class TestConfig(TestCase):

    def test_default(self):
        "Test default (development) config"
        obj = config['default']
        self.assertTrue(obj.DEBUG)
        self.assertFalse(obj.TESTING)

    def test_testing(self):
        "Test testing config"
        obj = config['testing']
        self.assertTrue(obj.DEBUG)
        self.assertTrue(obj.TESTING)

    def test_production(self):
        "Test production config"
        obj = config['production']
        self.assertFalse(obj.DEBUG)
        self.assertFalse(obj.TESTING)
