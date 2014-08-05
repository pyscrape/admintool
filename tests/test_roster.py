# encoding: utf-8
import os
import nose.tools as nt

import db
import roster

setup = db.setup
teardown = db.teardown

def test_ascii_slugify():
    nt.assert_equal(roster._ascii_slugify(u'asdf'), 'asdf')
    nt.assert_equal(roster._ascii_slugify(u'^aSDf   \t$$&*#@'), 'asdf')
    nt.assert_equal(roster._ascii_slugify(u'asૐdf'), 'asdf')
    nt.assert_equal(roster._ascii_slugify(u'ૐ'), '')
    nt.assert_equal(
        roster._ascii_slugify(u'asૐdf    \t$$$ qwerty'), 'asdf-qwerty')


def test_unique_name_id():
    s = db.get_session()
    try:
        nt.assert_equal(roster.unique_name_id('asdf', 'qwerty', s), 'qwerty.asdf')
        nt.assert_equal(roster.unique_name_id('marie', 'curie', s), 'curie.marie.1')
        nt.assert_equal(roster.unique_name_id(u'márie', u'cürie', s), 'curie.marie.1')

        with nt.assert_raises(ValueError):
            roster.unique_name_id(u'ૐ', 'qwerty', s)

        with nt.assert_raises(ValueError):
            roster.unique_name_id('qwerty', u'ૐ', s)
    finally:
        s.close()
