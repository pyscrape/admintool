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
	@echo 'event.site not in sites:'
	@sqlite3 roster.db "select event.site from event where event.site not in (select distinct(Site.site) from Site);"
	@echo 'task.event not in events:'
	@sqlite3 roster.db "select task.event from task where task.event not in (select distinct(event.event) from event);"
	@echo 'task.person not in persons:'
	@sqlite3 roster.db "select task.person from task where task.person not in (select distinct(person.slug) from person);"
	@echo 'task.task not recognized:'
	@sqlite3 roster.db "select * from task where task.task not in ('organizer','host','helper','instructor','learner','tutor');"
	@echo 'trainee.cohort not in cohorts:'
	@sqlite3 roster.db "select trainee.cohort from trainee where trainee.cohort not in (select distinct(Cohort.cohort) from Cohort);"
	@echo 'trainee.person not in persons:'
	@sqlite3 roster.db "select trainee.person from trainee where trainee.person not in (select distinct(person.slug) from person);"
	@echo 'awards.badge not in badges:'
	@sqlite3 roster.db "select awards.badge from awards where awards.badge not in (select distinct(badges.badge) from badges);"
	@echo 'awards.person not in persons:'
	@sqlite3 roster.db "select awards.person from awards where awards.person not in (select distinct(person.slug) from person);"
	@echo 'facts.airport not in airports:'
	@sqlite3 roster.db "select facts.airport from Facts where facts.airport not in (select distinct(Airport.iata) from Airport);"
	@echo 'facts.person not in persons:'
	@sqlite3 roster.db "select facts.person from Facts where facts.person not in (select distinct(person) from person);"
	@echo 'Unused people:'
	@sqlite3 roster.db "select person from person where person not in (select distinct person from task union select distinct person from trainee union select distinct person from awards union select distinct person from Facts);"
	@echo 'Spaces in person identifiers:'
	@sqlite3 roster.db "select person from person where person like '% %';"
	@echo 'Spaces in event identifiers:'
	@sqlite3 roster.db "select event from event where event like '% %';"
	@echo 'Backward personal identifiers:'
	@sqlite3 roster.db "select person from person where person.person=lower(person.personal||'.'||person.family) and (person.personal!=person.family);"
	@echo 'Lowercase names:'
	@sqlite3 roster.db "select * from person where person.personal=lower(person.personal) or person.family=lower(person.family);"
	@echo 'Learners who were instructors or helpers:'
	@sqlite3 roster.db "select a.event, a.person, a.task, b.task from task a join task b on a.event=b.event and a.person=b.person and a.task='learner' and b.task in ('instructor', 'helper');"

#----------------------------------------
# Boot camps.
##---------------------------------------

## workshop-ids         : All boot camp IDs.
workshop-ids : roster.db
	@sqlite3 roster.db "select event.event from event order by event.event;"

## workshop-eventbrite  : All boot camp EventBrite IDs.
workshop-eventbrite : roster.db
	@sqlite3 roster.db "select event.event || ' ' || event.eventbrite from event where event.eventbrite is not null order by event.event;"

## workshop-instructors : Who taught which workshops?
workshop-instructors : roster.db
	@sqlite3 roster.db "select event.event, group_concat(person.personal || ' ' || person.family, ', ') from event join person join task on task.person=person.ident and task.event=event.ident where task.task='instructor' group by event.event order by event.startdate;"

## workshop-unknown     : Boot camps that are in events, but don't have any assigned tasks.
workshop-unknown : roster.db
	@sqlite3 roster.db "select event.event from event where event.ident not in (select distinct(task.event) from task);"

## workshop-people      : Number of known participants by workshop.
workshop-people : roster.db
	@sqlite3 roster.db "select event.event, count(*) from task join person join event on event.ident=task.event and task.person=person.ident where task.task='learner' and event.startdate < date('now') group by event.event order by event.event;"

## workshop-attendance  : Reported registration figures.
workshop-attendance : roster.db
	@sqlite3 roster.db "select event.event, event.attendance from event where event.attendance is not null order by event.event;"

## workshop-accum       : Cumulative number of workshops.
workshop-accum : roster.db
	@sqlite3 roster.db "select e1.startdate, count(e2.startdate) from event e1 join event e2 on (e1.startdate||e1.event)>=(e2.startdate||e2.event) group by e1.startdate, e1.event order by e1.startdate, e1.event;" | sed -e 's/|/,/g'

#----------------------------------------
# Enrolment.
##---------------------------------------

## enrolment-missing    : Missing registration figures
enrolment-missing : roster.db
	@sqlite3 roster.db "select event.event from event where event.attendance is null and event.startdate < date('now');"

## enrolment-accum      : Cumulative enrolment.
enrolment-accum : roster.db
	@sqlite3 roster.db "select e1.startdate, sum(e2.attendance) from event e1 join event e2 on (e1.startdate||e1.event)>=(e2.startdate||e2.event) where (e1.attendance is not null) and (e2.attendance is not null) group by e1.startdate, e1.event order by e1.startdate, e1.event;" | sed -e 's/|/,/g'

## enrolment-monthly    : Monthly enrolment totals.
enrolment-monthly : roster.db
	@sqlite3 roster.db "select key, sum(attendance) from (select substr(startdate, 1, 4)||'-'||substr(startdate,6,2) as key, attendance from event where attendance is not null) group by key;" | sed -e 's/|/,/g'

## enrolment-compare    : Compare total enrolment with listed number of learners.
enrolment-compare : roster.db
	@sqlite3 roster.db "select event.event, coalesce(event.attendance, '-'), count(*) from event join task on event.ident=task.event and task.task='learner' group by task.event;"

#----------------------------------------
# Instructors.
##---------------------------------------

## instructors-count    : Who has taught how many times?
instructors-count : roster.db
	@sqlite3 roster.db "select person.personal || ' ' || person.family || ': ' || count(*) from person join task join event on person.ident=task.person and task.event=event.ident where task.task='instructor' and event.startdate <= date('now') group by person.ident order by count(*) desc, person.family, person.personal;"

## instructors-never    : Which instructors have never taught?
instructors-never : roster.db
	@sqlite3 roster.db "select person.personal || ' ' || person.family || ' <' || person.email || '>' from person join awards on person.ident=awards.person where awards.badge='instructor' and person.ident not in (select distinct person from task where task='instructor');"

## instructors-missing  : What workshops don't have any instructors listed?
instructors-missing : roster.db
	@sqlite3 roster.db "select distinct event from event where ident not in (select distinct event from task where task='instructor');"

## instructors-unbadged : Who's going to teach a boot camp but doesn't have a badge yet?
instructors-unbadged : roster.db
	@sqlite3 roster.db "select distinct person.personal || ' ' || person.family || ' <' || person.email || '>' from person join task join event on person.ident=task.person and task.event=event.event where task.task='instructor' and event.startdate >= date('now') and person.ident not in (select person from awards where awards.badge='instructor') order by person.family, person.personal;"

## instructors-where    : Which instructors' locations aren't recorded?
instructors-where : roster.db
	@sqlite3 roster.db "select person.personal || ' ' || person.family || ' <' || person.email || '>' from person join awards on person.ident=awards.person where awards.badge='instructor' and ((person.ident not in (select person from facts)) or (person.ident in (select person from facts where facts.airport is null)));"

#----------------------------------------
# Flags.
##---------------------------------------

## flags-workshops      : What countries have we run workshops in?
flags-workshops : roster.db
	@sqlite3 roster.db "select distinct country from site where (ident in (select distinct site from event)) and country is not null order by country;"

## flags-instructors    : What countries are instructors from?
flags-instructors : roster.db
	@sqlite3 roster.db "select distinct country from airport where airport.ident in (select distinct airport from facts) and country is not null order by country;"

#----------------------------------------
# Training course.
##---------------------------------------

## training-count       : how many people are enrolled in training?
training-count : roster.db
	@sqlite3 roster.db "select cohort.cohort || ' (' || cohort.startdate || '): ' || count(*) from cohort join trainee on cohort.ident=trainee.cohort group by cohort.cohort order by cohort.cohort;"

## training-inactive    : who is still listed as incomplete for closed training?
training-inactive : roster.db
	@sqlite3 roster.db "select cohort.cohort || ': ' || person.personal || ' ' || person.family || ' <' || person.email || '>' from cohort join trainee join person on cohort.ident=trainee.cohort and trainee.person=person.ident where (not cohort.active) and (trainee.status is null) order by cohort.cohort, person.slug;"

#----------------------------------------
# badges.
##---------------------------------------

## badges               : what badges do we hand out, and why?
badges : roster.db
	@sqlite3 roster.db "select badges.title || ': ' || badges.criteria from badges;"

## awards-made          : who has been awarded what?
awards-made : roster.db
	@sqlite3 roster.db "select person.personal || ' ' || person.family || ': ' || group_concat(badges.title, ', ') from person join awards join badges on person.ident=awards.person and awards.badge=badges.ident where awards.awarded is not null group by person.ident order by person.family, person.personal;"

## awards-pending       : who is to be awarded what?
awards-pending : roster.db
	@sqlite3 roster.db "select person.personal || ' ' || person.email || ' ' || badges.badge || ' (' || awards.comment || ')' from person join awards join badges on person.ident=awards.person and awards.badge=badges.ident where awards.awarded is null;"

#----------------------------------------

# Rebuild the roster database.
roster.db : roster.sql
	@rm -f roster.db
	@sqlite3 roster.db < roster.sql

clean :
	@rm -f roster.db *.pyc *~

test :
	nosetests
