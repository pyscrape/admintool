-- Where have we run events?
CREATE TABLE Site(
       site     text NOT NULL,     -- top-level domain of site
       fullname text NOT NULL,     -- full human-readable name
       country  text,              -- hyphenated country name for flags (NULL if no country)
       primary key(site),
       unique(fullname)
);

INSERT INTO "Site" VALUES('esu.fake','Euphoric State University','United-States');
INSERT INTO "Site" VALUES('gh.fake','Grace Hopper University','United-States');
INSERT INTO "Site" VALUES('goldberg.fake','Goldberg University','United-States');
INSERT INTO "Site" VALUES('jvnc.fake','John von Neumann College','Hungary');
INSERT INTO "Site" VALUES('tmu.fake','Turing Memorial University','United-Kingdom');

-- What individual events have we run?
CREATE TABLE Event(
       startdate  date NOT NULL,   -- start date
       enddate    date,            -- end date (NULL for a one-day event)
       event      text NOT NULL,   -- event name
       site       text,            -- host site/organization
       eventbrite text,            -- EventBrite registration key (NULL if we're not using EB)
       attendance integer,         -- how many people came (NULL if we don't (yet) know)
       primary key(event),
       foreign key(site) references Site(site),
       unique(eventbrite)
);

INSERT INTO "Event" VALUES('2011-11-07','2011-11-08','2011-11-07-euphoric','esu.fake',NULL,NULL);
INSERT INTO "Event" VALUES('2012-01-18','2012-01-19','2012-01-18-esu','esu.fake',NULL,14);
INSERT INTO "Event" VALUES('2013-02-06','2013-02-07','2013-02-06-turing','tmu.fake','333444333',47);
INSERT INTO "Event" VALUES('2013-02-16','2013-02-17','2013-02-16-turing','tmu.fake','333444555',31);
INSERT INTO "Event" VALUES('2013-02-16',NULL,'2013-02-16-jvnc','jvnc.fake','222333444',NULL);
INSERT INTO "Event" VALUES('2013-09-06','2013-09-07','2013-02-09-tmu','tmu.fake','444555555',21);
INSERT INTO "Event" VALUES('2013-10-17','2013-10-26','2013-10-17-grace-hopper','gh.fake','999888777',36);
INSERT INTO "Event" VALUES('2014-02-23','2014-02-24','2014-02-23-esu','esu.fake','111222333',28);
INSERT INTO "Event" VALUES('2014-05-10','2014-05-12','2014-05-10-turing','tmu.fake','555666777',NULL);

CREATE TABLE Person(
       person   text NOT NULL,     -- identifier (lastname.initial or lastname.firstname)
       personal text NOT NULL,     -- personal (first) name
       middle   text,              -- middle name (usually NULL)
       family   text NOT NULL,     -- family (last) name
       email    text,              -- email address (NULL if we're getting bounces)
       primary key(person),
       unique(email),
       unique(person)
);

INSERT INTO "Person" VALUES('bell.j','Jocelyn',NULL,'Bell','bell@fake.net');
INSERT INTO "Person" VALUES('blackburn.elizabeth','Elizabeth',NULL,'Blackburn','eb@fake.net');
INSERT INTO "Person" VALUES('buck.l','Linda',NULL,'Buck','buck@fake.net');
INSERT INTO "Person" VALUES('cox.a','Allan',NULL,'Cox','cox@fake.net');
INSERT INTO "Person" VALUES('curie.marie','Marie',NULL,'Curie-Sklodowska','marie@fake.net');
INSERT INTO "Person" VALUES('elion.gertrude','Gertrude',NULL,'Elion','ge@also-fake.net');
INSERT INTO "Person" VALUES('franklin.rosalind','Rosalind',NULL,'Franklin','rf2@also-fake.net');
INSERT INTO "Person" VALUES('garrett-anderson.e','Elizabeth',NULL,'Garrett Anderson','ega@also-fake.net');
INSERT INTO "Person" VALUES('goeppert-mayer.maria','Maria',NULL,'Goeppert-Mayer',NULL);
INSERT INTO "Person" VALUES('greider.carol','Carol',NULL,'Greider','carol.greider@not-real.net');
INSERT INTO "Person" VALUES('hodgkin.d','Dorothy',NULL,'Hodgkin','dh@not-real.net');
INSERT INTO "Person" VALUES('jackson.shirley','Shirley',NULL,'Jackson','shirleyjackson@not-real.net');
INSERT INTO "Person" VALUES('joliot-curie.irene','Irene',NULL,'Joliot-Curie','irene@joliot-curie.net');
INSERT INTO "Person" VALUES('levi-montalcini.rita','Rita',NULL,'Levi-Montalcini','rlm@not-real.net');
INSERT INTO "Person" VALUES('mcclintock.b','Barbara',NULL,'McClintock',NULL);
INSERT INTO "Person" VALUES('meitner.l','Lise',NULL,'Meitner','meitner@fake.net');
INSERT INTO "Person" VALUES('nusslein-volhard.christiane','Christiane',NULL,'Nusslein-Volhard','scientist@fake.net');
INSERT INTO "Person" VALUES('voeller.bruce','Bruce',NULL,'Voeller','bruce@also-fake.net');
INSERT INTO "Person" VALUES('wu.cs','Chien-Shiung',NULL,'Wu','wu@fake.net');
INSERT INTO "Person" VALUES('yalow.rosalyn','Rosalyn',NULL,'Yalow','rosalyn@fake.net');

-- Who has done what for us?
CREATE TABLE Task(
       event  text NOT NULL,       -- event identifier
       person text NOT NULL,       -- personal identifier
       task   text NOT NULL,       -- what they did ('instructor', 'helper', 'organizer', 'host', 'learner')
       primary key(event, person, task),
       foreign key(event) references Event(event),
       foreign key(person) references Person(person)
);

INSERT INTO "Task" VALUES('2011-11-07-euphoric','bell.j','instructor');
INSERT INTO "Task" VALUES('2011-11-07-euphoric','elion.gertrude','learner');
INSERT INTO "Task" VALUES('2011-11-07-euphoric','hodgkin.d','instructor');
INSERT INTO "Task" VALUES('2011-11-07-euphoric','jackson.shirley','learner');
INSERT INTO "Task" VALUES('2012-01-18-esu','bell.j','instructor');
INSERT INTO "Task" VALUES('2012-01-18-esu','blackburn.elizabeth','learner');
INSERT INTO "Task" VALUES('2012-01-18-esu','buck.l','learner');
INSERT INTO "Task" VALUES('2012-01-18-esu','cox.a','learner');
INSERT INTO "Task" VALUES('2012-01-18-esu','curie.marie','instructor');
INSERT INTO "Task" VALUES('2012-01-18-esu','elion.gertrude','helper');
INSERT INTO "Task" VALUES('2012-01-18-esu','franklin.rosalind','learner');
INSERT INTO "Task" VALUES('2012-01-18-esu','garrett-anderson.e','learner');
INSERT INTO "Task" VALUES('2012-01-18-esu','joliot-curie.irene','learner');
INSERT INTO "Task" VALUES('2013-02-06-turing','elion.gertrude','instructor');
INSERT INTO "Task" VALUES('2013-02-06-turing','levi-montalcini.rita','learner');
INSERT INTO "Task" VALUES('2013-02-09-tmu','curie.marie','learner');
INSERT INTO "Task" VALUES('2013-02-09-tmu','elion.gertrude','instructor');
INSERT INTO "Task" VALUES('2013-02-09-tmu','garrett-anderson.e','learner');
INSERT INTO "Task" VALUES('2013-02-09-tmu','meitner.l','learner');
INSERT INTO "Task" VALUES('2013-02-16-jvnc','curie.marie','instructor');
INSERT INTO "Task" VALUES('2013-02-16-jvnc','voeller.bruce','host');
INSERT INTO "Task" VALUES('2013-02-16-jvnc','voeller.bruce','learner');
INSERT INTO "Task" VALUES('2013-02-16-turing','cox.a','instructor');
INSERT INTO "Task" VALUES('2013-02-16-turing','curie.marie','learner');
INSERT INTO "Task" VALUES('2013-02-16-turing','mcclintock.b','learner');
INSERT INTO "Task" VALUES('2013-10-17-grace-hopper','bell.j','instructor');
INSERT INTO "Task" VALUES('2013-10-17-grace-hopper','goeppert-mayer.maria','learner');
INSERT INTO "Task" VALUES('2013-10-17-grace-hopper','greider.carol','learner');
INSERT INTO "Task" VALUES('2013-10-17-grace-hopper','jackson.shirley','helper');
INSERT INTO "Task" VALUES('2013-10-17-grace-hopper','nusslein-volhard.christiane','learner');
INSERT INTO "Task" VALUES('2014-02-23-esu','hodgkin.d','instructor');
INSERT INTO "Task" VALUES('2014-02-23-esu','wu.cs','learner');
INSERT INTO "Task" VALUES('2014-05-10-turing','hodgkin.d','instructor');
INSERT INTO "Task" VALUES('2014-05-10-turing','yalow.rosalyn','learner');

-- What training classes have we run?
CREATE TABLE Cohort(
       startdate  date NOT NULL, -- start date
       cohort     text NOT NULL, -- name of cohort
       mode       text NOT NULL, -- 'live' or 'online'
       primary key(cohort)
);

INSERT INTO "Cohort" VALUES('2011-01-01','online-01','online');
INSERT INTO "Cohort" VALUES('2012-01-01','live-01','online');
INSERT INTO "Cohort" VALUES('2013-01-01','online-02','online');
INSERT INTO "Cohort" VALUES('2014-01-01','online-03','online');

-- Who was trained when?
CREATE TABLE Trainee(
       person  text NOT NULL,   -- person in group
       cohort  text NOT NULL,   -- group name
       status  text,            -- 'complete', 'incomplete', or NULL if in progress or not yet started
       primary key(person, cohort),
       foreign key(person) references Person(person),
       foreign key(cohort) references Cohort(cohort)
);

INSERT INTO "Trainee" VALUES('bell.j','online-01','complete');
INSERT INTO "Trainee" VALUES('cox.a','online-01','complete');
INSERT INTO "Trainee" VALUES('curie.marie','online-01','incomplete');
INSERT INTO "Trainee" VALUES('curie.marie','live-01','complete');
INSERT INTO "Trainee" VALUES('elion.gertrude','online-02','complete');
INSERT INTO "Trainee" VALUES('hodgkin.d','online-02','complete');
INSERT INTO "Trainee" VALUES('nusslein-volhard.christiane','online-03',NULL);
INSERT INTO "Trainee" VALUES('wilson.g','online-01','incomplete');
INSERT INTO "Trainee" VALUEs('wilson.g','online-03',NULL);

-- What badges do we give out?
CREATE TABLE Badges(
       badge       text NOT NULL,  -- badge identifier
       title       text NOT NULL,  -- human-readable name
       criteria    text NOT NULL,  -- what it's given for
       primary key(badge),
       unique(title)
);

INSERT INTO "Badges" VALUES('creator','Creator','Creating learning materials and other content');
INSERT INTO "Badges" VALUES('instructor','Instructor','Teaching at workshops or online');
INSERT INTO "Badges" VALUES('organizer','Organizer','Organizing workshops and learning groups');

-- What badges have we awarded?
CREATE TABLE Awards(
       person      text NOT NULL,  -- person the badge was given to
       badge       text NOT NULL,  -- badge given
       awarded     date,           -- if NULL, award is pending
       pending     text,           -- if award date is null, this is what we're waiting on
       primary key(person, badge),
       foreign key(badge)  references Badge(badge),
       foreign key(person) references Person(person)
);

INSERT INTO "Awards" VALUES('bell.j','instructor','2011-06-01',NULL);
INSERT INTO "Awards" VALUES('cox.a','instructor','2011-07-01',NULL);
INSERT INTO "Awards" VALUES('curie.marie','instructor','2012-05-15',NULL);
INSERT INTO "Awards" VALUES('elion.gertrude','instructor','2013-09-15',NULL);
INSERT INTO "Awards" VALUES('hodgkin.d','instructor','2013-05-09',NULL);
INSERT INTO "Awards" VALUES('voeller.bruce','organizer',NULL,'should he be host or organizer?');

-- What airports are people near?
CREATE TABLE Airport(
       iata      text NOT NULL,     -- IATA 3-letter code
       fullname  text NOT NULL,     -- airport name
       country   text NOT NULL,     -- country name (hyphenated to match flag names)
       latitude  real NOT NULL,     -- latitude
       longitude real NOT NULL,     -- longitude
       primary key(iata)
);

INSERT INTO "Airport" VALUES('AUS','Austin','United-States',30.194444,-97.669722);
INSERT INTO "Airport" VALUES('BNE','Brisbane','Australia',-27.384167,153.1175);
INSERT INTO "Airport" VALUES('DFW','Dallas Fort Worth','United-States',32.896389,-97.0375);

CREATE TABLE Facts(
       person    text NOT NULL,  -- who
       gender    TEXT NOT NULL,  -- M, F, or O
       active    bool NOT NULL,  -- still with us?
       airport   text,           -- where
       github    text,           -- GitHub ID
       twitter   text,           -- Twitter ID
       site      text,           -- site URL
       python    bool,           -- can teach Python
       r         bool,           -- can teach R
       unix      bool,           -- can teach Unix
       git       bool,           -- can teach Git
       db        bool,           -- can teach SQL and databases
       primary key(person),
       foreign key(person) references Person(person),
       unique(github),
       unique(twitter)
);


INSERT INTO "Facts" VALUES('bell.j','F',1,'AUS','gitbell','tweetbell','http://fake.net/bell',1,0,1,1,1);
INSERT INTO "Facts" VALUES('cox.a','F',0,'BNE','gitcox','tweetcox','http://fake.net/cox',0,1,1,1,1);
INSERT INTO "Facts" VALUES('curie.marie','F',1,'DFW','gitcurie','tweetcurie','http://fake.net/curie',1,1,1,1,1);
INSERT INTO "Facts" VALUES('hodgkin.d','F',1,'AUS','githodgkin','tweethodgkin','http://fake.net/hodgkin',1,0,1,0,1);
INSERT INTO "Facts" VALUES('wilson.g','M',1,'BNE','gitwilson','tweetwilson','http://fake.net/wilson',1,0,1,0,0);
