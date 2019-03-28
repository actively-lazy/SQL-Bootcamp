-- These questions start off really basic and then get continually more difficult:
--
--     How can you retrieve all the information from the cd.facilities table?
--     You want to print out a list of all of the facilities and their cost to members. How would you retrieve a list of only facility names and costs?
--     How can you produce a list of facilities that charge a fee to members?
--     How can you produce a list of facilities that charge a fee to members, and that fee is less than 1/50th of the monthly maintenance cost? Return the facid, facility name, member cost, and monthly maintenance of the facilities in question.
--     How can you produce a list of all facilities with the word 'Tennis' in their name?
--     How can you retrieve the details of facilities with ID 1 and 5? Try to do it without using the OR operator.
--     How can you produce a list of members who joined after the start of September 2012? Return the memid, surname, firstname, and joindate of the members in question.
--     How can you produce an ordered list of the first 10 surnames in the members table? The list must not contain duplicates.
--     You'd like to get the signup date of your last member. How can you retrieve this information?
--     Produce a count of the number of facilities that have a cost to guests of 10 or more.
--     Skip this one, no question for #11.
--     Produce a list of the total number of slots booked per facility in the month of September 2012. Produce an output table consisting of facility id and slots, sorted by the number of slots.
--     Produce a list of facilities with more than 1000 slots booked. Produce an output table consisting of facility id and total slots, sorted by facility id.
--     How can you produce a list of the start times for bookings for tennis courts, for the date '2012-09-21'? Return a list of start time and facility name pairings, ordered by the time.
--     How can you produce a list of the start times for bookings by members named 'David Farrell'?

--1
SELECT *
FROM cd.facilities;

--2
SELECT name,
	membercost
FROM cd.facilities;

--3
SELECT *
FROM cd.facilities
WHERE membercost > 0;

--4
SELECT facid,
	name,
	membercost,
	monthlymaintenance
FROM cd.facilities
WHERE membercost < monthlymaintenance / 50;

--5
SELECT name
FROM cd.facilities
WHERE name LIKE '%Tennis%';

--6
SELECT *
FROM cd.facilities
WHERE facid IN (1, 5);

--7
SELECT memid,
	surname,
	firstname,
	joindate
FROM cd.members
WHERE joindate > '2012-09-1';

--8
SELECT DISTINCT (surname)
FROM cd.members
ORDER BY surname limit 10;

--9
SELECT joindate
FROM cd.members
ORDER BY joindate DESC limit 1;

--10
SELECT count(*)
FROM cd.facilities
WHERE guestcost >= 10;

--11
--12
SELECT facid,
	sum(slots) AS "Total Slots"
FROM cd.bookings
WHERE starttime >= '2012-09-01'
	AND starttime < '2012-10-01'
GROUP BY facid
ORDER BY sum(slots);

--13
SELECT fac.facid,
	fac.name,
	sum(slots)
FROM cd.bookings AS bok
JOIN cd.facilities AS fac ON bok.facid = fac.facid
GROUP BY fac.facid
HAVING sum(slots) > 1000;

--14
SELECT bok.starttime AS start,
	fac.name AS name
FROM cd.facilities AS fac
JOIN cd.bookings AS bok ON fac.facid = bok.facid
WHERE fac.name LIKE '%Tennis%Court%'
	AND bok.starttime >= '2012-09-21'
	AND bok.starttime < '2012-09-22'
ORDER BY bok.starttime;

--15
SELECT bok.starttime
FROM cd.bookings AS bok
WHERE bok.memid = (
		SELECT memid
		FROM cd.members
		WHERE firstname = 'David'
			AND surname = 'Farrell'
		);
