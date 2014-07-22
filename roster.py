import os
from hashlib import md5
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship, backref
from sqlalchemy import Column, Text, Date, Integer, \
                       Float, Boolean, ForeignKey

from distance import distance_on_unit_sphere

Base = declarative_base()

class Site(Base):
    __tablename__ = 'Site'

    id = Column('site', Text, nullable=False, primary_key=True)
    fullname = Column(Text, nullable=False, unique=True)
    country = Column(Text)

class Event(Base):
    __tablename__ = 'Event'

    startdate = Column(Date, nullable=False)
    enddate = Column(Date)
    id = Column('event', Text, nullable=False, primary_key=True)
    site_id = Column('site', Text, ForeignKey('Site.site'), nullable=False)
    details_url = Column(Text, unique=True)
    eventbrite = Column(Text, unique=True)
    # paytype = Column(Text)
    # payamount = Column(Text)
    # fundtype = Column(Text)
    attendance = Column(Integer)

    site = relationship('Site', backref=backref('events'))

class Person(Base):
    __tablename__ = 'Person'

    id = Column('person', Text, nullable=False, primary_key=True)
    personal = Column(Text, nullable=False)
    middle = Column(Text)
    family = Column(Text, nullable=False)
    email = Column(Text, nullable=False, unique=True)

    def email_hash(self):
        return md5(self.email.lower().strip()).hexdigest()

class Task(Base):
    __tablename__ = 'Task'

    event_id = Column('event', Text, ForeignKey('Event.event'),
                      nullable=False, primary_key=True)
    person_id = Column('person', Text, ForeignKey('Person.person'),
                       nullable=False, primary_key=True)
    role = Column('task', Text, nullable=False, primary_key=True)

    event = relationship('Event', backref=backref('tasks'))
    person = relationship('Person', backref=backref('tasks'))

# TODO: Cohort
# TODO: Trainee
# TODO: Badges
# TODO: Awards

class Airport(Base):
    __tablename__ = 'Airport'

    iata = Column(Text, nullable=False, primary_key=True)
    fullname = Column(Text, nullable=False)
    country = Column(Text, nullable=False)
    latitude = Column(Float, nullable=False)
    longitude = Column(Float, nullable=False)

    def is_within_radius_of(self, radius, latitude, longitude, **kwargs):
        return distance_on_unit_sphere(
            self.latitude,
            self.longitude,
            latitude,
            longitude,
            **kwargs
        ) <= radius

    def distance_from(self, latitude, longitude, **kwargs):
        return distance_on_unit_sphere(
            self.latitude,
            self.longitude,
            latitude,
            longitude,
            **kwargs)


class Facts(Base):
    __tablename__ = 'Facts'

    person_id = Column('person', Text, ForeignKey('Person.person'),
                       nullable=False, primary_key=True)
    active = Column(Boolean, nullable=False)
    airport_id = Column('airport', Text, ForeignKey('Airport.iata'))
    github = Column(Text, unique=True)
    twitter = Column(Text, unique=True)
    site = Column(Text)
    python = Column(Boolean, nullable=False)
    r = Column(Boolean, nullable=False)
    unix = Column(Boolean, nullable=False)
    git = Column(Boolean, nullable=False)
    db = Column(Boolean, nullable=False)

    person = relationship('Person', backref=backref('facts', uselist=False))
    airport = relationship('Airport')

    @property
    def skills(self):
        return ', '.join([
            skill for skill in ['python', 'r', 'unix', 'git', 'db']
            if getattr(self, skill)
        ])

if __name__ == '__main__':
    import db

    session = db.get_session()

    for person in session.query(Person):
        print "  %s %s" % (person.personal, person.family),
        if person.facts:
            print "(%s)" % person.facts.skills,
            if person.facts.twitter:
                print "(@%s)" % person.facts.twitter
            else:
                print
        else:
            print
