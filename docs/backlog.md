# Backlog

**Things I want the application to do, in my own words, before anyone has agreed to build
them.** One entry per want. `/atlas idea <whatever you say>` writes them — **one want or a
whole braindump in a single go**, split into entries and the split reported back before it
commits; `/atlas backlog` grooms them into Features. Nothing here is agreed and nothing is implemented from this file —
an idea becomes real when it is a requirement in a capability spec that has passed G4, however
obvious it seems. `docs/process.md` §4.

**Wants only.** A want is something the app should let you *do*. Anything else that used to live
in the parking lot — open product questions, open technical decisions, known gaps in what is
built — is in `docs/open-questions.md`, and the rules that judge a want rather than being one
are `CONTEXT.md` § *Product principles*. Keeping this file to one kind of thing is what stops it
becoming the dump it replaced.

An entry leaves in exactly three directions, all of them through `/atlas backlog`: **promoted**
into a Feature or a Story against an existing one, **dropped** with the reason, or **merged**
into another entry. Whichever it is, the entry is deleted from *Wants* and one line lands in
*Decided* below. **An entry that has survived two grooming passes untouched is presented as a
forced choice — promote it or drop it.** That rule is the whole difference between a backlog and
a graveyard, and it is `/atlas backlog`'s job to enforce it rather than yours to remember.

That is why *Grooming passes* below is a dated log rather than a formality: a pass an entry
sat through is only countable if the pass was written down. `pnpm run status` reads it off a
story branch and reports the count without being asked, which is the half of ADR-1010's
diagnosis that `/atlas backlog` alone does not fix — the parking lot failed because nothing
ever opened it.

**Each entry carries a *Principle* line** naming which of `CONTEXT.md` § *Product principles* the
want was tested against and what the test returned — one principle, not all four. A want that
*fails* one is still captured, with the failure written down, because that is a drop the next
grooming pass makes deliberately rather than an idea that quietly never came back. Entries
B-001 to B-009 predated the field; the first grooming pass, on 2026-09-02, filled them in as
it read them.

## What day one looks like

The owner's actual week, as stated on 2026-08-28. Every cluster `/atlas backlog` proposes is
judged against this rather than against a category of app — **and every grooming pass walks it
line by line to find the commitments that have no want, no spec and no open Story at all.** That
sweep is the only step in the whole process that asks what is *missing* rather than whether what
is here is coherent, which is why it runs before any clustering:

> gym Mon/Wed/Sat · run Tue/Thu/Sun · finances every 25th · reading 3× a week · supplements and
> habits daily · journaling daily · contact lenses every 14 days · water plants every 3rd day

**Whether to build any of this at all is settled and is not to be re-argued.** Checked against
what already exists on 2026-08-29: nothing found does all four rule shapes without streak
mechanics. Apple Reminders does weekday sets, every N days and a day of the month — free and
already installed — but has no weekly quota and keeps no record of what was ticked, and a
durable record is the failure being solved (the gap is a few days old and cannot be
reconstructed). The habit-tracker category — Streaks, HabitKit, Habitify, Do Habits — has the
quota and is built on the streaks the owner abandoned apps for; a specific calendar date is the
shape it lacks, not the quota.

## Wants

### B-001 — record a weight for a day, and see it as a line over months
*Captured 2026-08-28, migrated from the parking lot 2026-09-02.*

> "weight — a number entered once a day, looked at as a line over months"

*Folded in 2026-09-02:*

> "Track weight daily"

- **Trigger** — once a day, on the scale. Separately and rarely, to look at the trend.
- **Touches** — `commitment`, as a numeric payload rather than a tick; the line is a surface
  that is not the day screen.
- **Principle** — tested against *five percent of seven things*: passes. A number where
  there was a tick makes a new kind of record possible rather than deepening one; the line
  over months is a look-back and is judged with B-007.
- **Open** — one want or two? Entering a number and reading months of them are different
  triggers, and the second may be B-007 or B-008 wearing a different name. The 2026-09-02
  braindump named the entry and the graph in separate breaths — the graph as "a separate area
  which can be navigated to" — which strengthens the split without deciding it.

### B-002 — add to a running total across a day
*Captured 2026-08-28, migrated 2026-09-02.*

> "protein — a number entered several times a day that accumulates rather than overwrites"

*Folded in 2026-09-02:*

> "Track grams of protein daily"

- **Trigger** — several times a day, after eating.
- **Touches** — `commitment`. The same numeric payload as B-001 with the opposite write
  semantics: add, never replace.
- **Principle** — tested against *five percent of seven things*: passes as a number, strains
  as a running total. The number is B-001's new kind of record; accumulating is depth on it,
  and is worth less on its own than the plain number.
- **Open** — is there a target for the day, and does reaching it make the commitment done?
- **Open** — the 2026-09-02 braindump groups protein with weight, mood and journal as "daily",
  and says nothing about accumulating. That is not a contradiction of the original words, but
  accumulation is this entry's whole identity, so grooming has to confirm it is still wanted
  rather than assume it.

### B-003 — set a mood for the day with one tap
*Captured 2026-08-28, migrated 2026-09-02.*

> "mood — a number set by a single tap, once a day"

*Folded in 2026-09-02:*

> "Track mood (1-10) daily"

- **Trigger** — once a day, in the row itself, with no second screen.
- **Touches** — `commitment` numeric payload and `day-screen`, because "one tap" is a claim
  about the row, not about the value.
- **Principle** — tested against *an iPhone, in your hand*: passes, and is the want that
  states it most sharply — one tap, in the row, phone in hand. The ten-point scale is what
  strains it, not the principle.
- **Answered 2026-09-02** — the scale is 1 to 10. It was the open question on this entry, and
  the braindump states it outright.
- **Open** — ten values and "a single tap" pull against each other: a ten-point scale is a
  slider or a row of ten targets, neither of which is one tap in a row. This is the same
  tension B-010 raises for every entry that carries a value.

### B-004 — write two or three sentences about a day
*Captured 2026-08-28, migrated 2026-09-02.*

> "journal — two or three sentences a day, deliberately not an essay"

*Folded in 2026-09-02:*

> "Track journal entries daily"

- **Trigger** — once a day, evening.
- **Touches** — `commitment` with a text payload, plus somewhere to type that a row is not.
- **Principle** — tested against *an iPhone, in your hand*: passes only because it is short.
  Two or three sentences typed on a phone is the most interaction any daily entry asks for,
  and "deliberately not an essay" is the owner drawing that line.
- **Open** — the day-one list has journaling as a **tick**, not as written text. The 2026-09-02
  braindump lists journal entries alongside weight, protein and mood — the three things that
  carry a value — and not alongside sports, supplements and habits, which are the ticks. That
  leans to written text, and grooming should say so rather than leave it leaning.

### B-005 — tick a habit phrased as a negative, where ticking records that it was *not* done
*Captured 2026-08-28, migrated 2026-09-02.*

> "a habit phrased as a negative, where ticking it records that the thing was *not* done"

*Folded in 2026-09-02:*

> "Same for sticking to habits (did I NOT byte my nails today -> check)"

- **Trigger** — daily, alongside supplements.
- **Touches** — `commitment`. Supplements and habits arrived as one line, and this is the half
  that is not a supplement: the tick means the opposite thing.
- **Principle** — tested against *nothing congratulates you*: passes narrowly. Ticking that a
  thing was *not* done records an absence, and a run of absences is a streak by another
  name; it survives as long as the tick stays a record and never becomes a count.
- **Open** — is the negation a property of the commitment, or only of how its row is worded?

### B-006 — keep unticked commitments visible into the evening rather than silently missed
*Captured 2026-08-28, migrated 2026-09-02.*

> "unticked items stay visible into the evening rather than being silently missed"

- **Trigger** — passive; it is what the day screen does when you have not done something yet.
- **Touches** — `day-screen`.
- **Principle** — tested against *nothing congratulates you*, read from the other side:
  passes. A row that is not ticked simply does not go quiet, which is the principle's own
  mechanic; it fails the moment "visible" becomes a badge or a nudge, which is the nag the
  Open line names.
- **Open** — visible how? This is one sentence away from being a nag, which
  `CONTEXT.md` § *Product principles* rules out.

### B-007 — look at one commitment on its own, deliberately and rarely
*Captured 2026-08-28, migrated 2026-09-02.*

> "a detail page per area, visited deliberately and rarely, to look rather than to enter"

*Folded in 2026-09-02:*

> "It's possible that there will be some areas which have a detail page, e.g. a graph where you
> can see the weight / mood / protein over time. But this should be a separate area which can be
> navigated to."

- **Trigger** — occasionally, and never as part of the five daily visits.
- **Touches** — unclaimed. Probably its own capability rather than `day-screen`, because its
  whole point is that it is not the landing screen — and the braindump says so twice, calling it
  "a separate area which can be navigated to".
- **Principle** — tested against *five percent of seven things*: strains. A page per
  commitment is depth on one thing at a time, and it passes only if the page is the same
  thin thing for every commitment rather than a deep one for weight.
- **Open** — the word *area* was dropped from the vocabulary (`CONTEXT.md`). What this is a page
  *per* needs re-deciding before it is a Feature. The braindump narrows it without settling it:
  the three examples it gives — weight, mood, protein — are the commitments that carry a number,
  and it says "some areas", not all. A page per numeric commitment and a page per commitment are
  different Features.

### B-008 — see a commitment aggregated over time — "eleven gym sessions last month"
*Captured 2026-08-29, migrated 2026-09-02.*

> "still open: whether looking back means navigating to a past day, or a view that aggregates a
> commitment over time"

- **Trigger** — occasionally, out of curiosity rather than obligation.
- **Touches** — unclaimed, and likely the same surface as B-001's line and B-007's page.
- **Principle** — tested against *nothing congratulates you*: passes as a record looked at
  deliberately, fails if shown unasked. "Eleven gym sessions last month" is a count, and a
  count is one step from a streak; the trigger — curiosity, never obligation — is what keeps
  it on the right side.
- **Open** — navigating to a past day is already implied by ticking any day; this is the other
  half, and nobody has agreed to build it. Strong candidate to merge with B-001 and B-007.

### B-009 — carry my history to a new phone
*Captured 2026-08-28, migrated 2026-09-02.*

> "carrying your history to a new phone; restore, not live sync between devices"

- **Trigger** — once every few years, and catastrophically if it does not work.
- **Touches** — unclaimed. Storage, which is also the open technical decision in
  `docs/open-questions.md`.
- **Principle** — tested against *restore, not sync*: passes by definition. It is the want
  the principle exists to promise, and the principle's second half — no live sync — is the
  boundary the quote already draws.
- **Open** — restore is stated as the boundary, so live sync is out. What "restore" means
  concretely — a file, iCloud, a backup you can see — is not decided.

### B-010 — make every daily entry from the landing screen, without navigating
*Captured 2026-09-02.*

> "Focusing of keeping things very simple, with little interaction needed (e.g. just multiple
> buttons to add things each day, without much navigation)"

- **Trigger** — every one of the daily visits. It is the shape all of them share rather than one
  of them.
- **Touches** — `day-screen`. B-003 makes this claim for mood alone; this is the same claim over
  every commitment, including the ones carrying a number or a sentence.
- **Principle** — tested against *five percent of seven things*: it passes as a constraint on how
  cheap each of the seven is to enter, but it makes nothing new possible on its own, which is why
  it may not be a want at all — see Open.
- **Open** — is this a want or a fifth product principle? It says how everything else is entered
  rather than adding anything to enter. If grooming reads it as a principle it belongs in
  `CONTEXT.md` § *Product principles*, and this entry is dropped into that.
- **Open** — it collides with B-004 and B-003 as written. Two or three sentences of journal and a
  ten-point mood are not buttons, so either "little interaction" means something looser than a
  button per commitment, or those two wants are exceptions to it.

### B-011 — see something of a commitment's history on the day screen itself
*Captured 2026-09-02.*

> "It can be decided if you want to see some information also on the landing screen, where
> entries are made"

- **Trigger** — passive, during a daily entry visit rather than a deliberate look.
- **Touches** — `day-screen`, and whatever B-007's page turns out to be: it is the same history,
  shown in the other place.
- **Principle** — tested against *nothing congratulates you*: a number's recent trend is a record
  and survives, but this want is one design decision away from failing — "six days in a row" on
  the landing screen is the streak the principle exists to forbid.
- **Open** — the owner explicitly left this undecided ("it can be decided"), so what grooming
  inherits is a decision, not a want. It cannot be taken before B-007, because what may appear on
  the day screen depends on what the detail page is a page *per*.

## Decided

One line per entry that has left, newest first. This is the dedup index: `/atlas idea` reads it
before writing a new entry, so a want that was dropped once is not re-argued from scratch three
months later.

- 2026-08-31 — reading 3× a week, any nights, open until the week turns over → Story #11
  `add-weekly-quota-schedule`, under `FEAT: schedule` (#6).
- 2026-08-31 — a commitment due on the 25th of every month → shipped, `openspec/specs/schedule/`.
- 2026-08-31 — a commitment due every N days, counted from a start date → shipped,
  `openspec/specs/schedule/`.
- 2026-08-30 — a commitment due on a set of weekdays → shipped, `openspec/specs/schedule/`.
- 2026-08-28 — a day screen, its ticks, and the schedule behind them → `EPIC: Daily commitments`
  (#1), and from there `FEAT: schedule` (#6), `FEAT: commitment` (#26) and `FEAT: day-screen`
  (#27).
- 2026-08-28 — dropped: an unanchored "once a month" rule, and a rule bounded to a stretch of
  weeks. Invented while answering a question about rules; nothing in the day-one list claims
  either. Re-capture it if something real does.

## Grooming passes

One dated line per `/atlas backlog` pass, appended by the pass itself, oldest first. This is
what "survived two passes" is counted against; an entry captured after a pass did not sit
through it. A pass that promoted nothing still gets a line — it is the pass the staleness rule
most needs to count. Say what the coverage sweep found, including when it found nothing.

- 2026-09-02 — pass over 11 wants, the first. Sweep: every rhythm on the day-one week is
  shipped or in flight (#11), and not one of the eight commitments can yet be defined on the
  phone, shown for a day, or ticked. Ticking has no Feature, no Story and no want — the Epic
  absorbed it on 2026-08-28 and no Feature claimed it, and both in-flight Stories say in
  writing that no tick exists. `commitment` (#42) excludes changing and retiring one by name
  and nothing wants either; defining one from a screen is unsaid; going to a day other than
  today is implied by "the past is writable" and said nowhere. `docs/open-questions.md`
  holds no want in disguise. Principle lines filled in on B-001..B-009. Stopped at the
  cluster choice.
