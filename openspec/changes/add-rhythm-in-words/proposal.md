## Why

Every screen in this app draws a commitment as a bare name. Two commitments called "Vitamins" on
two different rhythms are two identical lines in the kept list, two identical lines in the stopped
list a person picks one from to take up again, and two identical rows on the day screen. The
roster is right to hold both — they are different commitments — and the person is the one left
guessing. B-021 is the want, `FEAT: commitment` (#26) is the Feature this Story
hangs off, and the current `commitment` spec names the gap in as many words: *an entry in the list SHALL be a commitment's
name and nothing else. Saying a rhythm in words is a rule about how a schedule is said and belongs
to the `schedule` capability whichever screen would read it.* This Story is that rule.

It also answers, for the third time and in the same direction, the question
`docs/open-questions.md` § *Known gaps* has been asking since #9: whether a schedule's payload
becomes public so that a caller can render it. It does not. The package says the words.

## What Changes

- **A schedule says the rhythm it runs on in words.** "Mon, Wed, Sat", "Every 14 days", "The 25th",
  "3x a week" — one sentence per shape, in this package's own fixed English, exactly as a day title
  is (ADR-1022). It is read off the schedule and off nothing else: no date is asked for, so the
  words never depend on when they are asked or what they are asked about.
- **The words say the shape and its number and nothing else.** An every-N-days schedule does not
  say its start date, because on every commitment a commitments screen makes that day is the day
  the commitment is kept from and would be said twice. A day-of-month schedule does not say that a
  short month is due on its last day; the clamp is a fact about dates, not about the rhythm a
  person chose.
- **Two schedules that name the same rhythm say the same words**: a weekday set of all seven and an
  interval of one day are both "Every day". A weekly quota of seven is due on exactly the same
  dates and is a *different* rhythm — seven times in a week, on any days — so it stays "7x a week".
  A weekday set with no days in it says "No day" rather than nothing, because it is a legal
  schedule a roster can hold even though a commitments screen refuses to define on one (ADR-1028).
- **A commitments screen entry becomes a name and a rhythm in words.** In both lists — what is kept
  and what has been stopped — because two stopped "Vitamins" are as hard to tell apart as two kept
  ones, and the stopped list is where one of them is taken up again. Not the kind its days take,
  which is `add-kind-to-commitments-screen`'s (#142) surface, and not the day it is kept from.
- **A day screen row says it too, on every row, always.** Not only where two rows would otherwise
  read alike. This is the owner's call at the grill, taken against the recommendation: the day
  screen is the daily visit, and what rhythm a thing runs on is part of reading the day.
- **The form on the commitments screen says the words as a rhythm is built**, before anything is
  defined, so a person sees what their rhythm will say. A rhythm the screen would refuse is
  previewed one of two ways and never as the refusal's own wording: an empty weekday set previews
  "No day", because it names a schedule; a number no schedule can be built on — the 32nd, every 0
  days, 8 times a week — previews **nothing**. The refusal a person reads stays where it already
  is, at define.
- **Nothing about a schedule becomes readable that was not readable before.** No payload accessor
  is made public: `Commitment.schedule` stays internal, `DayOfMonth.day`, `DayInterval.days` and
  `WeeklyQuota.timesPerWeek` stay internal, and what a commitment and a row publish is one more
  *sentence*. `docs/open-questions.md` § *Known gaps* stays open and loses its pressure — recorded
  as `docs/adr/1034-a-schedule-says-its-rhythm-in-words.md`.
- **Not in this change:** the kind on the commitments screen (#142); anything a row offers, which is
  #139's and #141's; changing a commitment's rhythm, which is B-014; sorting, grouping or filtering
  by rhythm; and any second language, which ADR-1022 already priced.

## Capabilities

### New Capabilities

None. Saying a schedule in words is a rule about a schedule and belongs beside the four shapes that
own it; a `words` capability would put one sentence about a weekday set in a different file from
the requirement that says which dates a weekday set is due on. The two screens that read it are
`commitment` and `day-screen`, and both already exist.

### Modified Capabilities

The Story sits under `FEAT: commitment` (#26) and its largest delta is `schedule`'s, which is
`FEAT: schedule` (#6)'s spec — the split `docs/backlog.md` predicted for B-021 when the second
grooming pass left it in *Wants* ("saying a rhythm in words is a delta against
`openspec/specs/schedule/spec.md` and reopens `FEAT: schedule`"). That is a fact about where the
rule lives rather than a Story that wants splitting: one sentence is said in one place and read in
three, and cutting it in two would ship a `schedule` Story nothing reads and a screen Story with
nothing to say. `add-commitment-kind` (#137) crossed three capabilities under one Feature for the
same reason.

- `schedule`: five requirements **ADDED**, none modified. Nothing about due-ness moves — every
  existing requirement in that spec answers a question about a date, and none of these does.
  - ADDED *A schedule says the rhythm it runs on in words* — the general rule: the words are the
    package's own, read off the schedule alone, saying the shape and its number and nothing else.
  - ADDED *A weekday-set schedule is said as its weekdays, in week order from Monday* — three-letter
    names, comma and a space, "Every day" for all seven, "No day" for none. The week order is fixed
    here because a weekday set is a set and carries none.
  - ADDED *An every-N-days schedule is said as its interval, and never as its start date*.
  - ADDED *A day-of-month schedule is said as the ordinal of its day* — with the eleventh, twelfth
    and thirteenth called out, since that is where a rule written from the last digit gets English
    wrong.
  - ADDED *A weekly-quota schedule is said as a number of times a week* — "3x a week", the owner's
    own shorthand, chosen at the grill against a recommendation of "3 times a week".
- `commitment`: two requirements **MODIFIED** and one **ADDED**.
  - MODIFIED *A commitments screen lists the commitments its roster keeps…*: an entry is a name and
    a rhythm in words. The paragraph forbidding it — "a commitments screen MUST NOT say one" — is
    what this Story exists to delete.
  - MODIFIED *A commitments screen lists what has been stopped, beside what it keeps*: the same, in
    the second list.
  - ADDED *A commitments screen says in words the rhythm its form is building* — the live preview,
    and what it says for a rhythm that would be refused.
- `day-screen`: one requirement **MODIFIED** — *A row is a commitment's line on a date*, which is
  where the row's readable surface is enumerated with the word "only". *A day view is the
  commitments due on a date* is deliberately left alone: it says where each of a row's answers
  comes from and closes nothing, and a rhythm in words is asked of the commitment the row already
  holds exactly as its name is.

**One scenario title in the delta is now wrong and is kept anyway** — *two commitments alike in
name and not in rhythm are two entries a person cannot tell apart*, whose assertions all still hold
and whose claim does not. `openspec` 1.10.0 refuses a MODIFIED requirement that drops any scenario
the current spec has, and the only escape is renaming the requirement, which moves the whole block
to the bottom of the spec at archive. `design.md` § *A scenario title that is now wrong* has the
error text and the reasoning, and the scenario immediately after it says what is true now.

Ten of the delta's forty-two scenarios are restatements already carried by passing tests, verbatim
and unedited; thirty-two are new. **No existing test is renamed and no existing assertion changes**
— measured with `pnpm run check:scenarios`, which reports `10/42` against this folder.

## Impact

- **`src/DayByDayKit`** — one new file, `Sources/DayByDayKit/ScheduleWords.swift`, holding the
  package's own words the way `DayTitle.swift` holds the day title's. Four existing files gain one
  member each: `Schedule.swift` gains `inWords`, `Rhythm.swift` gains `inWords` (optional, and
  `nil` is what "previews nothing" means), `Commitment.swift` gains `rhythmInWords`, and
  `DayView.swift` gains `Row.rhythmInWords`. Nothing existing changes behaviour, no initializer
  moves, and no stored property is added — so no store, no document and no file form is touched.
- **`src/DayByDay`** — three edits, riding this Story under ADR-1019's bounded exception because
  the Story is unusable without them: both lists in `CommitmentsView.swift` draw the rhythm under
  the name, the define form draws the preview, and `ContentView.swift` draws it under each day row.
  Every one of them is `Text(...)` reading a sentence the package already composed; no line of the
  shell decides a word.
- **Tests** — thirty-two new acceptance tests, one per new scenario: eight in `ScheduleTests.swift`
  (the three general and the five weekday-set), four in `EveryNDaysScheduleTests.swift`, four in
  `DayOfMonthScheduleTests.swift`, three in `WeeklyQuotaScheduleTests.swift`, nine in
  `CommitmentsScreenTests.swift` and four in `DayViewTests.swift`. Measured on this machine on
  2026-09-06, on Apple Swift 6.3.3 (swiftlang-6.3.3.1.3), target `arm64-apple-macosx26.0`:
  `cd src/DayByDayKit && swift test` reports **418 tests passing** at `eb298a2`; this change takes
  it to 450. `openspec` is 1.10.0 and `node --version` is v24.19.0.
- **`openspec/specs/`** — `schedule/spec.md`, `commitment/spec.md` and `day-screen/spec.md` are
  rewritten at archive time by `/opsx:archive` and nothing else. Three capabilities are claimed and
  all three are edited, so CI check 2 stays green.
- **ADRs** — `1034-a-schedule-says-its-rhythm-in-words.md`, the lowest free number: 1032 is the
  highest on any local or remote ref, checked 2026-09-06. `docs/adr/README.md` gains one row.
  ADR-1022 said its reasoning "applies on its face" to any other sentence but that each Story takes
  the decision for itself; this is that Story, and the class is wider — a *rule* said in words, not
  a date.
- **`CONTEXT.md`** — the grill landed **rhythm in words** before this folder existed, and writing
  the delta turned up no second term. The file is unchanged by this change beyond what the grill
  already committed to the branch.
- **`docs/open-questions.md`** is not this change's to write (`AGENTS.md` § *Agent roles*). One
  entry is owed on the read-back gap and `tasks.md` § 6 names it verbatim for a chore commit
  alongside the merge: the gap stays open on all nine faces and loses the pressure the entry has
  been predicting since #9, because rendering a rule no longer needs a payload.
- **`docs/backlog.md`** — untouched. B-021 already left *Wants* at the fifth grooming pass, when
  cluster B was decided and this Story was cut from it (`eb298a2`, PR #149); what is left of it in
  that file is the record of the decision, which is not a Story's to edit.
- **No new dependency, no CI change, no change to any command, and no change to any file on disk on
  the owner's phone.**
