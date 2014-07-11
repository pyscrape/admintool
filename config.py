#!/usr/bin/env python
# -*- coding: utf-8 -*-
import os

class Config(object):
    """Base Configuration, all higher Configs should inherit"""
    DEBUG = True
    TESTING = True
    PROPAGATE_EXCEPTIONS = True
    SECRET_KEY = 'totallynotuseableinproduction'

    @staticmethod
    def init_app(app):
        pass

class Development(Config):
    TESTING = False

class Testing(Config):
    pass

class Production(Config):
    DEBUG = False
    TESTING = False
    PROPAGATE_EXCEPTIONS = False
    SECRET_KEY = os.environ.get('SECRET_KEY')  # don't use base SECRET_KEY in prod

config = {'default': Development,
          'testing': Testing,
          'production': Production}
