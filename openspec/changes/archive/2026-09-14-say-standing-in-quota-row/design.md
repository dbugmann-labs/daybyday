## Context

See `proposal.md` § *Why* and `grill.md`, whose eight settled answers this delta is written on.

- **`Schedule.inWords` is the one composer.** It is a public computed property over the internal
  `ScheduleWords` table; `Commitment.rhythmInWords` and `DayView.Row.rhythmInWords` pass it on, and
  the commitments screen and the form preview (`Rhythm.inWords`) read the plain words.
- **`History.standing(for:through:)` is public** and answers the count this row says, for any
  commitment and consulting no schedule.
- **`DayView.Row` is synthesized `Hashable`** over its commitment, date, kept, number, note and sum.
  Row equality is read by `DayScreen.swift:223, 255, 352` and by the shell's notice match
  (`ContentView.swift:499`).
- **The shell draws `row.rhythmInWords` as it is** (`ContentView.swift:488`), so no shell file moves.
- **One shipped test falsifies:** the test of *a row says the rhythm its commitment runs on in
  words* asserts "3x a week" on a Monday with no ticks (`DayViewTests.swift:970-972`). No other
  row- or day-view-sameness scenario or test uses a weekly quota.

## Goals / Non-Goals

**Goals:**

- The counted words composed in `schedule`, read by a row, with no English in `day-screen`.
- A standing that exists on a weekly quota's row and nowhere else, so rows differ only visibly.

**Non-Goals:**

- **No met state, no standing accessor, no second wording** for the commitments screen or preview.
- **No change to `record`**: the count is `History.standing` as shipped.

## Decisions

### The seam

Existing seams carry every day-screen scenario: `DayView.init(of:on:in:)`, `Row.rhythmInWords`,
`Row.tick(asOf:)` and row equality. The schedule scenarios attach at one new member.

- `public func inWords(given count: Int) -> String` — on `Schedule`
- `let standing: Int?` — on `DayView.Row`, internal
- `static func weeklyQuota(_ timesPerWeek: Int, given count: Int) -> String` — on `ScheduleWords`, internal

### A second member beside `inWords`, not a parameter on it

`inWords` stays exactly as it is for its three readers, and `inWords(given:)` is the counted form.
The label is `CONTEXT.md`'s phrase, "said given a count".

- Rejected: `inWords(standing: Int?)` — a nil that means "plainly" is a flag in an optional's clothes.
- Rejected: `Commitment.rhythmInWords(given:)` — a second pass-through with one caller.
- Rejected: composing the slash in `DayView` — grill answer 5 and ADR-1034 put the English in `schedule`.

### A row stores its standing, and stores none off a weekly quota

A day view asks `History.standing` while forming each row whose commitment's schedule is a weekly
quota, and stores `nil` for every other row. Synthesized equality then yields grill answer 3 with no
hand-written `==`: quota rows differ by standing, other rows cannot. The day view still counts
nothing and enumerates no history; it asks one more of `record`'s answers per commitment.

- Rejected: a standing on every row — two Gym rows would differ by a count nobody reads.
- Rejected: storing the composed string — equality would rest on English rather than on the count.

### The row-identity requirement keeps its title

*A row is its commitment, its date and what that day holds* now also names the standing. The title
stays, since a standing is what the history holds through that day; a rename is a REMOVED and ADDED
of ten shipped scenarios for no change in behaviour. Its "three things and no others" sentence and
the rhythm requirement's "alike in the three things say the same rhythm" consequence are rewritten.

### ADR-1034 and ADR-1050 are amended, and no ADR is new

ADR-1034 says the rhythm "is still not a fourth thing a row is" and that the words say "the shape and
its number and nothing else"; ADR-1050 says pairing the count with the quota is the day screen's.
Grill answers 3 and 5 reverse the first and correct the second. Both records keep their decisions —
words in the package, the week in the history — so each gains a dated amendment in place.

### Migration

None — no persisted type or encoding changes; a row is formed afresh from records already kept.

## Risks / Trade-offs

- **A standing held on every row** is the likeliest wrong implementation. → The non-quota sameness
  scenario catches it.
- **A count of the whole week, or of a seven-day window**, reads right on Sundays. → The sameness
  scenario with ticks on the Sunday before and the Thursday after, and the through-its-date scenario.
- **Rows on a quota change identity when the history does.** → On a day screen a change lands on the
  day shown, which already changes that row; a notice ends on a kept change, a move or a re-show.
- **Seven `isKept` reads per quota row per draw.** → Accepted in #235; no I/O and no clock.

## Open Questions

None. `grill.md` § *Left open* is "None." with its reason, and writing the delta raised no preference
the grill had not settled: the slash with no spaces is the settled form, a negative count's
hyphen-minus is answer 7 said literally, and the kept title is a cost of the archiver, not a product
choice. No residual round is outstanding.
