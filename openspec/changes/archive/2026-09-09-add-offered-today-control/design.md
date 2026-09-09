## Context

See `proposal.md` § *Why*, and `grill.md`, whose ten settled answers this delta is written on. What
matters here is that **offered** is already landed — `CONTEXT.md` § *Offered*, agreed at the Feature
grill that reopened `FEAT: day-screen` (#27) on 2026-09-08, product-wide rather than this screen's —
so nothing in this change argues about the rule. It decides where the rule lives in the code, and
what it does not touch.

**Eight facts, read off this worktree at `264c5a7`, 2026-09-08.** The first six decide the shape; the
last two decide how big the change is and are the ones to re-check before starting.

- **A day screen gives out neither of the two days the answer turns on.** `today` and `shownDay` are
  both `private` (`DayScreen.swift:24` and `:25`), and nothing public gives either back — `title`
  says the day in words, and a word is not a date. So the shell has nothing to compare, and making
  them public to let it compare would put the offered judgement in a file no test at the seam
  reaches.
- **A row already computes all four offers, each with the same guard.** `tick(asOf:)`
  (`DayView.swift:64`), `numberEntry(asOf:)` (`:74`), `noteEntry(asOf:)` (`:107`) and
  `totalEntry(asOf:)` (`:131`) each open with `guard today.days(until: date) <= 0`. There is nothing
  to add to any of them; the new answer is read off the four.
- **`offersTakeBackLast(asOf:)` (`DayView.swift:164`) is the shape to copy**, and it is also why the
  take-back is not a fifth thing to ask about: it is `totalEntry(asOf: today) != nil && total > 0`,
  so a row offering it necessarily offers a total entry.
- **`tick(asOf:)` guards only the date, and the kind is `Tick`'s own refusal.** `Tick.init?` returns
  `nil` unless `commitment.kind == .tick` (`Tick.swift:11`) and unless the commitment is due
  (`Tick.swift:6`, which a row satisfies by construction). So "offers a tick" already means the tick
  kind on an arrived day, and no fifth guard is needed anywhere.
- **`Commitment.Kind` has exactly four cases** — `tick`, `number`, `note`, `total`
  (`CommitmentKind.swift:5`–`:9`) — and since `add-total-record` (#141) each of them offers exactly
  one thing on a day that has arrived. That is why the derived answer and a date comparison give the
  same answers today, and why the requirement is written on the offers rather than on the date.
- **`showToday()` (`DayScreen.swift:474`) already answers rather than refuses** on a screen showing
  its today: it clears no notice, sets `shownDay` to `today` and re-forms the day view. Nothing in
  this change touches it.
- **The shell draws both controls unconditionally today.** The *Today* button is drawn with no
  condition at all (`ContentView.swift:126`–`:132`), and every row is a tappable `Button` whatever it
  offers (`ContentView.swift:164`–`:212`) — the `else` branch of its tap calls `screen.tick(row)`,
  which does nothing on a row that offers no tick. Nothing a person can see says so.
- **885 tests pass**, measured with `swift test` in `src/DayByDayKit` on this branch cut from `main`
  at `264c5a7`, 2026-09-08. `WalkthroughUITests.swift:26`–`:28` asserts `app.buttons["Today"]` on a
  screen that has just opened on its today, so **that assertion is expected to go red** the moment the
  button is hidden, and `tasks.md` § 4 is where it is answered.

**`main` moved once while this was being written, and the branch is rebased onto it.** `fe540d5` is
the base now: `chore(day-screen): swipe the day left and right` (#177) and a backlog capture. That
chore touched `ContentView.swift`, `CONTEXT.md` and `docs/adr/` and **nothing under
`openspec/specs/`**, so `openspec validate --strict` still passes against the specs as they stand and
§ 1.3's stop has not fired. It reaches this Story in three ways and no fourth: every
`ContentView.swift` line cited above still holds, because the swipe is a `.simultaneousGesture` added
at `:223` and a `daySwipeGesture` at the end of the file; **ADR-1042** now says the horizontal swipe
is the day screen's permanently, which is a rule about a gesture no row here takes; and the
walkthrough at `tasks.md` § 4.4 gains one thing to confirm, because a row that stops being a `Button`
sits under that same recognizer.

## Goals / Non-Goals

**Goals:**

- One answer per control, held where the answer can be held: the screen for the way back to today,
  the row for whether it is something to tap.
- A row's answer derived from the offers it already computes, so that a kind added later inherits it
  rather than needing four call sites found again.
- Both wants served on the phone in this branch, with the shell computing neither answer.

**Non-Goals:**

- **No refusal is added anywhere.** `showToday()`, `tick(_:)`, `enter(_:on:)` and `takeBackLast(on:)`
  accept exactly what they accept today. Offered governs what is drawn as a target.
- **No date picker, no swipe, no chevron change.** B-040 and B-038 are separate work
  (`docs/backlog.md`, 2026-09-08), and the calendar's two ends stay exactly as
  `add-screen-navigation` (#93) left them.
- **No new vocabulary.** *Offered* and *target* are landed; this Story coined nothing and
  `CONTEXT.md` is untouched.
- **Nothing about what a control looks like.** Hidden rather than drawn-and-inert is the want's own
  word and the shell's job; the delta says only what is offered.

## Decisions

### The seam

**No new file, no new type, no changed signature.** Two existing seams gain one member each, and
every scenario in this delta is driven at one of them:

- **`DayScreen.offersGoingBackToToday: Bool`** — a computed property, taking no argument, `true`
  exactly when the day being shown is not the today the screen was last handed. It takes no argument
  because the screen holds both days already; a `asOf:` form would be a second today handed in
  beside the one the screen was given, and the two could disagree.
- **`DayView.Row.offersAnything(asOf today: CalendarDate) -> Bool`** — `tick(asOf:) != nil ||
  numberEntry(asOf:) != nil || noteEntry(asOf:) != nil || totalEntry(asOf:) != nil`, and nothing
  else. It takes the day exactly as the five offers before it do.

The three carried scenarios under the MODIFIED requirement are driven where they already are —
`showPreviousDay()`, `showNextDay()`, `title` and `dayView` — and no test behind them may be
renamed, moved or have an assertion changed.

### Why the screen answers about the control, and not about the position

`DayScreen.offersGoingBackToToday` says whether the way back is offered. The rejected alternative was
something like `isShowingToday` — one fact rather than one answer per control, and cheaper by one
member the day a second control needs the same comparison.

It was rejected because it answers a different question. The screen keeps its two days private on
purpose, and a public "am I showing my today" is that comparison given back under another name: a
caller can then draw anything it likes off it, including things the screen would not honour, and the
judgement leaves the screen again. Phrasing it as the offer keeps `CONTEXT.md` § *Offered* true —
*what bounds it is what the screen holds the answer to* — and makes the next control's answer a new
member rather than a new reading of this one.

The cost is honest and small: a second control that happens to be bounded by the same comparison
adds a second computed property over the same two fields.

### Why the row's answer is derived from the offers and not from the date

The two are indistinguishable today, and `grill.md` § *Settled* 4 chose which sentence the
requirement states: **a row is not a target exactly when it offers nothing**, rather than when its
date has not arrived. `CONTEXT.md`'s own sentence is the first one, and a fifth kind whose row offers
nothing on an arrived day — or an existing kind that one day offers nothing for a reason of its own —
is answered right by it without this requirement being reopened.

The alternative that was actually on the table was worse than a date comparison: four `nil` checks in
`ContentView.swift`, which is what the shell already writes to decide which sheet to open
(`ContentView.swift:165`–`:180`). Left there, the gate is one `||` chain a fifth kind must be
remembered into, in a file no acceptance test reaches. `grill.md` § *Settled* 5.

### Why `offersAnything` and not `isTarget`

**`target` is taken twice in this domain and neither use is this one.** `CONTEXT.md` § *Target* is
the sum a total has to reach, and `Commitment.Target` is that value in code. `CONTEXT.md` § *Offered*
does use "target" in the drawing sense — *a screen draws as a target only what it offers* — but a
member called `isTarget` would sit next to `TotalEntry.soFarOfTarget` meaning something else entirely.
The requirement is written in the drawing sense, where the prose can say which is meant; the seam is
named for the offer, where it cannot.

### The chevron refusal is read against this, and that is the whole of the MODIFIED requirement

*A move with nowhere to go leaves a day screen exactly as it was* says, in as many words, that a day
screen **SHALL NOT say whether it can move either way** and that *what is drawn where a move does
nothing is the shell's to decide rather than this capability's*. That sentence was written by
`add-screen-navigation` (#93) about the chevrons, and it stands: the two ends are 1 January 1583 and
31 December 9999, so the answer would be the same on every day anyone will look at.

A reader meeting it beside a screen that now answers about the *Today* control should not have to
infer the difference, so this delta adds **one paragraph** to that requirement saying it. No `SHALL`
moves, no scenario changes, and all three scenarios are carried verbatim with the tests that already
cover them.

**This is the one judgement in the delta that `grill.md` did not settle explicitly**, and it is
recorded here rather than sent back as a question because it is a matter of keeping two live
requirements legible rather than a preference about the product: the alternative is to leave the
reconciliation in `CONTEXT.md` alone (`grill.md` § *Settled* 10 notes it is already there) and let the
spec read as though it contradicted itself. The paragraph is visible in the G4 diff, which is where a
judgement like this is cheapest to overrule.

### `showToday()` is untouched, and so is the notice requirement

`grill.md` § *Settled* 3 and 7. *A day screen goes straight back to the today it was handed* stands
verbatim, including *going back SHALL be an answer rather than a refusal*, and it is carried into this
delta nowhere. *A day screen tells nothing on a row where there was no tick to refuse* keeps its
day-that-has-not-arrived case unchanged, because the seam stays callable: a tap on a non-target row is
still reachable behind it once no UI can produce one, and deleting the case would leave a public seam
call with no stated answer. `docs/backlog.md`'s B-035 line expected that requirement to be amended;
the grill settled otherwise, and the answer wins.

### The shell rides this Story

`ContentView.swift` gets both conditions, under ADR-1019's 2026-09-04 amendment, whose three
conditions hold: the shell is the immediate consumer and lands in the same PR; it introduces no
behaviour the kit does not specify; and it is `tasks.md` § 4, its own section, for the reviewer.

- **The *Today* button is drawn only where `screen.offersGoingBackToToday`.** Hidden, not
  drawn-and-inert — B-028's own word is "should not exist" — and the shell computes nothing to know
  it.
- **A row is a `Button` only where `row.offersAnything(asOf: today())`.** Where it offers nothing the
  same label is drawn as plain content: the row stays, says its name, its rhythm and whether the day
  is kept, and only its tap goes. That is `CONTEXT.md` § *Offered* verbatim, and it is the whole of
  the change — no message, no greying rule, no second style, because B-035 was answered **against its
  own words** at the Feature grill (`docs/backlog.md`, 2026-09-08).
- **The four `nil` checks stay where they are.** `ContentView.swift` goes on asking which entry to
  open once the tap is known to be offered; what it stops doing is deciding whether there is a tap at
  all.

### The walkthrough moves a day back

`WalkthroughUITests.swift` asserts the *Today* button on a screen that has just opened on its today,
so hiding the button makes it red. It moves a day back first and then asserts, which keeps ADR-1029's
rule that this layer proves the shell drew rather than what it drew — and the assertion then also
fails if the button is hidden everywhere, which is the failure worth catching. Dropping the assertion
would leave the *Today* button with no smoke coverage at all. `grill.md` § *Settled* 9.

### No ADR is owed

`grill.md` § *Settled* 10. `CONTEXT.md` § *Offered* already carries the decision, the reasoning and
the chevron exception, including why #93's refusal stands and why this answer is different. An ADR
would restate a durable record in a second place that can drift. **ADR-1019 and ADR-1029 are used
rather than amended**: this is exactly the shell work the first's amendment allows, and exactly the
one-tap smoke assertion the second describes.

## Risks / Trade-offs

- **No scenario in this delta can tell a derived answer from a date comparison.** Every kind offers
  exactly one thing on a day that has arrived, so `offersAnything` written as
  `today.days(until: date) <= 0` passes all seven row scenarios. → The requirement says which
  sentence is normative, `tasks.md` § 3 says to derive it, and G7 is where an implementation that
  took the shortcut is caught. This is convention caught at review, which `AGENTS.md` § *Agent roles*
  says is where everything finer than three mechanical guards lives. It costs nothing while the four
  kinds all behave alike, and it costs a silently tappable row the first time one does not.
- **The shell reads its own clock per row while the screen holds a today it was handed.** Gating the
  row tap the same way inherits a skew that already exists across midnight. → Not closed here; see
  § *Open Questions* 1. Closing it means either exposing the screen's today or moving row answers onto
  the screen, and this grill rejected both on their own merits.
- **Hiding the *Today* button removes the only always-present control the smoke layer asserted.** →
  The walkthrough moves a day back first, so the assertion survives and gets stronger. If a later
  Story hides the button in a second situation, that test is where it will be felt, which is the
  right place.
- **A person on a future day now has rows they cannot tap and no message saying why.** → That is the
  answer the Feature grill gave B-035 deliberately, against the want's own words: the row still says
  what the day will ask of you, and a message on every row of every future day is noise. If it turns
  out to be wrong it is a new want, not a defect in this delta.

## Open Questions

**None outstanding, and one carried forward that is deliberately not this Story's — 1.** There was no
residual round: writing the delta turned up nothing the grill could not have reached, and the one
judgement it did turn up — the MODIFIED requirement above — is recorded as a decision in this
document rather than sent back, for the reason § *The chevron refusal is read against this* gives.

1. **The shell reads its own clock per row, and the screen does not.** `ContentView.swift:164` asks
   each row what it offers as of `today()`, a `Calendar.current` read (`ContentView.swift:59`–`:62`),
   while the screen holds a today it was handed at `init` and re-handed at `shown(asOf:)`. The two can
   disagree across midnight, and gating the row tap the same way inherits that. It predates this
   Story — all five existing row offers are already asked that way — and `grill.md` § *Left open*
   settles that it belongs in `docs/open-questions.md` as an **open technical decision**, not as a
   requirement this delta owes.

   **Writing that entry is a close-out act and not this branch's**, in the way
   `add-commitment-category` (#147) § *Left open* 5 reached `docs/open-questions.md` at its close-out:
   `docs/open-questions.md` is written by neither `spec-author` nor `implementer` (`AGENTS.md`
   § *Agent roles and model routing*), so no box in `tasks.md` can tick it. `tasks.md` § 5.5 leaves
   the text for whoever does.
