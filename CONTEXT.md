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

**Grill** — the interview that settles a thing's edges before anything is written down as a
requirement. It runs twice, both times held by the conductor: over a cluster at Stage 1, and
over one Story at the top of Stage 4, where it closes by writing `grill.md` into the change
folder. It is not a stage and not a gate. `docs/process.md` § *The two grills*.

**Round** — one pass of a grill: the whole frontier asked at once through `AskUserQuestion`, each
question carrying the answer it recommends as its first option, then the frontier recomputed from
what comes back. A grill is rounds until
the frontier is empty. It is one of the three shapes the conductor prints, and the only one that
asks for answers rather than a decision. ADR-1012.

**Residual round** — the question that only becomes visible while the delta is being written,
raised by `spec-author` in `design.md` under `## Questions for you` and relayed as a stop. Named
for what it is: the leftover after the grill, not the grill itself.

**Change** — OpenSpec's unit of work: the folder `openspec/changes/<change-id>/` holding a
proposal, delta specs, a design and a task list, plus the `grill.md` the grill left. One change
is one Story.

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

**Kept until** — the last day a commitment was kept: the other end of the window ADR-1013 opened and
deliberately left half-open. A commitment kept from one day and kept until another was kept on every
date from the first through the second, that second day included, and on no date after it. It is
inclusive because the day a person stops is a day they have already lived — a tick made that morning
has to stay visible on the day it was made, and only the next day is clear.

It is held by the **roster** and never by the commitment, which stays three things. A fourth part
would change a commitment's identity the moment it was stopped, and a tick embeds the whole
commitment by value — so every tick already recorded would be orphaned and the history would read
empty for that commitment on every day it was ever kept. Held one level up, stopping costs the
record nothing and every past day answers exactly as it did. A day once given does not move while
the commitment stays stopped: a commitment already stopped is not stopped again. What clears it is
the person **taking the commitment up again** — offering the roster the same commitment, which puts
it back in the place it was taken on in with its history intact, at the price of the days between
reading as kept once more. **Retiring** is the verb the code uses and **stopping keeping** is the
verb a person uses; they are one act, and the day it names is this one.
ADR-1023, agreed 2026-09-03 at the grill of `add-roster-retirement` (#102).

**Roster** — the commitments a person keeps, held as one ordered set: every commitment that has been
taken on, in the order it was taken on, and never two of the same one. It is the answer to "what do
I keep", the thing a day is drawn from, and the thing a commitment is eventually retired out of. It
is a **value**, like a history and unlike a store — but unlike a history it is not the same whatever
order things arrived in: two rosters holding the same commitments in the same order are the same
roster, and two holding them in a different order are not, because the order is one of the things a
roster holds.

It **refuses a commitment it already holds**, and says so rather than quietly doing nothing. A
commitment carries no identifier, so two alike in name, schedule and the day they are kept from are
the same commitment, and a roster holding both could not be told which of them to stop keeping or
which of them a screen was pointing at. That refusal is the only one it makes: it judges no name, no
schedule and no day — anything that is a commitment at all was already accepted when the commitment
was formed — it sets no limit on how many it holds, and it never asks what day it is. Saying so
matters because doing nothing silently is what a person cannot tell apart from having made a second
commitment.

**Amended 2026-09-03**, at the grill of `add-roster-retirement` (#102). A roster also holds, for each
commitment it has **stopped keeping**, the day that commitment was **kept until** — and so it does
two things it did not do before. It **reads back only what it has not stopped keeping**, because
"what do I keep" is what its list of commitments answers and a stopped commitment is hidden from
that; it still *holds* the stopped one, which is why it still has the place it was taken on in and
why offering that same commitment again **takes it up again** rather than adding a second copy or
being refused — so the refusal it makes on a duplicate is scoped to a commitment it is *keeping*.
And it **answers about a date**: asked what it had not stopped keeping on a calendar date, it gives,
in the order they were taken on, everything it has not stopped and everything whose kept-until day
is that date or later. It judges that date against a
kept-until day and against nothing else — never against a commitment's own day it is kept from,
never against a schedule — so the refusal on a duplicate is no longer the only one it makes, but the
rule that it never asks what day it is, and adds nothing to a commitment's own answer, is unchanged.

The order is **the order they were taken on** and nothing the system worked out: not alphabetical,
which would be a rule about the owner's own words, and not by the day each is kept from, since day
one's commitments are all kept from one day and that order would leave them tied with the roster
choosing between them — the same reason a day view orders nothing of its own. Deliberately not the
**store** that keeps a roster across the app being closed, in the way a history is not the store
that keeps it, and deliberately not a **list on a screen**, which may draw a roster in whatever
order it likes. Agreed 2026-09-03 at the grill of `add-commitment-roster` (#101).

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
apart needs ticks rather than a date — ADR-1015.

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

**Store** — where a history survives the app being closed and opened again: the ticks, kept at a
*place* the app names, so that whatever opens the store at that place next holds the same history. A
tick is kept the moment it is added and an untick the moment it is taken back — there is no separate
moment at which a store is saved, because the app can be stopped without warning and a tick waiting
to be saved is the record the product promises not to lose. A store never holds more than is kept at
its place, and never answers with less than is there: what it cannot read it refuses whole, rather
than opening empty over the top of it. It persists exactly what a tick is and nothing it invented,
keyed to the calendar date and never to the moment of entry. Deliberately not a backup and not a
sync: carrying a store to a new phone is B-009's, and the store's only part in it is to be one thing
at one place that a backup can carry. Agreed 2026-09-02 at the grill of `add-record-store` (#56).

**Day** — the unit the product is organised around. The landing screen is one day, and every
record is keyed to a date rather than to the time it was entered.

**Day view** — what one calendar date asks of you and what you did about it: the commitments due
on that date, each with whether it is kept, in the order it was handed them. Like due-ness, it is a
question asked *of a date* rather than of the present moment, so it answers for every date the
system supports and not only for today. It orders nothing of its own — a commitment carries no
identifier and no day it was written down, so any order a day view invented would be a rule about
names, which are the owner's words and not the system's. It counts nothing: it says of each
commitment that it is kept or not, never how many days in a row, and a commitment that has been
ticked stays in the view and goes quiet rather than leaving it. Deliberately not the **screen** that
draws one, in the way a history is not the store that keeps it. Agreed 2026-09-02 at the second
grooming pass, with `FEAT: day-screen` (#27).

It is **handed** its commitments and holds no list of its own: it shows a row for each one it was
given that is due, in that order, and combines none of them — the same commitment handed over twice
has two rows, because deciding otherwise would be deciding something about identity that no
capability has given a day view to decide. It is also an **answer, not a window**: it reports a
history as that history stood when the view was made, so a tick made afterwards is seen by the next
day view rather than by this one. A commitment on a **weekly quota** is due every day (ADR-1015), so
it has a row every day of its week, unticked on the days it was not done; whether the week's quota
has been met is not something a day view can see, and hiding a met one is a later Story's. Settled
2026-09-02 at the grill of `add-day-view` (#70).

It **is what it holds** — the rows and the date, and nothing of what it was handed: two day views a
reader could not tell apart are the same day view, even where one was offered a commitment that was
not due on the date or read a history holding a tick it never looked up. What was offered is the
caller's to remember; the day view keeps the answer. Corrected 2026-09-02 at #70's G7, where the
requirement had claimed identity followed the arguments.

**Row** — one commitment's line in a day view: its name, whether it is kept, and the place a tick is
made. Ticking belongs to the row and therefore to `day-screen`: `record` says what a tick is and
what a history answers and knows nothing of a row, of a date being displayed or of an order. A row
for a date later than today is shown and refuses the tick — a day that has not arrived cannot have
been kept, and `record` hands that judgement to the screen by name, since it never consults the
present moment. Agreed 2026-09-02, the same pass.

What it **offers** is one tick, and it is the tick of its own commitment on its own day view's date
— a row is a commitment on a date and so is a tick, so there is nothing left for anyone to supply
and nothing for the row to choose. The same tick makes the record and takes it back; which of the
two a tap means is read off whether the row already says it is kept, and the row itself neither adds
nor removes anything, because that is `record`'s. It offers nothing at all when its date is later
than the day it is asked on, whether or not something already says it is kept — the refusal is about
the day, not about what is recorded on it. A row is therefore **a commitment's line on a date**: two
rows for the same commitment saying the same thing on two different days are not the same row,
because they tick different days and neither can stand in for the other. Settled 2026-09-03 at the
grill of `add-tick-from-row` (#71); the refusal's second half — that a future row refuses whether or
not it is already kept — was put to the owner as that grill's question round and answered by him the
same day.

**Today** — the day a screen is being looked at on, and the only thing in the system that does not
come from the calendar. It is always handed in and never asked for: nothing in the rule engine reads
a clock, a time zone or a locale (ADR-1004), so *today* arrives as an argument at the moment a
question needs it and is not kept by anything that answers a question. Deliberately not the **date a
day view is of** — that
is what a person is looking at, and it may be any day the system supports — and confusing the two is
what would let a screen offer a tick for a day that has not happened. It is a fact about the device
rather than about the record, which is why the record refuses to consult it and the row asks for it
by name. Agreed 2026-09-03, the same grill.

**Amended 2026-09-03**, at the third grooming pass's Feature grill. A **day screen** does keep one:
it is handed a *today* when the app is shown and holds it until the app is shown again, so that a
screen a person is looking at cannot move onto a different day underneath them. What has not changed
is that nothing ever *asks* for it — the day screen is handed its today by the shell that read the
device's clock, exactly as every other question is, and no clock is read while a day is being looked
at.

**Amended 2026-09-04**, at the grill of `add-screen-navigation` (#93). A day screen keeps a *today*
**and** a day it is showing, and they are two things. They coincided only while a screen could be on
no day but today; once it can be moved, the day being looked at is one the person chose and the
today is still the fact about the device the shell handed over. Every question the screen asks *as
of* a day — whether a row offers its tick, whether the day title says *Today* — is asked as of the
today, and never as of the day being shown, which is the whole of what § *Today* above warned
about.

**Day navigation** — going from one day view to the day view of the day before it or the day after
it, one calendar day at a time. It is a question about a date and about nothing else: it never asks
what day it is, so a person moves onto a day that has not arrived as readily as onto one long past,
and a row on such a day refusing its tick is the row's rule rather than navigation's. It steps
whatever the day it lands on holds — a day nothing is due on is a day like any other, since a day
view with no rows is already an answer, and skipping one would be the app deciding which days are
worth looking at. It carries nothing across: what it gives is the day view that would have been
formed on that date from the commitments and the history it is handed *at the moment of the move*,
and it must be handed both because a day view holds neither. There is no day before the first date
the system supports and none after the last, so moving that way gives nothing at all rather than the
day it started on — a caller that wanted to stay where it is already has it. Agreed 2026-09-03 at
the grill of `add-day-navigation` (#72).

**Amended 2026-09-04**, at the grill of `add-screen-navigation` (#93). A **day screen** navigates
too, and the same sentence describes it: one calendar day at a time, onto a day that has not arrived
as readily as onto one long past, as far back and as far forward as the calendar goes, with the
screen adding no bound of its own. The two differences are that a day screen is handed nothing —
it already holds the commitments and the store — and that where a day view *gives nothing* at the
ends of the calendar, a day screen **stays exactly as it is**, because a screen is not a value and
staying put is an answer it can give. A day screen also moves **straight back to today**, which a
day view has no way to do: it holds no today to go back to.

**Day screen** — the day view a person is actually looking at, together with what it takes to answer
and to keep an answer: the **store** it reads a history from and writes a tick back to, and the
**today** it was handed when the app was shown. It is what `day-screen` is the capability of, and it
is the first thing in the product that is not a value — a day view is what it holds, and holding one
is what a day screen does.

Deliberately not the **day view**, which is an answer and holds neither a store nor a today, and
deliberately not the **app shell**, which draws a day screen and decides nothing. The line between
the last two is the one that matters: everything a day screen does could be wrong in a way a test
would catch — which day it opened on, whether a tick was kept, what it does when the store will not
open — so it lives behind the seam in `DayByDayKit` with the rest of the requirements, and what is
left in `src/DayByDay` is a SwiftUI body and the clock reading that hands it a today. Agreed
2026-09-03 at the third grooming pass's Feature grill.

**Amended 2026-09-04**, at the grill of `add-screen-navigation` (#93). A day screen holds **two**
days, not one: the **today** it was handed, and the **day it is showing**, which starts as the today
and is what navigation moves. It steps one calendar day either way and straight back to today, and a
step with nowhere to go leaves it as it was rather than saying so. It **keeps the day it is showing
when the app is shown again**, so a day being filled in is not lost to a glance at another app —
except where it is showing today, in which case it follows onto the new day, which is what a morning
visit landing on the morning rather than on the night before requires. That exception needs no state
of its own: it is a comparison of the two days the screen already holds, and stepping back onto
today re-arms it.

It **keeps a change before it says so**: a tick made on a day screen is kept at the record's place
first, and only then does the day view say the commitment is kept — the day view is formed again
from the record as it then stands rather than the one being held being altered. What a person reads
is therefore never ahead of what is on the disk, and a change that could not be kept is refused,
reported and left out of the day view entirely. **Reported** means told on the row that was
tapped, under its name, and it stays said until the app is **shown** again or a tick on any row
is kept — the same lifetime a day screen **without its record** has, so there is one rule for how
long the screen says something is wrong rather than two. Every refused tick is told the same way:
a tick refused on a record that could be read has no cause a person can act on differently, which
is the reasoning ADR-1021 already applied to a record that could not be opened. Agreed 2026-09-03
at the fourth grooming pass's Feature grill, for B-027. It is not the tick's owner: which tick a tap means
is the row's answer and what a tick is and where it is held are `record`'s, and a day screen adds
nothing to either.

A day screen **without its record** is one whose store would not open. It is still a day screen: it
draws the day, because what a date asks of a person needs no record to answer, and it says that it
is keeping none. It takes no tick at all — not into memory, not to be kept later — because a tick
shown as made and not kept is exactly the record this product exists not to lose, and it leaves what
is at the place untouched for a person or a later version of the app to recover. The condition lasts
only until the app is shown again, since being shown opens the store afresh.

Every way a store can refuse to open is answered the same way here, but one of them is **named**: a
record **written by a later version of DayByDay**. That record is whole and it is the app that is
behind, so the person's answer is to update the app and leave the file completely alone — where a
screen saying only that something is wrong with the record invites deleting it, which is the loss
this product exists to prevent. No other reason leaves a person anything different to do, so no
other reason is told apart. ADR-1021, settled by the owner at the Feature grill on 2026-09-03 and
sharpened by them on the same day on `add-day-screen`'s question round; recorded by
`add-day-screen` (#91).

**Record place** — the one place a day screen keeps its record at, and the only thing about the
record that is a day screen's to choose. It is a file inside the directory the platform reserves for
an application's own supporting data, in a directory of this app's own, and it is the same place
every time it is asked for, because the app opened again has to read what the app before it wrote.
It is deliberately not the caches directory, which the system empties when it is short of space, nor
the temporary directory, which no backup carries. The choice lands here because it lands nowhere
else: a **store** keeps a history at whatever place it is given and cannot refuse a bad one from
where it sits, and the **app shell** decides nothing. Agreed 2026-09-03 at the grill of
`add-day-screen` (#91).

**Shown** — the moment the app comes in front of a person: opened from nothing, or brought back from
behind whatever was in front of it. It is the only moment a day screen is handed a **today**, and so
the only moment the day it holds can change — nothing else moves a day screen onto another day, and
in particular time passing does not, so a screen someone is reading cannot turn over underneath
them. It is also when the record is read again, which is what lets a screen that opened **without
its record** start keeping one without the app being force-quit. Deliberately a fact about the app
rather than about the clock: being shown does not tell a day screen what day it is, it is the moment
at which a day screen is *told*. Agreed 2026-09-03, the same grill.

**Amended 2026-09-04**, at the grill of `add-screen-navigation` (#93). Being shown is no longer the
only moment the day a screen shows can change — navigation is the other, and it is the person's
rather than the app's. What being shown still does unconditionally is hand over a new **today** and
read the record again. Whether it also moves the day being shown depends on where the screen is: on
today it follows, and on any other day it stays, because the day a person navigated to is one they
chose and time passing is not a reason to take it away.

**Day title** — what a day view says its day is, and so what a day screen says the day it is showing
is: the day said as a weekday, a day of the month, a month and a year — "Monday 31 August 2026" —
with *Today* said in front of it on the one day the question is asked as of. Like every other
question here it is asked *of a date*, and the day it is asked as of decides that one word and
nothing else, so no other day is named in words and a past day's title reads tomorrow exactly as it
does now. It is read off the date and off nothing a day view holds — not the rows, not whether any
of them says its commitment is kept, not how many there are — so a day view with no rows says its
day exactly as one with seven does, and a day screen that can keep no record says its day exactly as
one that can. The words are the app's own and fixed: they are not the device's language, region or
locale, because a day title that changed with the phone would be a sentence no scenario could state,
and the day title is nothing but its words. ADR-1022. Agreed 2026-09-03 at the grill of
`add-screen-date` (#92); the two halves of the form that were preferences rather than facts —
*Today* in front of the date rather than in place of it, and the year said whatever year it is asked
in — were put to the owner as that grill's question round and answered by him the same day.

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

**App shell** — the part of the app that decides nothing: the target, the project file and the
SwiftUI body that draws what `DayByDayKit` already answers. It is what is left over once
everything with a requirement is behind the seam, and the test of whether something belongs in it
is whether that thing could be wrong in a way a test would catch — an order, a formatting rule, a
refusal, a place a store is opened at, all fail that test and owe a Story. That is why the shell
is built on a `chore/` branch with no G4, and it is the only part of the app that ever is. Agreed
2026-09-02 with ADR-1019.
