#!/usr/bin/env python
# -*- coding: utf-8 -*-


from unittest import TestCase

import cities
class TestCities(TestCase):

    def test_find(self):
        cities.create_db()
        query = cities.find('London')
        results = list(query)
        self.failIf(len(results) == 0)
        full_names = [c.full_name for c in results]
        self.failIf('London, ENG (United Kingdom)' not in full_names)

