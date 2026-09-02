# CONTEXT

The project's shared vocabulary, and the principles that judge a product decision. Agents read
this so that spec wording, test names and issue titles all use the same words for the same
things. Maintained by the `grill` skill as domain understanding develops — add a term when you
catch yourself explaining it twice, one term per thing. Product definition began 2026-08-24; the
first domain terms were agreed on 2026-08-28 with `EPIC: Daily commitments` (#1).

## Process vocabulary

**Epic** — a body of work spanning several capabilities. A GitHub issue of type `Epic`, with no
anchor on disk; pure coordination.

**Feature** — one capability. A GitHub issue of type `Feature`, one-to-one with
`openspec/specs/<capability>/spec.md`. The **spec** lives forever; the **issue** closes when no
open Story remains under it and reopens when a new one is cut, so that `open` keeps one meaning
across all three levels. `docs/agents/issue-tracker.md` § *Closing the hierarchy*.

**Story** — one unit of implementable work. A GitHub issue of type `Task`, one-to-one with an
OpenSpec change, a branch and a pull request.

**Want** — one thing the owner has said the application should let them do, in their own
words, before anyone has agreed to build it. An entry in `docs/backlog.md`, written by
`/atlas idea`. A want is not a requirement: it is evidence of what was asked for, and it is
deliberately never paraphrased into spec wording, because the paraphrase is what a later grill
would have to argue against.

**Backlog** — `docs/backlog.md`, the wants and nothing else. Not a plan, not an order of work,
and not a place anything is implemented from. An entry leaves it only through a grooming pass.

**Grooming** — the pass `/atlas backlog` runs over the backlog: sweep for the commitments and
lifecycle verbs that have no want against them at all, cluster the wants by the capability they
would land in, propose a promotion, a merge, a split or a drop for each, grill the cluster you
take forward, and stop at G1. The sweep comes first and is the only step in the process that
asks what is *missing* rather than whether what is present is coherent. It is a stop, not a gate — no marker, no CI check,
no G-number — and it adds exactly one stop in front of Stage 1 rather than a stage of its own.

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

## Product principles

The rules a want is judged against. These are not backlog entries — they are what decides
whether one is any good, which is why they live here rather than in `docs/backlog.md`. The
first four were agreed 2026-08-28 with `EPIC: Daily commitments` (#1); each later one says when.

**Nothing congratulates you.** No streaks, no gamification, no celebration of a run of good
days. A row that has been ticked just goes quiet. This is not a stylistic preference: streaks
are the mechanic the owner abandoned other apps over, because breaking one is a reason to stop
using the app, and a product built on the durability of a record cannot afford that.

**Five percent of seven things, not all of one.** A thin version of every commitment beats a
deep version of a single one. A want that deepens something already thin is worth less than a
want that makes a new thing possible at all, and a Feature that proposes to do one thing
thoroughly is usually the wrong slice.

**An iPhone, in your hand.** Every one of the five daily visits happens with a phone in hand,
never at a laptop. A want whose interaction only makes sense on a large screen is not this
product's want. ADR-1001.

**Restore, not sync.** History survives moving to a new phone. Live synchronisation between two
devices is out of scope, and saying so is what keeps it out.

**Entered where you stand.** Every daily entry is made on the day screen, in the row, with as
little interaction as the value allows: a tick is one tap, a number is a few, a sentence is typed
there and not somewhere else. A want that puts a second screen into the daily visit is judged
against this and usually loses; a screen for *looking* is not a daily visit and is not what this
rules out. Agreed 2026-09-02 at the first grooming pass, from a want that turned out to be a rule
rather than a thing to build — "little interaction needed (e.g. just multiple buttons to add
things each day, without much navigation)".

## Domain vocabulary

**Commitment** — something you have decided you owe yourself on a recurring rhythm: the gym,
the monthly finances, watering the plants. It is defined once and recurs indefinitely. It is
deliberately not a *task*, which is completed once and then gone; not a *habit*, which fits
supplements but not finances; and not an *area*, a word tried first and dropped because it was
covering three unlike behaviours at once. It is made of three things and no others: a name, the
schedule it runs on, and the day it is kept from. From that day onwards it is due exactly when
its schedule is, and it adds nothing of its own to that answer. It carries no identifier: two
commitments alike in all three are the same commitment, and telling apart two a person
deliberately kept separate is a property of whatever stores them, not of the commitment.

**Commitment name** — the words a person gave a commitment, and the only part of one that is
not a rule. It has to say something: a name that is empty, or made only of blank space, names
nothing and is refused, the same refusal that stops 30 February being a calendar date. Anything
else is a name — there is no length limit, no restricted script and no reserved word, because
the name is the owner's own words rather than the system's.

**Kept from** — the day a person began keeping a commitment, and the day from which it can be
owed: before it the commitment is not due, whatever its schedule says. It is what stops a
commitment written down today reading as missed on every matching day since 1583, because an
unticked due day is what a miss looks like. It is deliberately not the day the commitment was
entered into the app — someone who has kept the gym since June says June — and it is a floor
rather than a rhythm: it need not be a day the schedule is due on, and it does not move the
schedule to begin there. Distinct from a **start date**, which an every-N-days schedule carries
for a different job; a commitment can hold both, and they can disagree. ADR-1013.

**Schedule** — the rule attached to a commitment that decides which days it is due on. Four
shapes are known to be needed: a set of weekdays, every N days, a day of the month, and N
times within a week on any days.

**Due** — a commitment is due on a day when that day's date satisfies its schedule and is not
earlier than the day the commitment is kept from. Whether a commitment is due is a question
asked *of a date*, not of the present moment. A schedule on its own is also said to be due on a
date, meaning only the first half of that: the rules in `schedule` answer for every date the
system supports, and the floor belongs to the commitment carrying one. Due says the day is one
the commitment runs on; it does not say the commitment is still owed. For three of the four
schedule shapes those two readings coincide. For a weekly quota they come apart, and telling them
apart needs ticks rather than a date — ADR-1014.

**Record** — what a day holds for a commitment: the durable fact that, on that calendar date,
the commitment was kept. It is keyed to the date and never to the time it was entered, there is
at most one per commitment per day, and it survives the app being closed and opened again —
durability is a property of the record, not of some store behind it, because a record a few
days old that cannot be reconstructed is the failure the product exists to remove. A tick is
the plain kind; a number or a sentence would be other kinds, and none of those exists yet.
Agreed 2026-09-02 at the first grooming pass, with `FEAT: record`.

**Tick** — to record that a due commitment was done, and the plain kind of record that
results. A tick is of a *due* commitment: a day on which the commitment is not due takes no
tick. The past is writable: a day other than today can be ticked.

**History** — every tick there is, across all commitments and all days, held together so that
one question can be asked of it: was this commitment *kept* on this date? It answers from the ticks
it holds and from nothing else — a commitment it has never seen is simply not kept, and a day the
commitment is not due on is answered *not kept* rather than refused, because telling *not due* apart
from *missed* is the asker's job with the commitment's own answer beside it. It holds at most one
tick per commitment per day, so ticking a day twice is one tick, and it is a value: two histories
holding the same ticks are the same history, whatever order they were ticked in. Deliberately not
the **store**, which is where a history survives the app being closed and is #56's to define.
Agreed 2026-09-02 at the grill of `add-tick-record` (#55).

**Untick** — to take a tick back, leaving the history as though that tick had never been: the
commitment is not kept on that day, every other tick stands, and nothing remembers that the tick was
ever there — an untick is not a record of its own. Taking back a tick that was never there is
nothing rather than an error. It exists because a tick is one tap on a phone, and a tap that cannot
be undone turns every mis-tap into a permanent false record. Proposed 2026-09-02 at the grill of
`add-tick-record` (#55) and settled by the owner the same day, in answer to its question round.

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
tick moves it and no past day's answer changes once given. Distinct from the day a commitment is
**kept from**: the start date sets which dates the rhythm lands on, the kept-from day suppresses
landings earlier than itself, and an interval commitment carries both.

**Day of the month** — the third of the four schedule shapes: a single day number a commitment
runs on in every month. "Finances every 25th" is one. A month too short to hold the number is due
on its last day rather than skipped, so a commitment on the 31st comes due once in February too,
and every month has exactly one due date.

**Weekly quota** — the fourth and last of the schedule shapes: a number of times a commitment is
owed within a week, on any days of it. "Reading 3x a week" is one. It is the only shape that
constrains *how many times* rather than *which days*, so it runs on every day of every week and its
number says nothing about which of them. That number is one to seven: a day holds at most one
record of a commitment, so a week holds at most seven, and a quota of seven means one on each
day — which a weekday set of all seven and an interval of one day also mean, and three rules having
the same effect is not a contradiction. Whether a week's quota has been met is not something the
schedule knows, because it is a fact about ticks rather than about a date; a quota of seven and a
quota of one are the same answer to `isDue(on:)`. Where a week begins is deliberately still
undecided: no rule shape consults it yet, so nothing in the engine can settle it.

**Rule engine** — the pure logic that answers whether a commitment is due, with no UI and no
storage under it. It lives in the `DayByDayKit` Swift package and is driven from the terminal by
`swift test`.
