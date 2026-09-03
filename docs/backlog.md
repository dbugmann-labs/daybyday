# Backlog

**Things I want the application to do, in my own words, before anyone has agreed to build
them.** One entry per want, and wants only: a want is something the app should let you *do*.
`/atlas idea <whatever you say>` writes them — one want or a whole braindump in a single go,
split into entries and the split reported back before it commits; `/atlas backlog` grooms them.
Nothing here is agreed and nothing is implemented from this file: an idea becomes real when it
is a requirement in a capability spec that has passed G4, however obvious it seems.
`docs/process.md` §4, ADR-1010.

**Everything that is not a want** — open product questions, open technical decisions, known gaps
in what is built — is `docs/open-questions.md`; the rules that judge a want rather than being
one are `CONTEXT.md` § *Product principles*.

**An entry leaves in exactly three directions, all of them through `/atlas backlog`:** promoted
into a Feature or a Story against an existing one, dropped with the reason, or merged into
another entry. Whichever it is, the entry is deleted from *Wants* and one line lands in
*Decided* below. **Nothing expires.** A want sits here until a pass takes it, and sitting costs
it nothing: a pass carries one cluster forward, so waiting is the normal state and not a debt.
Nothing counts how long an entry has been here and `pnpm run status` never asks you to answer
for one. ADR-1010.

**Each entry carries a *Principle* line** naming which of `CONTEXT.md` § *Product principles* the
want was tested against and what the test returned — one principle, not all four. A want that
*fails* one is still captured, with the failure written down, so the next pass drops it
deliberately rather than letting it quietly never come back. B-001 to B-009 predate the field;
the first pass, on 2026-09-02, filled them in as it read them.

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
  B-018 is the same question asked from the other side.
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
  tension B-010 raised for every entry that carries a value, before it became a principle.

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

### B-007 — look at one commitment on its own, deliberately and rarely
*Captured 2026-08-28, migrated 2026-09-02.*

> "a detail page per area, visited deliberately and rarely, to look rather than to enter"

*Folded in 2026-09-02:*

> "It's possible that there will be some areas which have a detail page, e.g. a graph where you
> can see the weight / mood / protein over time. But this should be a separate area which can be
> navigated to."

*Merged in 2026-09-02, from B-008 (captured 2026-08-29):*

> "still open: whether looking back means navigating to a past day, or a view that aggregates a
> commitment over time"

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
- **Open** — from B-008: the page *is* the aggregate — "eleven gym sessions last month" for a
  tick, a line for a number — and B-008's principle test travels with it: a count is one step
  from a streak, and it stays on the right side only while it is looked at deliberately and
  never shown unasked. B-008's other half, navigating to a past day, is B-016.

### B-009 — carry my history to a new phone
*Captured 2026-08-28, migrated 2026-09-02.*

> "carrying your history to a new phone; restore, not live sync between devices"

- **Trigger** — once every few years, and catastrophically if it does not work.
- **Touches** — unclaimed. Storage, whose shape was settled after this want was captured by
  `add-record-store` (#56): one versioned JSON file at a place the app names, which is the one
  thing a backup has to carry. ADR-1017.
- **Principle** — tested against *restore, not sync*: passes by definition. It is the want
  the principle exists to promise, and the principle's second half — no live sync — is the
  boundary the quote already draws.
- **Open** — restore is stated as the boundary, so live sync is out. What "restore" means
  concretely — a file, iCloud, a backup you can see — is not decided.

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

### B-013 — stop keeping a commitment
*Captured 2026-09-02, from the sweep. The wording is the sweep's, accepted by the owner rather
than said in their own words.*

> "Stop keeping a commitment."

- **Trigger** — rarely, when a commitment has run its course: the plants died, the lenses gave
  way to glasses.
- **Touches** — `commitment` (#26). Story #42 shipped the type and excluded "archiving or
  deleting one" by name.
- **Principle** — tested against *five percent of seven things*: fails on its face, since it makes
  nothing new possible, and is captured anyway. A commitment that cannot be retired stays due
  every day, unticked, and reads as a miss for ever; the sweep exists for the want nobody says.
- **Open** — what happens to its history. The record is durable (`docs/open-questions.md`
  § *Settled*), so retiring must keep the ticks, and nobody has said whether a retired commitment
  can still be looked at (B-007) or brought back.
- **Open** — is retiring a *kept-until* day, the mirror of ADR-1013's kept-from day? That would
  leave every past day answering as it did.

### B-014 — change a commitment: its name, or the rhythm it runs on
*Captured 2026-09-02, from the sweep. The wording is the sweep's.*

> "Change a commitment — rename it, move the gym to Tue/Thu."

- **Trigger** — rarely; a new gym timetable, a typo in a name.
- **Touches** — `commitment` (#26). Story #42 excluded editing and renaming by name.
- **Principle** — tested against *five percent of seven things*: fails on its face and is captured
  anyway, because the alternative — retire it and define it again — splits one commitment's
  history in two.
- **Open** — what changing the rhythm does to the past. ADR-1013 fixes that a past day's answer
  does not change once given; a rhythm changed today either rewrites which past days were due, or
  applies from a day forward, and only the second keeps that promise.

### B-015 — define a commitment from the phone: a name and the rhythm it runs on
*Captured 2026-09-02, from the sweep. The wording is the sweep's.*

> "Define a commitment from the phone."

- **Trigger** — day one, eight times over; then rarely.
- **Touches** — `commitment` (#26), and a screen that is not the day screen. Story #42 shipped
  the type and excluded "anything on screen"; without this the eight day-one commitments have no
  way in.
- **Principle** — tested against *an iPhone, in your hand*: passes. Choosing one of four rhythm
  shapes on a phone is the whole interaction, and it happens rarely enough to be allowed a screen.
- **Open** — the kept-from day (ADR-1013): typed, or defaulted to today? The type has no default
  on purpose, so a screen has to choose.
- **Open** — "every day" can be said three ways (`CONTEXT.md` § *Weekly quota*); a picker shows
  one of them.

### B-017 — meet a quota over a longer span than a week
*Captured 2026-09-02.*

> "maybe I also want daily / biweekly / monthly quotas?"

- **Trigger** — the same trigger as the weekly quota, said of a longer stretch: gym twelve times
  this month, any days.
- **Touches** — `schedule` (#6). It is the weekly quota shape with its span made a parameter, and
  it needs no change to what a record is — which is what separates it from B-018.
- **Principle** — tested against *five percent of seven things*: fails, and is captured anyway.
  A quota over a different span deepens a rhythm that Story #11 already makes expressible; nothing
  on the day-one week asks for it, where reading 3× a week asks for the weekly one.
- **Re-opens a drop.** *Decided*, 2026-08-28: an unanchored "once a month" rule and a rule bounded
  to a stretch of weeks were dropped as *"invented while answering a question about rules; nothing
  in the day-one list claims either. Re-capture it if something real does."* This is that
  re-capture, and the monthly half is the same want the drop refused — refused then for want of
  anyone asking, not on its merits.
- **Open** — a fixed menu of spans, or any number of weeks? A quota of 12 a month and a quota of
  3 every 2 weeks are the same rule under different parameters, and the shape of the parameter is
  what decides whether this is one Story or three.
- **Open** — does "monthly" mean a calendar month or four weeks? February and a 31-day month hold
  different numbers of chances, which is the same collision `day-of-month` met and answered by
  clamping.
- **Open** — the week boundary that Story #11 could not answer (`docs/open-questions.md`
  § *Week turnover*) becomes worse here, not better: a span longer than a week has to say where it
  starts before a quota over it means anything.

### B-018 — meet a quota more than once in a single day
*Captured 2026-09-02.*

> "maybe I also want daily / biweekly / monthly quotas?"

- **Trigger** — several times within one day: supplements morning and evening, water three times.
- **Touches** — `commitment` and `record`, **not** `schedule`. This is the half of the want that
  is not a rhythm at all: a rhythm already says "every day", and what a daily quota adds is a
  count *within* the day.
- **Principle** — tested against *entered where you stand*: passes on the interaction —
  tapping a row three times is still one tap at a time, in the row — and that is the only
  principle it clearly passes. It fails *five percent of seven things* for the same reason
  B-017 does.
- **Contradicts agreed vocabulary.** `CONTEXT.md` § *Record* says there is *"at most one per
  commitment per day"*, agreed 2026-09-02 with `FEAT: record` (#53). That sentence is what settled
  the 1–7 ceiling on Story #11's weekly quota at G4 on the same day. So this want is not a Story
  against `schedule`: taking it means changing **Record** first, and then the shipped `record`
  spec that #55 and #56 left behind, which carries the same rule in three places.
- **Open** — is this B-002 (protein: *"a number entered several times a day that accumulates
  rather than overwrites"*) said in other words? Three taps that count up to three and a number
  that accumulates to a target may be one want with two vocabularies, and B-002's own open
  question — whether the day has a target that finishes the commitment — is this one described
  from the other side. Grooming should merge or separate these deliberately rather than let both
  survive by default.

### B-020 — see every commitment I keep, in one place
*Captured 2026-09-02, from the sweep. The wording is the sweep's.*

> "See every commitment I keep, in one place."

- **Trigger** — rarely: adding the ninth, a new gym timetable, the plants dying.
- **Touches** — `commitment` (#26), and a screen that is not the day screen. The day screen
  shows what one date asks for; nothing shows what you have taken on.
- **Principle** — tested against *five percent of seven things*: passes. A list is the thinnest
  possible surface across every commitment at once, and it is what B-013 and B-014 both have to
  reach a commitment *through* — neither says how you get to the one you want to change.
- **Open** — is this B-015's screen or a separate one? One entry point or two changes nothing
  about what is stored and everything about what the Stories are.
- **Open** — does it show retired commitments (B-013)? A list that hides them is one you cannot
  bring a commitment back from.

### B-021 — see what rhythm a commitment runs on, in words
*Captured 2026-09-02, from the sweep. The wording is the sweep's.*

> "See what rhythm a commitment runs on, in words — 'every 14 days', 'the 25th'."

- **Trigger** — passive, wherever a commitment is named: B-020's list, and possibly the day
  screen row.
- **Touches** — `schedule` (#6) and whatever surface names a commitment. Saying a rule back in
  English is not the job `schedule` does today, which is deciding due-ness.
- **Principle** — tested against *an iPhone, in your hand*: passes. "Every 14 days" is three
  words in a row, and it is what stops a list of eight names being unreadable.
- **A known gap already points at this.** `docs/open-questions.md` § *Known gaps*: `DayOfMonth`
  is public but `DayOfMonth.day` is internal, and `DayInterval` carries the same asymmetry, so a
  screen can build "the 25th" and never recover the `25` to render it. The first Story that
  renders a rule needs a delta widening the type. That gap was recorded before anyone had said
  they wanted this; the want is its other half.
- **Open** — may fold into B-020. If the words only ever appear in that list, this is one of
  that Feature's requirements rather than a want of its own. It stays separate while the day
  screen row is still a candidate for them.

### B-025 — know where I stand on a weekly quota, inside its week
*Captured 2026-09-03, from the sweep. The wording is the sweep's.*

> "Know where you stand on a weekly quota inside its week — reading, two done, one to go."

- **Trigger** — mid-week, looking at the reading row and deciding whether tonight is one of the
  three.
- **Touches** — `schedule` (#6) and `day-screen` (#27). ADR-1015 makes a quota commitment due
  every day of its week, so its row appears all seven days saying exactly the same thing; the day
  view cannot see the week and says so by design (`CONTEXT.md` § *Day view*).
- **Principle** — tested against *nothing congratulates you*: **strains harder than any want yet
  captured, and is captured anyway.** "Two of three" is a count, and a count over a run of days is
  a streak with the arithmetic hidden. It survives only if what is shown is what the rhythm still
  *asks* — one more night this week — and never what has been achieved. If that distinction cannot
  be held in the design, this is a drop, and the next pass should say so rather than build it.
- **Open** — blocked on *Week turnover* (`docs/open-questions.md` § *Open product questions*):
  where a week begins and what an unmet third night becomes on Sunday night. Nothing about
  standing in a week means anything until that is answered, and this want is the thing that
  forces it.
- **Open** — what a met quota's row does: disappear, go quiet, or stay unchanged. `CONTEXT.md`
  § *Day view* records that hiding a met one is "a later Story's" and leaves it there.

## Decided

One line per entry that has left, newest first. This is the dedup index: `/atlas idea` reads it
before writing a new entry, so a want that was dropped once is not re-argued from scratch three
months later.

- 2026-09-03 — tick a commitment on the phone and find it still ticked → `FEAT: day-screen`
  (#27), reopened, under `EPIC: Daily commitments` (#1). Story numbers follow at #27's G2. The
  requirements live behind the seam in `DayByDayKit` and not in `src/DayByDay`, because CI runs
  `swift test` only where a `Package.swift` is while check 4 walks every `.swift` in the tree —
  a test in the app target would match its scenario and never run. It consumes two known gaps:
  the store's place under `Library/Application Support/`, and the fourth error case
  `RecordStore.init` can throw.
- 2026-09-03 — see which day the screen is showing → `FEAT: day-screen` (#27), same cluster. Its
  Story carries a delta against `openspec/specs/schedule/spec.md` as well, to read a
  `CalendarDate` back; that is the fifth face of the payload read-back gap, and the first change
  in this repo to delta two capabilities at once. The date is said as a weekday and a date, with
  "Today" added only on today.
- 2026-09-03 — move between days on the phone → `FEAT: day-screen` (#27), same cluster. `DayView`
  already answers for every supported date and shipped `previousDay`/`nextDay` with #72; what was
  missing was any way to reach them. A day screen holds the today it was handed when the app was
  shown and does not follow the clock while it is being looked at, so a screen never moves onto a
  different day underneath the person reading it.
- 2026-09-02 — tick a commitment from the day I am looking at → Story #71
  `add-tick-from-row`, under `FEAT: day-screen` (#27). The tap belongs to `day-screen`, settled at
  the Feature grill: `record` says what a tick is and knows nothing of a row, so #53 stays closed.
  Its other half — whether the same tap takes the tick back — went into the Story rather than
  staying a want.
- 2026-09-02 — go to a day other than today, and tick it → Story #72 `add-day-navigation`, under
  `FEAT: day-screen` (#27), with the ticking half in #71. A day view answers for every supported
  date, so the open product question *how far back the past stays writable* is answered in
  direction: as far back as the calendar goes, bounded by navigation rather than by a rule. It
  leaves `docs/open-questions.md` when #72 settles it, not before.
- 2026-09-02 — keep unticked commitments visible into the evening rather than silently missed →
  Story #70 `add-day-view`, under `FEAT: day-screen` (#27). It needs no requirement of its own: a
  day view lists what the date asks for and a ticked commitment stays in it and goes quiet, which
  is the whole of this want.
- 2026-09-02 — tick a due commitment on a day, and have it kept → `FEAT: record` (#53),
  under `EPIC: Daily commitments` (#1). B-001..B-005 stay wants and reopen it when they come;
  B-009 is now a Story against it rather than a capability of its own.
- 2026-09-02 — merged: B-008 (see a commitment aggregated over time) into B-007. A page per
  commitment *is* the aggregate; the two were one look-back said in two breaths, and B-008's
  other half — navigating to a past day — is B-016.
- 2026-09-02 — dropped into `CONTEXT.md` § *Product principles* as *Entered where you stand*:
  B-010 (make every daily entry from the landing screen, without navigating). It says how
  everything is entered and adds nothing to enter, so it judges wants rather than being one —
  the reading its own Open line suspected.
- 2026-08-31 — reading 3× a week, any nights, open until the week turns over → Story #11
  `add-weekly-quota-schedule`, under `FEAT: schedule` (#6).
- 2026-08-31 — a commitment due on the 25th of every month → shipped,
  `openspec/specs/schedule/`.
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

One dated line per `/atlas backlog` pass, appended by the pass itself, oldest first. A pass that
promoted nothing still gets a line: this log is where a pass records what its sweep found and
which clusters it declined and why, and the next pass — and `/to-tickets` — start from that
reasoning rather than from the wants alone. Say what the coverage sweep found, including when it
found nothing.

- 2026-09-02 — pass over 11 wants, the first.
  - **Sweep** — every rhythm on the day-one week is shipped or in flight (#11), and not one of
    the eight commitments can yet be defined on the phone, shown for a day, or ticked. Ticking
    has no Feature, no Story and no want — the Epic absorbed it on 2026-08-28 and no Feature
    claimed it, and both in-flight Stories say in writing that no tick exists. `commitment`
    (#42) excludes changing and retiring one by name and nothing wants either; defining one
    from a screen is unsaid; going to a day other than today is implied by "the past is
    writable" and said nowhere. `docs/open-questions.md` holds no want in disguise.
  - **Housekeeping** — Principle lines filled in on B-001..B-009. Captured B-012..B-016 from
    the sweep; merged B-008 into B-007; dropped B-010 into `CONTEXT.md` as *Entered where you
    stand*.
  - **Taken forward** — cluster A, the record: B-012, with B-001..B-005 behind it — grilled and
    promoted at G1: B-012 → `FEAT: record` (#53). Its G1 left behind B-001..B-005, which reopen
    #53 when they come and mean amending Epic #1's exclusion list then; and for its G2 the pass
    suggested the pure record shape as Story 1, durability with the storage ADR as Story 2, and
    a check whether #27's first Story reads records, which decides whether #27 and #53
    serialise (`docs/process.md` §7).
  - **Not taken**, each with the disposition the pass proposed, so the next pass starts from it
    rather than from the Touches lines alone:
    - **B**, day-screen: B-006, B-011, B-016 stay wants for #27's G2, which status already
      lists; B-006 reads as a requirement of #27's first Story rather than a Story of its own,
      and B-011 cannot be decided before B-007.
    - **C**, looking back: B-007, with B-008 now inside it, unclaimed; nothing to look back at
      until #53 has a Story, so it stays.
    - **D**, restore: B-009, a Story against #53 once the first record Story has chosen the
      store.
    - **E**, the commitment's lifecycle: B-013, B-014, B-015 as Stories reopening #26 — define
      first, then change, then retire; B-013 may be a kept-until day mirroring ADR-1013.

- 2026-09-02 — pass over 18 wants, the second, on the same day as the first.
  - **Sweep** — three silences, all captured before clustering: B-019, ticking from the row,
    which is the seam between `day-screen` (#27) and `record` (#53) that neither Feature's
    intent claims; B-020, seeing every commitment in one place, which B-013 and B-014 both have
    to reach a commitment *through*; B-021, a rhythm said in words, whose technical half was
    already in `docs/open-questions.md` § *Known gaps* before anyone had asked for it. The
    day-one week has no rhythm left uncovered: all four shapes shipped when #45 merged mid-pass,
    closing Story #11 and `FEAT: schedule` (#6). Nothing was stale — the counter counts passes
    dated strictly after a capture and both passes are 2026-09-02, so the forced choice first
    fires on a later date. *(Left as the pass wrote it. The claim was wrong — B-001..B-009 were
    captured 2026-08-28 and both passes counted against them — and the counter it describes was
    withdrawn on 2026-09-03, ADR-1010.)*
  - **Taken forward** — cluster A, the day screen you can use: B-019, B-006, B-016, grilled and
    taken to `FEAT: day-screen` (#27). #27 is at G2 rather than G1, so no Feature was minted and
    the three wants left *Wants* the same day, once its Stories carried numbers: B-006 → #70,
    B-019 → #71, B-016 → #72. The grill settled three things, now in `CONTEXT.md` as **day
    view** and **row**: ticking belongs to `day-screen` and #53 stays closed; a day view answers
    for every supported date, and a row after today is shown and refuses the tick; the day
    preserves the order it is handed, because a commitment has no identifier to order by. The
    open product question *how far back the past stays writable* is answered in direction but
    stays open in `docs/open-questions.md`, by that file's own rule that an item leaves when the
    change forcing it settles it — here, #27's first Story.
  - **Not taken**, each with the disposition this pass proposed:
    - **B**, the commitment's lifecycle: B-015, B-020, B-014, B-013, B-021 as Stories reopening
      `commitment` (#26), plus a screen capability that should not be minted before #27 has
      proved the seam; recommended next, once #56 has chosen the store.
    - **C**, a record that is not a tick: B-001..B-005 and B-018 reopen #53 and change
      `CONTEXT.md` § *Record*, agreed the same morning; whoever takes it must merge or separate
      B-002 and B-018 deliberately rather than let both survive by default.
    - **D**, looking back: B-007 and B-011, unclaimed, nothing to look back at until #56 lands a
      store.
    - **E**, restore: B-009, a Story against #53 once the store is chosen — and Epic #1 excludes
      "export and restore" by name, so promoting it amends the Epic's exclusion list.
    - **F**, quota spans: B-017 stays; the weekly quota shipped today and nothing on the day-one
      week asks for a longer span.

- 2026-09-03 — pass over 19 wants, the third.
  - **Sweep** — four silences, all confirmed and captured before clustering, and three of them
    one discovery: `schedule`, `commitment`, `record` and `day-screen` had all shipped and
    closed, and the app on a phone still recorded nothing, because every Story stopped at the
    `DayByDayKit` seam. B-022 tick and keep it on the phone, B-024 move between days, B-023 name
    the day you are on — the shell drew row names and neither ticked, persisted, moved nor said
    which day it was. B-025 is the weekly quota's missing half, a row that appears all seven days
    saying the same thing, captured with its failure written down: it strains *nothing
    congratulates you* harder than anything yet captured and is blocked on *Week turnover*
    besides. The day-one week has no rhythm uncovered. The lifecycle verbs on `commitment` are
    all claimed (B-015, B-014, B-013); on `record`, create and untick shipped and nothing in the
    app used either. `docs/open-questions.md` held no other want in disguise.
  - **Taken forward** — cluster A, the app that records anything at all: B-022, B-023, B-024,
    grilled and taken to `FEAT: day-screen` (#27), reopened rather than minted. It is Epic #1's
    own outcome sentence, which had closed undelivered. The grill ran two rounds and settled
    five things: the requirements land in `day-screen` with deltas into `schedule` and `record`
    rather than in a new capability; a store that will not open draws the day and refuses every
    tick rather than losing one in memory; a day screen does not follow the clock while it is
    being looked at; the date is said as a weekday and a date with "Today" only on today; and
    the day is re-read when the app is shown, so the morning visit lands on the morning. Two
    `CONTEXT.md` edits came out of it — **day screen** as a new term, and **today** amended,
    because it had claimed a today is never kept and a day screen keeps one. Proposed for its
    G2: the running day first, then reading a date back, then moving between days, with the
    store's refusal folded into the first unless the breakdown disagrees.
  - **Not taken**, each with the disposition this pass proposed:
    - **B**, the commitment's lifecycle: B-015, B-020, B-014, B-013, B-021 as Stories reopening
      `commitment` (#26), plus a screen that is not the day screen. Recommended by both earlier
      passes as next and overturned here — the eight day-one commitments are hard-coded in the
      shell, so defining them from the phone buys nothing that cannot already be seen while the
      app cannot record a tick. The owner took it forward in a separate session the same day.
    - **C**, a record that is not a tick: B-001..B-005 and B-018 reopen `record` (#53) and
      rewrite `CONTEXT.md` § *Record*, whose "at most one per commitment per day" B-018
      contradicts. Whoever takes it must merge or separate B-002 and B-018 deliberately. Also
      taken forward in a separate session the same day.
    - **D**, looking back: B-007 and B-011, unclaimed. There is now a store to look back at, but
      nothing has been recorded on a phone until cluster A lands, so it stays.
    - **E**, restore: B-009, a Story against #53. Unblocked for the first time — the store's
      shape was chosen by ADR-1017 — and promoting it amends Epic #1's exclusion list.
    - **F**, quota spans and standing: B-017 and B-025, both blocked on *Week turnover*
      (`docs/open-questions.md`), which nothing yet forces.
