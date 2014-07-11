#!/usr/bin/env python
# -*- coding: utf-8 -*-

""" test_models.py

Model testing
"""


from unittest import TestCase

from admintool.models import Airport


class AirportTest(TestCase):

    def test_distance_from(self):
        bos = Airport(latitude=42.3631, longitude=71.0064)
        lga = Airport(latitude=40.7772, longitude=73.8726)
        # via http://www.nhc.noaa.gov/gccalc.shtml, these two points
        # are 184 mi or 297 km apart (both rounded)
        mi_compute = bos.distance_from(lga.latitude, lga.longitude, units='mi')
        self.assertEqual(round(mi_compute), 184)

        km_compute = bos.distance_from(lga.latitude, lga.longitude, units='km')
        self.assertEqual(round(km_compute), 297)
