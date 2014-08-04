# encoding: utf-8
import nose.tools as nt

import roster


def test_ascii_slugify():
    nt.assert_equal(roster._ascii_slugify(u'asdf'), 'asdf')
    nt.assert_equal(roster._ascii_slugify(u'^aSDf   \t$$&*#@'), 'asdf')
    nt.assert_equal(roster._ascii_slugify(u'asૐdf'), 'asdf')
    nt.assert_equal(roster._ascii_slugify(u'ૐ'), '')
    nt.assert_equal(
        roster._ascii_slugify(u'asૐdf    \t$$$ qwerty'), 'asdf-qwerty')


def test_unique_name_id():
    nt.assert_equal(roster.unique_name_id('asdf', 'qwerty'), 'qwerty.asdf')
    nt.assert_equal(roster.unique_name_id('marie', 'curie'), 'curie.marie.1')
    nt.assert_equal(roster.unique_name_id(u'márie', u'cürie'), 'curie.marie.1')

    with nt.assert_raises(ValueError):
        roster.unique_name_id(u'ૐ', 'qwerty')

    with nt.assert_raises(ValueError):
        roster.unique_name_id('qwerty', u'ૐ')
