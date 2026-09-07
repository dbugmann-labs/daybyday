## Why

`add-number-record` (#138) made a number recordable and left it unreachable. A number commitment's
row still offers a tick that `record` refuses to form, so a weight defined on the commitments screen
is a line that answers nothing to a tap — the state `docs/open-questions.md` § *Known gaps* records
as "a commitment of a kind nothing can yet record is a row that does nothing when tapped". This
Story gives that row something to offer, and it is the first entry in this product that is not one
tap.

It is the third of the six Stories under `FEAT: record` (#53) and the first of them in `day-screen`.
#140's note and #141's total will each copy the shape it settles: what a row offers when its
commitment's kind is not a tick, how a value the commitment refuses is told, and where the text a
person types stops being text.

## What Changes

- **A row offers a number entry where its commitment's kind is a number** — one or the other,
  never both, and never either for a day that has not arrived. That last is deliberate and is
  answer 6 of the grill: a tick row on a future day answers a tap with silence (B-035), and this
  change declines to repeat it rather than fixing it.
- **A number entry says two things: the range its commitment takes, as a hint — `40–150` — and the
  number the day already holds.** The hint is what stops a range teaching a person by refusing
  them. The number is what makes committing an empty entry a deliberate erasure rather than the
  result of tapping and confirming.
- **The row itself never says the number.** It says its name, its rhythm in words and whether the
  day was kept, exactly as a tick row does. The owner settled that at the grill against the
  Story's own intent: "the number itself is not important, it's only important that an entry was
  made ... at least on the day screen". The number is reachable only through the entry, which is a
  shape rather than a rule anyone has to keep.
- **A day screen enters the number a row's entry takes, and keeps it before the day view says so**
  — the same order a tick already runs in. A number entered over a day that holds one replaces it,
  which is `record`'s answer and not a second rule here.
- **Committing an empty entry takes the number back.** There is no other way to reach `record`'s
  take-back from a row, and no later Story in this lane carries one — #140 is the note and #141
  the total — so a number entered on the wrong day would otherwise be permanent.
- **A day screen reads the text an entry is committed with, and that is where text stops being
  text.** It reads a comma exactly as it reads a full stop, because an iPhone's decimal keypad
  prints whichever its region says and a field that refuses the key on the keyboard is broken on a
  German phone. It consults no locale to do it (ADR-1004): it accepts both separators rather than
  asking which one to expect.
- **A notice may name a cause, where the cause is one a person can act on differently.** This
  reverses one sentence signed on 2026-09-06 — *tells every refusal the same way, and names no
  cause*. Two causes are named and no others: a value that is not a number ("Not a number") and a
  number outside the commitment's range ("Must be between 40 and 150"). Recorded as
  `docs/adr/1036-a-notice-names-a-cause-a-person-can-act-on.md`, because the notice was
  deliberately built unable to carry one.
- **A refusal that never reaches the record's place is now sometimes told.** *A day screen tells
  nothing on a row where there was no tick to refuse* opens by saying a tap that never reaches the
  place is not a refused change; a range refusal never reaches the place and must still be told,
  because trying 300 again against 40 to 150 fails for ever. The three cases that stay silent stay
  silent, and each gains its number-row twin.
- **Not in this change:** the mood slider (B-034), which stays a want and still carries two
  unanswered questions; prefilling a day from the last number given (B-032), which is not the same
  thing as answer 8's prefill from the day's own record; B-035, the tap a future row does not
  invite; the note (#140), the total (#141), and choosing a kind on the commitments screen (#142).

## Capabilities

### New Capabilities

None. Everything here is a row on a day screen and a change kept at that screen's record place,
which is what `day-screen` is. `record` is **untouched**: #138 already made a number, gave a history
the read-back and the take-back, and settled every refusal a value can meet, so this Story adds no
requirement there and takes none away.

### Modified Capabilities

- `day-screen`: four requirements **ADDED** and four **MODIFIED**.
  - ADDED *A row offers the number entry its commitment takes, and offers none for a day that has
    not arrived* — the offer, the two refusals, and that a row offers at most one of a tick and a
    number entry.
  - ADDED *A number entry says the range its commitment takes and the number the day already
    holds* — the hint, the read-back, and what the row goes on saying instead.
  - ADDED *A day screen enters the number a row's entry takes, and keeps it before the day view
    says so* — the entry, the take-back, the four taps that change nothing, and the order a change
    is kept in.
  - ADDED *A day screen reads what an entry is committed with as a number, as a take-back, or as
    neither* — the separator, the shapes that are not numbers, and that an empty entry is never
    one of them.
  - MODIFIED *A row is a commitment's line on a date*: it says today that a row gives back four
    things, the fourth being "the tick it offers". A number row offers no tick. What a row **is**
    also grows by one — the number the history holds for it — because two rows of one number
    commitment on one date holding different numbers offer different entries and neither can stand
    in for the other, which is the argument the date already carries.
  - MODIFIED *A day screen tells on the row that was tapped that a change could not be kept*:
    "SHALL name no cause" becomes "SHALL name a cause only where a person can act on it
    differently", with exactly two such causes named.
  - MODIFIED *A day screen tells nothing on a row where there was no tick to refuse*: a refused
  value never reaches the place and is told anyway; the three silent cases stand and now cover an
  entry as well as a tap. - MODIFIED *What a day screen tells on a row lasts until the app is
  shown again, a change is kept, or the day it is showing changes*: a number that lands and a
  number taken back are both changes that reach the place. The three ends do not grow to four —
  **Cancel is not one**, and it cannot be, because a person closing an entry without committing it
  says nothing to the screen at all.

***A row offers the tick that keeps its commitment*** **is deliberately not modified.** Its own text
says "what a row offers *instead* of a tick is not this requirement's" — and this delta is that
requirement. Every sentence in it stays true: a row still offers exactly one tick or nothing, still
refuses for those two reasons and no other, and a number row still offers no tick on any day.

**Two requirement titles now undercount their own bodies, and neither is renamed.** *A day screen
tells on the row that was **tapped*** is told of a commit too, and *A day screen tells nothing on a
row where there was no **tick** to refuse* now covers a commit that never reached the place. Both
were considered as `RENAMED` and neither is, for the reason `add-commitment-kind` (#137) measured
and `add-number-record` (#138) re-measured: **`openspec` 1.10.0 moves a renamed requirement to the
bottom of the recomposed spec**, and `openspec/specs/` may not be hand-edited afterwards (rule 2).
A stale title is a blemish one line of `RENAMED` fixes the day the tool preserves position; a
wrecked reading order in a 2,300-line spec is permanent.

Every requirement restated under MODIFIED keeps its existing scenarios **verbatim**, and **no test
written for one of them may be renamed or have an assertion changed** beyond the mechanical rename
in `tasks.md` § 1. Twenty-seven of the delta's seventy-three scenarios are restatements already
carried by passing tests; forty-six are new.

`record`, `commitment`, `schedule` and `cli-version` are untouched.

## Impact

- **`src/DayByDayKit`** — no new file. `DayView.swift` gains `NumberEntry`, the number a row was
  formed with, `Row.numberEntry(asOf:)` beside `Row.tick(asOf:)`, and — beside `Row.tick(asOf:)`
  for the same reason — `Row.number(_:asOf:)`, which makes the record so that a screen never has
  to; `DayScreen.swift` gains `enter(_:on:)`, the reading of the committed text, and `Notice` in
  place of the bare `refusedChangeRow`. Nothing else in the package is edited — `Number`, `History`
  and `RecordStore` already carry everything this needs, which is what #138 was for, and the one
  adapter that spells `record`'s take-back for a row-made record sits in `DayScreen.swift` rather
  than in `record`'s own file.
- **One public property is renamed, and it costs 26 mechanical edits in one existing test file.**
  `DayScreen.refusedChangeRow: DayView.Row?` becomes `DayScreen.notice: Notice?`, because a notice
  now carries a second thing and `add-refused-tick-notice`'s own `design.md` rejected a companion
  property in as many words — "no `RefusalReason`, no message string, no count, no `Bool`
  alongside it". `notice` is also the word `CONTEXT.md` § *Refused change* reserves for this on
  the day screen, where `RefusedChange` is the commitments screen's and is already taken by a
  different type in the same module. `tasks.md` § 1 lists every site by line; **no `@Test` display
  name and no assertion's meaning changes there**, and a red test in that section is a rule-5
  stop.
- **`src/DayByDay`** — `ContentView.swift` draws the field: a number row opens an alert holding
  one text field with Save and Cancel, prefilled from the entry, placeheld with its hint, with a
  disclosure chevron on the row saying it is the kind that opens something. That is shell work
  with no requirement of its own (`CONTEXT.md` § *App shell*), and `docs/open-questions.md` § *No
  UI smoke layer* means nothing automated proves it was drawn. `tasks.md` § 8 runs it on the
  phone.
- **Tests** — 40 new acceptance tests, one per new scenario, all in
  `Tests/DayByDayKitTests/DayViewTests.swift` and `Tests/DayByDayKitTests/DayScreenTests.swift`.
  Measured on this machine on 2026-09-07, Apple Swift 6.3.3 (swiftlang-6.3.3.1.3), target
  `arm64-apple-macosx26.0`: `cd src/DayByDayKit && swift test` reports **489 tests passing** at
  `8f78852`, the branch point after this folder was rebased onto it; this change takes it to 535.
  `openspec` is 1.10.0 and `node --version` is v24.19.0.
- **`openspec/specs/`** — `day-screen/spec.md` alone, rewritten at archive time by `/opsx:archive`
  and nothing else. One capability is claimed and one is edited, so CI check 2 stays green.
- **ADRs** — one new, `1036-a-notice-names-a-cause-a-person-can-act-on.md`. 1036 is the lowest
  number no file and no branch has used: 1035 is taken by `story/145-add-roster-removal`, checked
  across every local and remote ref on 2026-09-07.
  `docs/adr/1021-a-day-screen-without-its-record-draws-the-day.md` is **not** amended, and 1036
  says why: 1021 decides what a screen does with a record it cannot open, and every word of it
  stays true.
- **`CONTEXT.md`** — one new term, **Number entry**, and two amendments, § *Row* and § *Day
  screen*. All three were settled at the grill and drafted in `grill.md` § *Terms landed in
  CONTEXT.md*, but none of them reached the file: the grill commit `f1f10cb` touches `grill.md`
  and `.openspec.yaml` and nothing else. They ship in this folder, in the G4 diff.
- **`docs/open-questions.md`** is not this change's to write (`AGENTS.md` § *Agent roles*).
  `tasks.md` § 9 names the two lines it owes as a chore commit: the known gap "a commitment of a
  kind nothing can yet record" closes for the number kind and stays open for the note and the
  total, and the public-surface gap gains an eleventh face — a row gives its number out through
  the entry it offers and still gives no tick out.
- **`docs/backlog.md`** — untouched. B-032, B-034 and B-035 stay wants; nothing here promotes one,
  and a want is written by `/atlas idea` on `chore/backlog` rather than by a Story.
- **No new dependency, no CI change, no change to any command, and no change to either store's
  form on disk** — a number was already persisted by #138, so a phone that has one keeps it.
