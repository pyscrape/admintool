#----------------------------------------
# Default action.
#----------------------------------------

# Default action is to show all targets.
.default : display-commands

display-commands :
	@fgrep '##' Makefile | grep -v fgrep

#----------------------------------------
# Consistency checking commands.
#----------------------------------------

## check                : Do foreign keys in all tables actually resolve?
check : roster.db
	@echo 'Event.site not in sites:'
	@sqlite3 roster.db "select Event.site from Event where Event.site not in (select distinct(Site.site) from Site);"
	@echo 'Task.event not in events:'
	@sqlite3 roster.db "select Task.event from Task where Task.event not in (select distinct(Event.event) from Event);"
	@echo 'Task.person not in persons:'
	@sqlite3 roster.db "select Task.person from Task where Task.person not in (select distinct(Person.person) from Person);"
	@echo 'Task.task not recognized:'
	@sqlite3 roster.db "select * from Task where Task.task not in ('organizer','host','helper','instructor','learner','tutor');"
	@echo 'Trainee.cohort not in cohorts:'
	@sqlite3 roster.db "select Trainee.cohort from Trainee where Trainee.cohort not in (select distinct(Cohort.cohort) from Cohort);"
	@echo 'Trainee.person not in persons:'
	@sqlite3 roster.db "select Trainee.person from Trainee where Trainee.person not in (select distinct(Person.person) from Person);"
	@echo 'Awards.badge not in badges:'
	@sqlite3 roster.db "select Awards.badge from Awards where Awards.badge not in (select distinct(Badges.badge) from Badges);"
	@echo 'Awards.person not in persons:'
	@sqlite3 roster.db "select Awards.person from Awards where Awards.person not in (select distinct(Person.person) from Person);"
	@echo 'Facts.airport not in airports:'
	@sqlite3 roster.db "select Facts.airport from Facts where Facts.airport not in (select distinct(Airport.iata) from Airport);"
	@echo 'Facts.person not in persons:'
	@sqlite3 roster.db "select Facts.person from Facts where Facts.person not in (select distinct(person) from Person);"
	@echo 'Unused people:'
	@sqlite3 roster.db "select person from Person where person not in (select distinct person from Task union select distinct person from Trainee union select distinct person from Awards union select distinct person from Facts);"
	@echo 'Spaces in person identifiers:'
	@sqlite3 roster.db "select person from Person where person like '% %';"
	@echo 'Spaces in event identifiers:'
	@sqlite3 roster.db "select event from Event where event like '% %';"
	@echo 'Backward personal identifiers:'
	@sqlite3 roster.db "select person from Person where person.person=lower(person.personal||'.'||person.family) and (person.personal!=person.family);"
	@echo 'Lowercase names:'
	@sqlite3 roster.db "select * from Person where person.personal=lower(person.personal) or person.family=lower(person.family);"
	@echo 'Learners who were instructors or helpers:'
	@sqlite3 roster.db "select a.event, a.person, a.task, b.task from Task a join Task b on a.event=b.event and a.person=b.person and a.task='learner' and b.task in ('instructor', 'helper');"

#----------------------------------------
# Boot camps.
##---------------------------------------

## bootcamp-ids         : All boot camp IDs.
bootcamp-ids : roster.db
	@sqlite3 roster.db "select Event.event from Event order by Event.event;"

## bootcamp-eventbrite  : All boot camp EventBrite IDs.
bootcamp-eventbrite : roster.db
	@sqlite3 roster.db "select Event.event || ' ' || Event.eventbrite from Event where Event.eventbrite is not null order by Event.event;"

## bootcamp-instructors : Who taught which bootcamps?
bootcamp-instructors : roster.db
	@sqlite3 roster.db "select Event.event, group_concat(Person.personal || ' ' || Person.family, ', ') from Event join Person join Task where Task.person=Person.person and Task.event=Event.event and Task.task='instructor' group by Event.event order by Event.startdate;"

## bootcamp-unknown     : Boot camps that are in events, but don't have any assigned tasks.
bootcamp-unknown : roster.db
	@sqlite3 roster.db "select Event.event from Event where Event.event not in (select distinct(Task.event) from task);"

## bootcamp-people      : Number of known participants by bootcamp.
bootcamp-people : roster.db
	@sqlite3 roster.db "select Event.event, count(Event.event) from Task join Person join Event where Event.event=Task.event and Task.person=Person.person and Task.task='learner' and Event.startdate < date('now') group by Event.event order by Event.event;"

## bootcamp-attendance  : Reported registration figures.
bootcamp-attendance : roster.db
	@sqlite3 roster.db "select Event.event, Event.attendance from Event where Event.attendance is not NULL order by Event.event;"

## bootcamp-accum       : Cumulative number of bootcamps.
bootcamp-accum : roster.db
	@sqlite3 roster.db "select e1.startdate, count(e2.startdate) from event e1 join event e2 where (e1.startdate||e1.event)>=(e2.startdate||e2.event) group by e1.startdate, e1.event order by e1.startdate, e1.event;" | sed -e 's/|/,/g'

#----------------------------------------
# Enrolment.
##---------------------------------------

## enrolment-missing    : Missing registration figures
enrolment-missing : roster.db
	@sqlite3 roster.db "select Event.event from Event where Event.attendance is NULL and Event.startdate < date('now');"

## enrolment-accum      : Cumulative enrolment.
enrolment-accum : roster.db
	@sqlite3 roster.db "select e1.startdate, sum(e2.attendance) from event e1 join event e2 where e1.attendance is not null and e2.attendance is not null and (e1.startdate||e1.event)>=(e2.startdate||e2.event) group by e1.startdate, e1.event order by e1.startdate, e1.event;" | sed -e 's/|/,/g'

## enrolment-monthly    : Monthly enrolment totals.
enrolment-monthly : roster.db
	@sqlite3 roster.db "select key, sum(attendance) from (select substr(startdate, 1, 4)||'-'||substr(startdate,6,2) as key, attendance from event where attendance is not null) group by key;" | sed -e 's/|/,/g'

## enrolment-compare    : Compare total enrolment with listed number of learners.
enrolment-compare : roster.db
	@sqlite3 roster.db "select Event.event, coalesce(Event.attendance, '-'), count(*) from Event join Task on Event.event=Task.event and Task.task='learner' group by Task.event;"

#----------------------------------------
# Instructors.
##---------------------------------------

## instructors-count    : Who has taught how many times?
instructors-count : roster.db
	@sqlite3 roster.db "select Person.personal || ' ' || Person.family || ': ' || count(*) from Person join Task join Event where Person.person=Task.person and Task.task='instructor' and Task.event=Event.event and Event.startdate <= date('now') group by Person.person order by count(*) desc, Person.family, Person.personal;"

## instructors-never    : Which instructors have never taught?
instructors-never : roster.db
	@sqlite3 roster.db "select Person.personal || ' ' || Person.family || ' <' || Person.email || '>' from Person join Awards where Person.person=Awards.person and Awards.badge='instructor' and Person.person not in (select distinct person from Task where task='instructor');"

## instructors-missing  : What bootcamps don't have any instructors listed?
instructors-missing : roster.db
	@sqlite3 roster.db "select distinct event from event where event not in (select distinct event from task where task='instructor');"

## instructors-unbadged : Who's going to teach a boot camp but doesn't have a badge yet?
instructors-unbadged : roster.db
	@sqlite3 roster.db "select distinct person.personal || ' ' || person.family || ' <' || person.email || '>' from person join task join event where person.person=task.person and task.task='instructor' and task.event=event.event and event.startdate >= date('now') and person.person not in (select person from awards where awards.badge='instructor') order by person.family, person.personal;"

## instructors-where    : Which instructors' locations aren't recorded?
instructors-where : roster.db
	@sqlite3 roster.db "select person.personal || ' ' || person.family || ' <' || person.email || '>' from person join awards where person.person=awards.person and awards.badge='instructor' and ((person.person not in (select person from facts)) or (person.person in (select person from facts where facts.airport is null)));"

#----------------------------------------
# Flags.
##---------------------------------------

## flags-bootcamps      : What countries have we run bootcamps in?
flags-bootcamps : roster.db
	@sqlite3 roster.db "select distinct country from site where site in (select distinct site from event) and country is not null order by country;"

## flags-instructors    : What countries are instructors from?
flags-instructors : roster.db
	@sqlite3 roster.db "select distinct country from airport where airport.iata in (select distinct airport from facts) and country is not null order by country;"

#----------------------------------------
# Training course.
##---------------------------------------

## training-count       : how many people are enrolled in training?
training-count : roster.db
	@sqlite3 roster.db "select Cohort.cohort || ' (' || Cohort.startdate || '): ' || count(*) from Cohort join Trainee on Cohort.cohort=Trainee.cohort group by Cohort.cohort order by Cohort.cohort;"

#----------------------------------------
# Badges.
##---------------------------------------

## badges               : what badges do we hand out, and why?
badges : roster.db
	@sqlite3 roster.db "select Badges.title || ': ' || Badges.criteria from Badges;"

## awards-made          : who has been awarded what?
awards-made : roster.db
	@sqlite3 roster.db "select Person.personal || ' ' || Person.family || ': ' || group_concat(Badges.title, ', ') from Person join Awards join Badges where Person.person=Awards.person and Awards.badge=Badges.badge and Awards.awarded is not NULL group by Person.person order by Person.family, Person.personal;"

## awards-pending       : who is to be awarded what?
awards-pending : roster.db
	@sqlite3 roster.db "select Person.person || ' ' || Person.email || ' ' || Badges.badge || ' (' || Awards.pending || ')' from Person join Awards join Badges on Person.person=Awards.person and Awards.badge=Badges.badge and Awards.awarded is null;"

#----------------------------------------

# Rebuild the roster database.
roster.db : roster.sql
	@rm -f roster.db
	@sqlite3 roster.db < roster.sql

clean :
	@rm -f roster.db *~
