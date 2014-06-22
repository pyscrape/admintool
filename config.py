#!/usr/bin/env python
# -*- coding: utf-8 -*-

class Config(object):
    """Base Configuration, all higher Configs should inherit"""
    DEBUG = True
    TESTING = True
    PROPAGATE_EXCEPTIONS = True


class Development(Config):
    TESTING = False

class Testing(Config):
    pass

class Production(Config):
    DEBUG = False
    TESTING = False
    PROPAGATE_EXCEPTIONS = False

config = {'default': Development,
          'testing': Testing,
          'production': Production}
