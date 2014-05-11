import os
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, relationship, backref
from sqlalchemy import create_engine, Column, Text, Date, Integer, \
                       Float, Boolean, ForeignKey, Table

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
    eventbrite = Column(Text, unique=True)
    paytype = Column(Text)
    payamount = Column(Text)
    fundtype = Column(Text)
    attendance = Column(Integer)

    site = relationship('Site', backref=backref('events'))

homebase_table = Table('homebase', Base.metadata,
    Column('person', Text, ForeignKey('Person.person'),
           nullable=False, primary_key=True),
    Column('airport', Text, ForeignKey('Airport.iata'),
           nullable=False, primary_key=True)
)

class Person(Base):
    __tablename__ = 'Person'

    id = Column('person', Text, nullable=False, primary_key=True)
    personal = Column(Text, nullable=False)
    middle = Column(Text)
    family = Column(Text, nullable=False)
    email = Column(Text, nullable=False, unique=True)

    airports = relationship('Airport', secondary=homebase_table)

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

    people = relationship('Person', secondary=homebase_table)

class Online(Base):
    __tablename__ = 'Online'

    person_id = Column('person', Text, ForeignKey('Person.person'),
                       nullable=False, primary_key=True)
    github = Column(Text, unique=True)
    twitter = Column(Text, unique=True)
    site = Column(Text)

    person = relationship('Person', backref=backref('online', uselist=False))

class Skills(Base):
    __tablename__ = 'Skills'

    person_id = Column('person', Text, ForeignKey('Person.person'),
                       nullable=False, primary_key=True)
    python = Column(Boolean, nullable=False)
    r = Column(Boolean, nullable=False)
    unix = Column(Boolean, nullable=False)
    git = Column(Boolean, nullable=False)
    db = Column(Boolean, nullable=False)

    person = relationship('Person', backref=backref('skills', uselist=False))

    def __str__(self):
        return ', '.join([
            skill for skill in ['python', 'r', 'unix', 'git', 'db']
            if getattr(self, skill)
        ])

if __name__ == '__main__':
    engine = create_engine('sqlite:///roster.db')
    Session = sessionmaker(bind=engine)
    session = Session()

    for airport in session.query(Airport):
        print "People at %s" % airport.iata
        for person in airport.people:
            print "  %s (%s)" % (person.personal, person.skills),
            if person.online and person.online.twitter:
                print "(@%s)" % person.online.twitter
            else:
                print
