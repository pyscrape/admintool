-- Where have we run events?
CREATE TABLE site(
    ident    integer not null,  -- site serial number
    site     text not null,     -- top-level domain of site
    fullname text not null,     -- full human-readable name
    country  text,              -- hyphenated country name for flags (NULL if no country)
    primary key(ident),
    unique(site),
    unique(fullname)
);

INSERT INTO "site" VALUES(1,'esu.fake','Euphoric State University','United-States');
INSERT INTO "site" VALUES(2,'gh.fake','Grace Hopper University','United-States');
INSERT INTO "site" VALUES(3,'goldberg.fake','Goldberg University','United-States');
INSERT INTO "site" VALUES(4,'jvnc.fake','John von Neumann College','Hungary');
INSERT INTO "site" VALUES(5,'tmu.fake','Turing Memorial University','United-Kingdom');

-- What individual events have we run?
CREATE TABLE event(
    ident      integer not null,  -- event serial number
    startdate  date not null,     -- start date
    enddate    date,              -- end date (NULL for a one-day event)
    event      text not null,     -- event name
    site       integer not null,  -- ident of host site/organization
    kind       text,              -- 'SWC', 'DC', 'LC', 'WiSE'
    eventbrite text,              -- EventBrite registration key (NULL if we're not using EB)
    attendance integer,           -- how many people came? (Specifically, how many people were still there on day two?)
    primary key(ident),
    foreign key(site) references site(ident),
    unique(event),
    unique(eventbrite)
);

INSERT INTO "event" VALUES(1,'2011-11-07','2011-11-08','2011-11-07-euphoric',1,'SWC',NULL,NULL);
INSERT INTO "event" VALUES(2,'2012-01-18','2012-01-19','2012-01-18-esu',1,'SWC',NULL,14);
INSERT INTO "event" VALUES(3,'2013-02-06','2013-02-07','2013-02-06-turing',5,'SWC','333444333',47);
INSERT INTO "event" VALUES(4,'2013-02-16','2013-02-17','2013-02-16-turing',5,'SWC','333444555',31);
INSERT INTO "event" VALUES(5,'2013-02-16',NULL,'2013-02-16-jvnc',4,'DC','222333444',NULL);
INSERT INTO "event" VALUES(6,'2013-09-06','2013-09-07','2013-02-09-tmu',5,'SWC','444555555',21);
INSERT INTO "event" VALUES(7,'2013-10-17','2013-10-26','2013-10-17-grace-hopper',2,'SWC','999888777',36);
INSERT INTO "event" VALUES(8,'2014-02-23','2014-02-24','2014-02-23-esu',1,'SWC','111222333',28);
INSERT INTO "event" VALUES(9,'2014-05-10','2014-05-12','2014-05-10-turing',5,'SWC','555666777',NULL);

-- Who do we know?
CREATE TABLE person(
    ident    integer not null,  -- person serial number
    slug     text,              -- identifier (lastname.initial or lastname.firstname)
    personal text not null,     -- personal (first) name
    middle   text,              -- middle name (usually NULL)
    family   text not null,     -- family (last) name
    email    text,              -- email address (NULL if we're getting bounces)
    primary key(ident),
    unique(slug),
    unique(email)
);

INSERT INTO "person" VALUES(0,'wilson.g','Greg',NULL,'Wilson','gvwilson@third-bit.com');
INSERT INTO "person" VALUES(1,'bell.j','Jocelyn',NULL,'Bell','bell@fake.net');
INSERT INTO "person" VALUES(2,'blackburn.elizabeth','Elizabeth',NULL,'Blackburn','eb@fake.net');
INSERT INTO "person" VALUES(3,'buck.l','Linda',NULL,'Buck','buck@fake.net');
INSERT INTO "person" VALUES(4,'cox.a','Allan',NULL,'Cox','cox@fake.net');
INSERT INTO "person" VALUES(5,'curie.marie','Marie',NULL,'Curie-Sklodowska','marie@fake.net');
INSERT INTO "person" VALUES(8,'elion.gertrude','Gertrude',NULL,'Elion','ge@also-fake.net');
INSERT INTO "person" VALUES(12,'franklin.rosalind','Rosalind',NULL,'Franklin','rf2@also-fake.net');
INSERT INTO "person" VALUES(13,'garrett-anderson.e','Elizabeth',NULL,'Garrett Anderson','ega@also-fake.net');
INSERT INTO "person" VALUES(14,'goeppert-mayer.maria','Maria',NULL,'Goeppert-Mayer',NULL);
INSERT INTO "person" VALUES(19,'greider.carol','Carol',NULL,'Greider','carol.greider@not-real.net');
INSERT INTO "person" VALUES(20,'hodgkin.d','Dorothy',NULL,'Hodgkin','dh@not-real.net');
INSERT INTO "person" VALUES(21,'jackson.shirley','Shirley',NULL,'Jackson','shirleyjackson@not-real.net');
INSERT INTO "person" VALUES(22,'joliot-curie.irene','Irene',NULL,'Joliot-Curie','irene@joliot-curie.net');
INSERT INTO "person" VALUES(23,'levi-montalcini.rita','Rita',NULL,'Levi-Montalcini','rlm@not-real.net');
INSERT INTO "person" VALUES(24,'mcclintock.b','Barbara',NULL,'McClintock',NULL);
INSERT INTO "person" VALUES(25,'meitner.l','Lise',NULL,'Meitner','meitner@fake.net');
INSERT INTO "person" VALUES(30,'nusslein-volhard.christiane','Christiane',NULL,'Nusslein-Volhard','scientist@fake.net');
INSERT INTO "person" VALUES(31,'voeller.bruce','Bruce',NULL,'Voeller','bruce@also-fake.net');
INSERT INTO "person" VALUES(32,'wu.cs','Chien-Shiung',NULL,'Wu','wu@fake.net');
INSERT INTO "person" VALUES(33,'yalow.rosalyn','Rosalyn',NULL,'Yalow','rosalyn@fake.net');

-- Who had done what?
CREATE TABLE task(
    event  integer not null,  -- event identifier
    person integer not null,  -- personal identifier
    task   text not null,     -- what they did
    primary key(event, person, task),
    foreign key(event) references event(ident),
    foreign key(person) references person(ident)
);

INSERT INTO "task" VALUES(1,1,'instructor');
INSERT INTO "task" VALUES(1,8,'learner');
INSERT INTO "task" VALUES(1,20,'instructor');
INSERT INTO "task" VALUES(1,21,'learner');
INSERT INTO "task" VALUES(2,1,'instructor');
INSERT INTO "task" VALUES(2,2,'learner');
INSERT INTO "task" VALUES(2,3,'learner');
INSERT INTO "task" VALUES(2,4,'learner');
INSERT INTO "task" VALUES(2,5,'instructor');
INSERT INTO "task" VALUES(2,8,'helper');
INSERT INTO "task" VALUES(2,12,'learner');
INSERT INTO "task" VALUES(2,13,'learner');
INSERT INTO "task" VALUES(2,22,'learner');
INSERT INTO "task" VALUES(3,8,'instructor');
INSERT INTO "task" VALUES(3,23,'learner');
INSERT INTO "task" VALUES(6,5,'learner');
INSERT INTO "task" VALUES(6,8,'instructor');
INSERT INTO "task" VALUES(6,13,'learner');
INSERT INTO "task" VALUES(6,25,'learner');
INSERT INTO "task" VALUES(5,5,'instructor');
INSERT INTO "task" VALUES(5,31,'host');
INSERT INTO "task" VALUES(5,31,'learner');
INSERT INTO "task" VALUES(4,4,'instructor');
INSERT INTO "task" VALUES(4,5,'learner');
INSERT INTO "task" VALUES(4,24,'learner');
INSERT INTO "task" VALUES(7,1,'instructor');
INSERT INTO "task" VALUES(7,14,'learner');
INSERT INTO "task" VALUES(7,19,'learner');
INSERT INTO "task" VALUES(7,21,'helper');
INSERT INTO "task" VALUES(7,30,'learner');
INSERT INTO "task" VALUES(8,20,'instructor');
INSERT INTO "task" VALUES(8,32,'learner');
INSERT INTO "task" VALUES(9,20,'instructor');
INSERT INTO "task" VALUES(9,33,'learner');

-- What instructor training sessions have we run?
CREATE TABLE cohort(
    ident      integer not null,  -- person serial number
    startdate  date not null,     -- start date
    cohort     text not null,     -- name of cohort
    venue      text not null,     -- 'online' or a site name
    active     int  not null,     -- still running?
    primary key(cohort)
);

INSERT INTO "cohort" VALUES(1,'2011-01-01','online-01','online',0);
INSERT INTO "cohort" VALUES(2,'2012-01-01','live-01','online',0);
INSERT INTO "cohort" VALUES(4,'2013-01-01','online-02','online',0);
INSERT INTO "cohort" VALUES(6,'2014-01-01','online-03','online',1);

-- Who was trained when?
CREATE TABLE trainee(
    person  integer not null,  -- who
    cohort  integer not null,  -- cohort
    status  text,              -- 'complete', 'incomplete', or NULL if in progress or not yet started
    primary key(person, cohort),
    foreign key(person) references person(ident),
    foreign key(cohort) references cohort(ident)
);

INSERT INTO "trainee" VALUES(0,1,'complete');
INSERT INTO "trainee" VALUES(1,1,'complete');
INSERT INTO "trainee" VALUES(4,1,'complete');
INSERT INTO "trainee" VALUES(5,1,'incomplete');
INSERT INTO "trainee" VALUES(5,2,'complete');
INSERT INTO "trainee" VALUES(8,4,'complete');
INSERT INTO "trainee" VALUES(20,4,NULL);
INSERT INTO "trainee" VALUES(30,6,NULL);
INSERT INTO "trainee" VALUES(0,6,NULL);

-- What badges do we give out?
CREATE TABLE badges(
    ident    integer not null,  -- person serial number
    badge    text not null,     -- badge identifier
    title    text not null,     -- human-readable name
    criteria text not null,     -- what it's given for
    primary key(ident),
    unique(title)
);

INSERT INTO "badges" VALUES(1,'creator','Creator','Creating learning materials and other content');
INSERT INTO "badges" VALUES(2,'instructor','Instructor','Teaching at workshops or online');
INSERT INTO "badges" VALUES(3,'organizer','Organizer','Organizing workshops and learning groups');

-- What badges have we awarded?
CREATE TABLE awards(
    person      text not null,  -- person the badge was given to
    badge       text not null,  -- badge given
    awarded     date,           -- if null, then award is pending
    comment     text,           -- what else do we need to know?
    primary key(person, badge),
    foreign key(person) references person(ident),
    foreign key(badge)  references badges(ident)
);

INSERT INTO "awards" VALUES(1,2,'2011-06-01',NULL);
INSERT INTO "awards" VALUES(4,2,'2011-07-01',NULL);
INSERT INTO "awards" VALUES(5,2,'2012-05-15',NULL);
INSERT INTO "awards" VALUES(8,2,'2013-09-15',NULL);
INSERT INTO "awards" VALUES(20,2,'2013-05-09',NULL);
INSERT INTO "awards" VALUES(31,3,NULL,'should he be host or organizer?');

-- What airports are people near?
CREATE TABLE airport(
    ident     integer not null, -- airport serial number
    iata      text not null,    -- IATA 3-letter code
    fullname  text not null,    -- airport name
    country   text not null,    -- country name (hyphenated to match flag names)
    latitude  real not null,    -- latitude
    longitude real not null,    -- longitude
    primary key(iata)
);

INSERT INTO "airport" VALUES(22,'AUS','Austin','United-States',30.194444,-97.669722);
INSERT INTO "airport" VALUES(12,'BNE','Brisbane','Australia',-27.384167,153.1175);
INSERT INTO "airport" VALUES(2,'DFW','Dallas Fort Worth','United-States',32.896389,-97.0375);

-- Personal details of instructors and other people.
CREATE TABLE facts(
    person    integer not null,  -- who
    gender    text not null,     -- M, F, or O
    active    bool not null,     -- still with us?
    airport   integer,           -- where
    github    text,              -- GitHub ID
    twitter   text,              -- Twitter ID
    site      text,              -- site URL
    primary key(person),
    foreign key(person) references person(ident),
    foreign key(airport) references airport(ident),
    unique(github),
    unique(twitter)
);

INSERT INTO "facts" VALUES(1,'F',1,22,'gitbell','tweetbell','http://fake.net/bell');
INSERT INTO "facts" VALUES(4,'F',0,12,'gitcox','tweetcox','http://fake.net/cox');
INSERT INTO "facts" VALUES(5,'F',1,2,'gitcurie','tweetcurie','http://fake.net/curie');
INSERT INTO "facts" VALUES(20,'F',1,22,'githodgkin','tweethodgkin','http://fake.net/hodgkin');
INSERT INTO "facts" VALUES(0,'M',1,12,'gitwilson','tweetwilson','http://fake.net/wilson');

-- Who can do what?
CREATE TABLE skills(
    person    integer NOT NULL,  -- who
    skill     text NOT NULL,     -- what skill they have
    primary key(person, skill),
    foreign key(person) references person(ident)
);

INSERT INTO "skills" VALUES(1,'Git');
INSERT INTO "skills" VALUES(1,'Python');
INSERT INTO "skills" VALUES(1,'Unix');
INSERT INTO "skills" VALUES(4,'Unix');
INSERT INTO "skills" VALUES(4,'R');
INSERT INTO "skills" VALUES(4,'Git');
INSERT INTO "skills" VALUES(4,'SQL');
INSERT INTO "skills" VALUES(5,'R');
INSERT INTO "skills" VALUES(5,'Mercurial');
INSERT INTO "skills" VALUES(5,'Python');
INSERT INTO "skills" VALUES(5,'Unix');
