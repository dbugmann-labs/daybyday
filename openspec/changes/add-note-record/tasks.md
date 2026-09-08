Every scenario task below takes exactly one `#### Scenario:` from this change's delta and writes
**one** acceptance test whose `@Test("...")` display name is that scenario title **verbatim**, then
makes it pass with the smallest change that does. Never write two before the first is green
(`AGENTS.md` rule 3). Verify each with `cd src/DayByDayKit && swift test`: the named test green,
every earlier test still green.

## 1. The baseline, and the one mechanical edit

This section changes no behaviour and adds no test. It pins the starting point and moves the eleven
sites that say `4` to mean *a form later than this app writes*, so that everything after it is
measured against a number rather than a memory.

- [x] 1.1 Confirm the branch point before touching anything: from `src/DayByDayKit`, `swift test`
  reports **628 tests passing**. Measured on this machine on 2026-09-08, Apple Swift 6.3.3
  (swiftlang-6.3.3.1.3), target `arm64-apple-macosx26.0`. A different number means `main` moved under
  the branch; report it rather than working around it (`AGENTS.md` rule 5).
- [x] 1.2 Edit the eleven sites that say `4` to mean *a later form* so they say `5`. Nine JSON
  fixtures — `RecordStoreTests.swift:295`, `RosterStoreTests.swift:323`,
  `CommitmentsScreenTests.swift:1129`, and `DayScreenTests.swift:370`, `:454`, `:585`, `:1673`,
  `:1831`, `:2471` — and two assertions, `RecordStoreTests.swift:298` and `RosterStoreTests.swift:326`,
  whose `laterForm(at:version: 4)` becomes `version: 5`. **No `@Test` display name, no other
  assertion, no date and no commitment may change**, and no test may be added or removed here. Five
  of those eleven are the *roster* store's — `RosterStoreTests.swift:323` and `:326`,
  `CommitmentsScreenTests.swift:1129`, and `DayScreenTests.swift:1673` and `:1831` — and they move to
  `5` for the same reason the record's six do, and on the same precedent `add-number-record` set: the
  roster document does not move in this change, and `5` is above its `currentVersion` of `2` as
  surely as `4` was, so one number goes on meaning *a later form* everywhere in the suite.
  `swift test` still reports **628 passing** after this box — a red test is a rule-5 stop, because
  nothing in this box was supposed to change an answer.
- [x] 1.3 Confirm the coverage tool agrees before writing a test: from the repo root,
  `pnpm run checks` reports `scenario coverage — 117/194 scenario(s) covered` for this change.
  Measured on 2026-09-08 after the residual round folded in the number entry's MODIFIED requirement,
  whose eight archived scenarios already have tests of those names and so arrive already covered. A
  different number means something else moved; report it rather than working around it. The scenario
  it names as *next* is a `day-screen` one, because the checker walks the delta's spec files in
  alphabetical order; the task order below is `record` first, because a row cannot offer an entry for
  a record that does not exist. That mismatch is expected and is not a finding.

## 2. `Note` and `Blank`, before anything holds one

- [x] 2.1 Add `Sources/DayByDayKit/Blank.swift` declaring the internal `enum Blank` from `design.md`
  § *The seam* — `saysNothing(_:)` and `trimmed(_:)`, both on `Character.isWhitespace` and nothing
  else — and change `Commitment.init?`'s own guard to read `guard !Blank.saysNothing(name)`. That is
  a **refactor with no behaviour in it**: `Blank.saysNothing` is `allSatisfy(\.isWhitespace)`, which
  is character for character what `Commitment.init?` says today, and the point of moving it is that
  there is then one place in the package that decides what blank means (`docs/adr/1039`). Two callers
  join it later — `Note.init?` at § 3.4 and `DayScreen.enter(_:on:)`'s note branch at § 12 — and
  § 12.7 moves the last one, `DayScreen.read(_:)`, off `CharacterSet.whitespaces`. `swift test` still
  reports 628 passing after this box; a red test is a rule-5 stop.
- [x] 2.2 Add `Sources/DayByDayKit/Note.swift` declaring exactly what `design.md` § *The seam* gives:
  `public struct Note: Hashable, Sendable` with internal `commitment`, `date` and `text`, and
  `public init?(_ text: String, for commitment: Commitment, on date: CalendarDate)`. **The
  initializer is a bodied `fatalError("not implemented")`**, so § 3.1 is red on its first assertion
  rather than accidentally green. `RecordedDay` already exists in `Number.swift` and is not moved or
  copied. Nothing else is public. `cd src/DayByDayKit && swift build` exits 0 and `swift test` still
  reports 628 passing.

## 3. `record` — what a note is

Seven scenarios from `specs/record/spec.md` § *A note is of a note commitment on a calendar date it
is due on*, all in `Tests/DayByDayKitTests/RecordTests.swift`.

`design.md` expects 3.1 (the first call into the `fatalError`) and **3.4 (the one that drives out the
blank guard**, which nothing before it needs) to run red on their own. **Record which ones actually
ran red as you go, in § 16**; a prediction here is not evidence.

- [x] 3.1 `a note is recorded for a note commitment on a date it is due on`
- [x] 3.2 `a note commitment takes no note on a date it is not due on` — all three clauses: not due,
  before the day it is kept from, and a schedule due on no date across seven days.
- [x] 3.3 `a commitment whose kind is not a note takes no note on a date it is due on` — the tick
  kind, both number kinds and the total kind, plus the note-kind control that must still record.
- [x] 3.4 `a text that says nothing is not a note` — the empty text, three spaces, three line breaks,
  a tab followed by a line break, and one no-break space, plus the control. This is the box that
  drives out `Blank.saysNothing`; a `CharacterSet.whitespaces` implementation fails the line-break
  clauses, which is the point.
- [x] 3.5 `a text holding one character that is not blank space is a note, kept with the blank space
  around it` — what stops `Note.init?` acquiring a trim of its own. `record` keeps what it is given;
  the screen is what tidies (`design.md` § *One whitespace test*).
- [x] 3.6 `a note takes any length, any script and a line break` — six texts, each read back
  character for character. `design.md` § *Context* measurement 3 is what says a hundred thousand
  characters is a real number and not a hopeful one.
- [x] 3.7 `two notes are the same exactly when their commitment, date and text all are` — all four
  clauses, which is what pins that the text is part of the record rather than beside it.

## 4. `record` — what a history holds and answers about notes

Nine scenarios from § *A history answers what note a commitment has on a day from the notes it
holds*, in `Tests/DayByDayKitTests/RecordTests.swift`. `History` gains
`private var notes: [RecordedDay: String]`, `add(_ note: Note)`, `note(for:on:)` and
`removeNote(for:on:)` per `design.md` § *The seam*; the map is what makes 4.5 pass without an
explicit remove-then-insert, exactly as the numbers map does.

- [x] 4.1 `a history that has taken no note has no note for a commitment on a day`
- [x] 4.2 `a note added to a history is the note that commitment has on that day` — assert the text
  character for character, which is what stops anything normalising it later.
- [x] 4.3 `a note on one date is not the note on another date the same commitment is due on`
- [x] 4.4 `a note of one commitment is not the note of another on the same date`
- [x] 4.5 `a note entered again on the same day replaces the one before it` — both halves: the later
  text reads back, and the history equals one the later note alone was added to.
- [x] 4.6 `a history has no note for a commitment whose kind is not a note` — answered rather than
  refused, for all three other kinds and for a date the commitment is not due on.
- [x] 4.7 `a text the system refuses leaves the note already on that day standing`
- [x] 4.8 `two histories holding the same notes are the same history`
- [x] 4.9 `a history holds ticks, numbers and notes side by side and answers each on its own` — the
  box that drives out `isKept`'s third widening, exactly as #138's 4.9 drove out its second.

## 5. `record` — taking a note back

Five scenarios from § *A note can be taken back*, in `Tests/DayByDayKitTests/RecordTests.swift`. The
take-back names the commitment and the date, never the text — `docs/adr/1033` as amended by this
change, and § 15.2.

- [x] 5.1 `a note taken back leaves the day holding no note and the commitment not kept on it`
- [x] 5.2 `taking back a note leaves the same commitment's notes on other days standing`
- [x] 5.3 `taking back a note leaves another commitment's note on the same day standing`
- [x] 5.4 `taking back a note where the history holds none leaves it unchanged` — three cases: a day
  with nothing on it, a commitment of the wrong kind, and a date it is not due on. None is an error.
- [x] 5.5 `a history given a note and then taken back is the same as one never given one`

## 6. `record` — what the three existing answers say now

Five scenarios across three MODIFIED requirements, in `Tests/DayByDayKitTests/RecordTests.swift`.
Expect 6.2 to be already satisfied by § 4.9's widening and the rest green on first write; a red test
at 6.1, 6.4 or 6.5 is a real finding, not a licence to edit further.

- [x] 6.1 `a note commitment with a note on a date still takes no tick on it` — from § *A tick is of
  a commitment on a calendar date it is due on*. `Tick.swift` is **not** edited: its kind guard
  already refuses this, and the test is what pins that it stays refused now that such a commitment
  can be kept.
- [x] 6.2 `a note commitment with a note recorded on a date was kept on that date` — the requirement
  #137 shipped that this Story reverses in part, for the last kind but one.
- [x] 6.3 `a note commitment due on a date with no note recorded was not kept on it`
- [x] 6.4 `every note a commitment accepts keeps its day, whatever it says` — four texts including one
  that says the day went badly. What a person wrote is not something this system grades.
- [x] 6.5 `a note commitment with a note on a date still takes no number on it` — from § *A number is
  of a number commitment on a calendar date it is due on*. `Number.swift` is **not** edited, for the
  reason 6.1 gives.

## 7. The form on disk

Ten scenarios across the three MODIFIED store requirements, all in
`Tests/DayByDayKitTests/RecordStoreTests.swift`. Do 7.1 first as one mechanical step and verify the
suite before writing a test; then one scenario at a time as above.

- [x] 7.1 In `Sources/DayByDayKit/RecordDocument.swift`, add `NoteRecord` — `commitment`, `date` and
  `text` — conforming to `DatedCommitmentRecord` so it sorts on the same five-part key; give
  `RecordDocument` a `notes` field, move `currentVersion` from `3` to `4`, and add
  `notesIntroducedInVersion = 4` beside `numbersIntroducedInVersion`. `formNotes()` re-forms every
  note through `Note.init?` and returns `nil` if any one fails, exactly as `formNumbers()` does. In
  `Sources/DayByDayKit/RecordStore.swift`, mirror the notes the store keeps beside the ticks and the
  numbers, add the two writes, and extend the version guard to `1...4` and the shape-against-form
  guard to the two-clause form in `design.md` § *The form on disk moves to 4*. **`CommitmentCoding.swift`
  is not edited** — the roster store shares it and does not move. `swift test` reports no new failures
  after this box beyond whatever § 1.2's count already was plus the tests §§ 3–6 added; a red test
  among the ones already passing is a rule-5 stop.
- [x] 7.2 `a note added to a store is held by a second store opened at the same place while the first
  is still open`
- [x] 7.3 `a note taken back is not held by a store opened afterwards at the same place`
- [x] 7.4 `a note written again is kept once by a store opened afterwards, as the later note`
- [x] 7.5 `a note is read back exactly as it was written, whatever it contains` — six notes through a
  real file, compared **as characters and not only as equal strings**: the clause about a plain
  letter followed by a separate accent mark is the one that fails an implementation reaching for
  `precomposedStringWithCanonicalMapping`, and Swift's own `==` will not catch it because it compares
  canonically (`design.md` § *Context* measurement 4). Assert on `Array(text.unicodeScalars)`.
- [x] 7.6 `a store opened again holds exactly the ticks, numbers and notes added and not taken back`
- [x] 7.7 `a note that cannot be kept is refused and not held` — the unwritable place, and the store's
  history left as it was.
- [x] 7.8 `a store holding a note that could not be a note is refused` — a hand-written form-4
  fixture, three ways: a blank text, the wrong kind, and a date it is not due on. All three come from
  `formNotes()` returning `nil`, so expect this green once 7.1 is in; a red test is a finding.
- [x] 7.9 `a history kept before a day could hold a note is read, and no day in it holds a note` — a
  form-3 fixture. Expect green once 7.1 is in: the version guard reads `1...4`.
- [x] 7.10 `a note added over a history kept before a day could hold a note is read back beside the
  records already there` — a form-3 fixture written over, then reopened at form 4.
- [x] 7.11 `a store whose shape and declared form disagree about notes is refused` — both directions,
  plus the third clause that is the real point: a **form-2** fixture holding neither numbers nor
  notes must still be read without error. That clause is what fails a guard written against
  `currentVersion` instead of against each field's own introduced-at constant, which is the mistake
  `design.md` § *The form on disk moves to 4* exists to prevent. Expect red before the guard is
  written.

## 8. `day-screen` — what a row offers

Seven scenarios from `specs/day-screen/spec.md` § *A row offers the note entry its commitment takes,
and offers none for a day that has not arrived*, in `Tests/DayByDayKitTests/DayViewTests.swift`, plus
one edit to an existing test. `DayView.Row` gains the internal `note` and the public
`noteEntry(asOf:)` and `noteRecord(_:asOf:)`, per `design.md` § *The seam*.

- [ ] 8.1 `a row offers the note entry for its commitment on the date the day view is of`
- [ ] 8.2 `a row for a commitment whose kind is not a note offers no note entry`
- [ ] 8.3 `a row offers a tick, a number entry or a note entry and never two of them`
- [ ] 8.4 `a row for a date later than the day it is asked as of offers no note entry`
- [ ] 8.5 `a row for a date later than the day it is asked as of offers no note entry even where the
  day holds a note`
- [ ] 8.6 `a row for a date earlier than the day it is asked as of offers the note entry`
- [ ] 8.7 `a row offers the note entry whether or not the day is already kept`
- [ ] 8.8 **Not a new test.** The existing test named `a row offers a tick or a number entry and
  never both` gains the one clause the delta added to that scenario: a row for a commitment alike in
  every way but of the note kind offers neither of them. Its `@Test` display name does not change,
  and no other assertion in it changes. This box exists because the scenario is already *covered* by
  `scripts/check-scenario-coverage.ts` — the checker maps title to test and cannot see that the body
  moved — so nothing but this box would make the added clause get written.

## 9. `day-screen` — what a row is

Two scenarios from the MODIFIED § *A row is a commitment's line on a date*, in
`Tests/DayByDayKitTests/DayViewTests.swift`. Expect both green once § 8's stored `note` is in, since
`Row` is `Hashable` with synthesized conformance; a red test here means the note was excluded from
equality by hand, which `design.md` rejects.

- [ ] 9.1 `two rows for the same note commitment and date holding different notes are different rows`
- [ ] 9.2 `two rows for the same note commitment and date holding the same note are the same row`

## 10. `day-screen` — what a note entry says

Four scenarios from § *A note entry says the note the day already holds, and says nothing else*, in
`Tests/DayByDayKitTests/DayViewTests.swift`.

- [ ] 10.1 `a note entry says the note the history holds for that commitment on that date`
- [ ] 10.2 `a note entry says a note of many lines and many characters whole`
- [ ] 10.3 `a note entry says no note where the day holds none`
- [ ] 10.4 `a row for a note commitment holding a note says its name, its rhythm and that the day is
  kept` — the row still says nothing about the note, which is the grill's answer 7 and the whole of
  what makes a note reachable only through the entry.

## 11. `day-screen` — entering a note

Fourteen scenarios from § *A day screen enters the note a row's entry takes, and keeps it before the
day view says so*, in `Tests/DayByDayKitTests/DayScreenTests.swift`. `DayScreen.enter(_:on:)` is
**widened, not twinned** — `design.md` § *`enter(_:on:)` dispatches on what the row offers* — and the
number branch is not touched. `RecordStore.removeNote(on:)` joins its private twin at the foot of
`DayScreen.swift`.

- [ ] 11.1 `entering a note on a row makes the day screen say the commitment is kept`
- [ ] 11.2 `a note entered on a day screen is held by a day screen opened afterwards at the same
  place`
- [ ] 11.3 `the note entry a row offers says the note just entered on it`
- [ ] 11.4 `a note entered on a day that already holds one replaces it`
- [ ] 11.5 `committing an empty note entry takes the note back`
- [ ] 11.6 `committing an empty note entry on a day that holds no note leaves the day as it was`
- [ ] 11.7 `a note that cannot be kept is refused and leaves the day view as it was`
- [ ] 11.8 `entering a note on a row the day screen's day view does not hold changes nothing`
- [ ] 11.9 `committing on a row that offers no note entry changes nothing`
- [ ] 11.10 `a commit is read as the entry the row it was made on offers` — the one that pins the
  dispatch: "70.5" on a number row is the number 70.5 and on a note row is the note "70.5". A screen
  that read the text before asking the row fails it.
- [ ] 11.11 `entering a note on a day screen that is not keeping a record changes nothing and keeps
  nothing`
- [ ] 11.12 `entering a note on one row leaves the other rows of the day as they were`
- [ ] 11.13 `entering a note on a day a day screen has moved back to keeps it on that day`
- [ ] 11.14 `entering a note writes nothing to the roster's place`

## 12. `day-screen` — reading what was committed, in both entries

Six scenarios from § *A day screen reads what is committed in a note entry as a note or as a
take-back* and two from the MODIFIED § *A day screen reads what an entry is committed with as a
number, as a take-back, or as neither*, all in `Tests/DayByDayKitTests/DayScreenTests.swift`. The
note's reading is two lines and both of them call `Blank` — `design.md` § *One whitespace test, in
one place, and it is Swift's*. Do not reach for a `CharacterSet` here; 12.4 is the box that catches
it.

12.7 and 12.8 are the residual round's answer, settled with the owner on 2026-09-08 before G4 and
recorded in `grill.md` answer 5 and `design.md` § *Open Questions*. Between them they change **one
expression** in a requirement `add-number-entry` signed four days earlier, and 12.7 carries the
regression check that the whole argument for making the edit rests on: the eight archived scenarios
of that requirement must answer exactly as they did.

- [ ] 12.1 `a note committed with space around it is kept without that space and unchanged within it`
- [ ] 12.2 `a note committed with space inside it keeps every character of that space`
- [ ] 12.3 `an entry committed empty takes the note back, and one holding nothing but blank space does
  the same`
- [ ] 12.4 `an entry committed with line breaks alone takes the note back` — the box that fails a
  reading written on `CharacterSet.whitespaces`, which does not contain a line break
  (`design.md` § *Context* measurement 1).
- [ ] 12.5 `a note of one visible character among blank space is written rather than taken back`
- [ ] 12.6 `a note of any length, any script and any number of lines is entered whole`
- [ ] 12.7 `an entry committed with line breaks alone takes the number back` — expected **red** on
  the trim that ships today, which leaves `"\n\n\n"` standing and reads it as *not a number*. The
  smallest change that makes it pass is `read(_:)`'s first line becoming `Blank.trimmed(text)` in
  place of `text.trimmingCharacters(in: .whitespaces)`, and **nothing else in `read(_:)` may move** —
  not the sign handling, not the digit loop, not the separator count, not the
  thirty-eight-significant-digit guard, not the `Decimal(string:)` call. Then run the whole suite: the
  eight tests named for the archived scenarios of *A day screen reads what an entry is committed with
  as a number, as a take-back, or as neither* must all still be green, and so must every other test
  already passing. **A red one there is a rule-5 stop, never a test to update** — it would mean
  `design.md` § *Context* measurement 2a is wrong about which texts change answer, and that
  measurement is the evidence the owner settled the residual round on.
- [ ] 12.8 `an entry committed with a zero-width space alone keeps nothing and takes nothing back` —
  the direction the fix exists for. Write the character as `"\u{200B}"` and assert all four clauses:
  the number 70.5 still stands, the day is still kept, the row is told "Not a number", and a day
  screen opened afterwards at the same place says the same. Expect this **green as soon as 12.7's one
  expression is in**, since it is the other direction of that expression; record in § 16.1 whether it
  actually ran red, and do not edit `read(_:)` again to make it red.

## 13. `day-screen` — what is told on a row

Six scenarios across three MODIFIED requirements, in `Tests/DayByDayKitTests/DayScreenTests.swift`.
No new cause is named anywhere in this section: a note has no refusal of its own, so every one of
these is either the place's silent refusal or nothing told at all.

- [ ] 13.1 `a note refused by the place is told on the row and names no cause` — including the
  hundred-thousand-character clause, which is what pins that length is never a cause.
- [ ] 13.2 `what a day screen tells on a row ends when a note is written and kept`
- [ ] 13.3 `what a day screen tells on a row ends when a note is taken back and kept`
- [ ] 13.4 `a commit on a row that offers no entry at all is told nothing on the row`
- [ ] 13.5 `a commit on a note row on a day screen that is not keeping a record is told nothing on the
  row`
- [ ] 13.6 `a commit on a note row for a day that has not arrived is told nothing on the row`

## 14. The app shell

This section rides this Story's branch under `CONTEXT.md` § *App shell*'s third condition — it exists
only to make the Story usable, its consumer lands in the same PR, and it introduces no behaviour the
kit does not specify. It is not tested (`docs/open-questions.md` § *No UI smoke layer*).

- [ ] 14.1 In `src/DayByDay/ContentView.swift`, give a row that offers a note entry a tap that opens a
  sheet holding one multi-line text field, prefilled from `entry.note` and with no placeholder at
  all; Save calls `try? screen.enter(text, on: row)` and closes; Cancel closes and calls nothing.
  Draw the same disclosure affordance a number row already carries. **No character limit on the
  field, no counter and no validation** — there is none to draw, and inventing one in the shell would
  be a requirement in the one file nothing tests.

## 15. The documents

`docs/adr/1039-blank-is-one-test-asked-in-one-place.md`, the 2026-09-08 amendment on
`docs/adr/1033-a-number-is-taken-back-by-naming-the-day.md`, their rows in `docs/adr/README.md` and
the three edits to `CONTEXT.md` — the new **Note entry**, and the amendments to **Note** and **Row**
— are **written with this folder** and are in the G4 diff, so these boxes confirm rather than write.

- [ ] 15.1 Confirm before the review that 1039 is still the lowest free ADR number:
  `for r in $(git for-each-ref --format='%(refname)' refs/heads refs/remotes); do git ls-tree --name-only $r docs/adr/; done | sort -u`.
  1038 was the highest on any local or remote ref on 2026-09-08, taken by
  `story/147-add-commitment-category`. **Report rather than renumber** if another branch has taken
  1039 (`AGENTS.md` rule 5).
- [ ] 15.2 Confirm 1033's amendment still says what the code does, now that the code exists — in
  particular that `History` takes a note back by `for:on:` as it takes a number back, that nothing
  acquired an overload of `remove(_:)` taking a `Note`, and that its filename is unchanged, since
  `openspec/changes/archive/2026-09-07-add-number-record/tasks.md` § 8 names that path and the
  archive may not be edited.
- [ ] 15.3 Confirm 1039 describes the code that was actually written: one `Blank`, called by
  `Commitment.init?`, by `Note.init?`, by `DayScreen.enter(_:on:)`'s note branch and by
  `DayScreen.read(_:)`'s number trim, with **no exception** — and that the one `CharacterSet` still
  in the package is `CommitmentsScreen.nameTypedBackMatches`, which 1039 names and excuses by reason
  rather than by omission. `grep -rn "whitespaces\|isWhitespace" src/DayByDayKit/Sources/` is the
  check, and it should return `Blank.swift` and that one line and nothing else. An ADR that has
  drifted from the implementation is edited in place and stamped, per `docs/adr/README.md`; a
  decision that has actually changed is a stop, not an edit.
- [ ] 15.4 Confirm `CONTEXT.md` gained **Note entry** and three amendments — to **Note**, to **Row**
  and to **Number entry**, the last of them the residual round's — and **no other term**. A new term
  appearing here means something was decided that should have been asked.

## 16. Closing the Story

- [ ] 16.1 Record in this file, under a `## Notes` heading appended at the end, which of the boxes
  predicted red in §§ 3, 6, 7, 9 and 12 actually ran red before the code that satisfies them was
  written — 12.7 and 12.8 among them, since 12.8 is predicted green on 12.7's edit and that
  prediction is the claim that one expression closes both directions. A prediction in a task is not
  evidence; this is.
- [ ] 16.2 `pnpm run verify` green from the repo root, and `pnpm run checks` reporting
  `scenario coverage — 194/194`. `cd src/DayByDayKit && swift test` reports **705 tests passing** —
  628 at the branch point plus the seventy-seven written here, plus none removed. A different number
  means a test was added or lost outside rule 3; report it.
- [ ] 16.3 Open the app on a phone or the simulator with `pnpm run phone` and confirm by hand what
  nothing tests: define a note commitment, type a paragraph with a line break in it, save, force-quit
  the app, reopen it and read the note back whole; then open the field, clear it, save, and confirm
  the day goes back to not kept. Confirm too that the day screen still draws its nine day-one ticks
  and that ticking one still works — the store's fourth form is the thing a real phone is exposed to.
- [ ] 16.4 Run `/opsx:archive` as the last commit on the branch, then push it. **The janitor's own
  instruction, not a box that waits on the archive:** after the archive has run, read
  `openspec/specs/record/spec.md` and confirm that *A store reads a history kept before a commitment
  carried a kind* is still the first requirement and *A tick is of a commitment on a calendar date it
  is due on* still the second, and that `openspec/specs/day-screen/spec.md` still opens with *A day
  view is the commitments due on a date, each with whether it is kept*. Any drift there is a stop and
  a report, never a hand-edit: `openspec/specs/` is written by `/opsx:archive` and by nothing else
  (`AGENTS.md` rule 2).
- [ ] 16.5 Land one entry in `docs/open-questions.md` as a **chore commit that merges before this
  Story's archive**, not on this branch — `AGENTS.md` § *Agent roles* puts that file outside a
  Story's reach, and landing it first is what lets this box be ticked on evidence rather than in
  anticipation of a merge still to come (the ordering `add-number-record` § 9.5 settled). The entry:
  the public-surface gap has a twelfth face, in that a row now gives a note out through the entry it
  offers while still giving no tick out, and `History` answers three questions three ways. Also close
  the half of *A commitment of a kind nothing can yet record is a row that does nothing when tapped*
  that this Story spends, leaving it open for the total alone.

  **The whitespace defect is deliberately not among them.** The delta as first written owed this file
  a second entry recording that a lone U+200B silently takes a day's number back; the residual round
  settled on fixing it instead, both directions close in § 12.7, and a known gap that is not a gap
  any more is noise in the one file that is meant to be read as the live list. `grill.md` answer 5,
  `design.md` § *Open Questions* and ADR-1039 carry the history between them.
