# CONTEXT

The project's shared vocabulary. Agents read this so that spec wording, test names and issue
titles all use the same words for the same things. Maintained by the `grill` skill as
domain understanding develops — add a term when you catch yourself explaining it twice, one term
per thing. Product definition began 2026-08-24; the first domain terms were agreed on 2026-08-28
with `EPIC: Daily commitments` (#1).

## Process vocabulary

**Epic** — a body of work spanning several capabilities. A GitHub issue of type `Epic`, with no
anchor on disk; pure coordination.

**Feature** — one capability. A GitHub issue of type `Feature`, one-to-one with
`openspec/specs/<capability>/spec.md`. The **spec** lives forever; the **issue** closes when no
open Story remains under it and reopens when a new one is cut, so that `open` keeps one meaning
across all three levels. `docs/agents/issue-tracker.md` § *Closing the hierarchy*.

**Story** — one unit of implementable work. A GitHub issue of type `Task`, one-to-one with an
OpenSpec change, a branch and a pull request.

**Change** — OpenSpec's unit of work: the folder `openspec/changes/<change-id>/` holding a
proposal, delta specs, a design and a task list. One change is one Story.

**Delta spec** — the part of a change describing only what is changing, as `ADDED`, `MODIFIED`
or `REMOVED` requirements, rather than restating a whole spec.

**Capability** — a domain grouping of behaviour, one directory under `openspec/specs/`.

**Scenario** — a concrete Given/When/Then example proving a requirement. Each maps to exactly one
acceptance test of the same name. ADR-0005.

**Seam** — the public boundary a test observes behaviour at. Named in a change's `design.md`
before any test is written.

**G4** — the spec-approval gate. Nothing is implemented before it. `docs/process.md` §4.

## Domain vocabulary

**Commitment** — something you have decided you owe yourself on a recurring rhythm: the gym,
the monthly finances, watering the plants. It is defined once and recurs indefinitely. It is
deliberately not a *task*, which is completed once and then gone; not a *habit*, which fits
supplements but not finances; and not an *area*, a word tried first and dropped because it was
covering three unlike behaviours at once.

**Schedule** — the rule attached to a commitment that decides which days it is due on. Four
shapes are known to be needed: a set of weekdays, every N days, a day of the month, and N
times within a week on any days.

**Due** — a commitment is due on a day when that day's date satisfies its schedule. Whether a
commitment is due is a question asked *of a date*, not of the present moment.

**Tick** — to record that a due commitment was done. The past is writable: a day other than
today can be ticked.

**Day** — the unit the product is organised around. The landing screen is one day, and every
record is keyed to a date rather than to the time it was entered.

**Calendar date** — a year, a month of that year and a day of that month: the argument every
due-ness question is asked about. It carries no clock, no time zone and no locale, and a
combination that names no day — 30 February — is not one. Its year runs from 1583 to 9999
inclusive: the weekday comes from a calendar that is Julian before the Gregorian reform of
15 October 1582, and 1583 is the first year that is Gregorian throughout. Drawing the bound at a
whole year refuses the tail of 1582 as well, which is a trade taken knowingly. Deliberately not
an instant; ADR-1004.

**Weekday set** — the first of the four schedule shapes: the days of the week a commitment runs
on, as a set. "Gym Mon/Wed/Sat" is one. Membership is the whole rule, so a set of all seven is
due every day and an empty set is due on none.

**Every N days** — the second of the four schedule shapes: an interval of a whole number of days,
counted from a start date. "Contact lenses every 14 days" is one. The interval counts calendar days
and nothing else, so it drifts across weekdays and months rather than lining up with either, and the
leap day of a leap year counts as a day like any other. A commitment on one is due on its start date
and on every date a whole number of intervals after it, and on no date before it. An interval of one
day is legal and means every day — a weekday set of all seven says the same thing, and two rules
having the same effect is not a contradiction.

**Start date** — the day an every-N-days schedule begins counting from. It is the only thing a
schedule carries that the calendar does not supply: a weekday set and a day of the month are
functions of the calendar alone, and an interval is not — it needs a reference point of its own.
`isDue(on:)` is still pure for this shape, exactly as for the other two: the start date is part of
the schedule value, not something the rule reaches outside itself for. It is a calendar date, so it
names a day that exists inside the supported years, and it is fixed: it is not the last tick, so no
tick moves it and no past day's answer changes once given.

**Day of the month** — the third of the four schedule shapes: a single day number a commitment
runs on in every month. "Finances every 25th" is one. A month too short to hold the number is due
on its last day rather than skipped, so a commitment on the 31st comes due once in February too,
and every month has exactly one due date.

**Rule engine** — the pure logic that answers whether a commitment is due, with no UI and no
storage under it. It lives in the `DayByDayKit` Swift package and is driven from the terminal by
`swift test`.
