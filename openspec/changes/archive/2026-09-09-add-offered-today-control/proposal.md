## Why

The day screen draws a *Today* button on the day it is already showing as today, and it draws every
row for a day that has not arrived as a tappable one. Both controls promise something that cannot
happen: the button has nowhere to route to, and the row has no record it can take — every kind's
entry has refused a future day since `add-total-record` (#141), so the tap opens nothing and keeps
nothing.

**B-028** is the first want — *"not be offered a way back to a day I am already on"* — and **B-035**
is the second — *"know that a commitment on a future day cannot be ticked yet"*. They are **one
Story because they are one rule**: the Feature grill that reopened `FEAT: day-screen` (#27) on
2026-09-08 landed **offered** in `CONTEXT.md`, product-wide rather than this screen's, and it says
in one sentence that *a control is offered when the screen can honour it, and a screen draws as a
target only what it offers*. Serving one want and not the other would leave the same sentence
half-true on the same screen.

The rule is landed and this Story is where it becomes a requirement. What the Story grill settled is
**where the answer lives**: on the screen for the button, on the row for the tap, and in neither case
in the shell.

## What Changes

- **A day screen says whether it offers the way back to today**, and offers it exactly when the day
  it is showing is not the today it was handed. The screen answers because the screen is the only
  thing that can: it gives out neither the today it was handed nor the day it is showing, so nothing
  outside it can compare the two. The answer is **about the control, not about the position** — it
  says the way back is offered, never that the screen is showing its today — so the next control
  added anywhere is asked its own question instead of inferring one from this answer.
- **A row says whether it offers anything at all**, asked as of a day the caller supplies, exactly
  as its five existing offers are. The answer is **read off those offers** — a tick, a number entry,
  a note entry or a total entry — and never worked out from the date. The two coincide today; the
  offers are the sentence `CONTEXT.md` § *Offered* actually carries, and a fifth kind added later
  cannot silently make its rows tappable again.
- **Going back to today is unchanged where it is not offered.** `showToday()` stays callable and
  goes on being an answer rather than a refusal. *Offered* governs what is drawn as a target, not
  what the seam accepts — the same split a tap on a row that offers nothing already has — and the
  shipped requirement *A day screen goes straight back to the today it was handed* is carried into
  this delta nowhere, because it does not move.
- **The shipped requirement B-035's backlog line expected to amend does not move either.**
  *A day screen tells nothing on a row where there was no tick to refuse* keeps its
  day-that-has-not-arrived case verbatim: the seam stays callable, so a tap on a non-target row is
  still reachable behind it even once no UI can produce one, and deleting the case would leave a
  public seam call with no stated answer.
- **One shipped requirement *is* modified, and only in prose.** *A move with nowhere to go leaves a
  day screen exactly as it was* refuses, in as many words, to say whether the screen can move either
  way. That refusal stands — the two ends are 1 January 1583 and 31 December 9999, so such an answer
  would be the same on every day anyone will look at — but a reader meeting it beside a screen that
  now answers about the *Today* control deserves the difference said rather than inferred. No `SHALL`
  moves and no scenario changes.
- **The shell rides this branch**, in its own `tasks.md` section, under ADR-1019's 2026-09-04
  exception: a button nobody can see hidden and a row nobody can stop tapping would leave both wants
  unserved. `ContentView.swift` draws the *Today* button only where the screen offers the way back,
  and draws a row as a `Button` only where the row offers something. It computes neither answer.
- **The UI smoke test moves a day back before it asserts the *Today* button.**
  `WalkthroughUITests.swift` asserts that button on a screen that opens on its today, so it goes red
  the moment the button is hidden. One extra tap keeps ADR-1029's rule that the layer proves the
  shell drew, and the assertion then also fails if the button is hidden everywhere.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `day-screen`: a day screen says whether it offers the way back to the today it was handed, and a
  row says whether it offers anything at all as of a day it is asked. **Two requirements are added
  and one is modified** — the modified one only in prose, to say why the refusal to report a move
  with nowhere to go is not a refusal to report this.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/DayScreen.swift` — one member, `offersGoingBackToToday`,
  answered from the two days the screen already holds. No stored state, no new type, no signature
  changed.
- `src/DayByDayKit/Sources/DayByDayKit/DayView.swift` — one member on `DayView.Row`,
  `offersAnything(asOf:)`, derived from the four offers it already computes. No stored state, no new
  type, no signature changed. **This is the change that keeps the four `nil` checks out of the
  shell**, where a fifth kind added later would have silently missed them.
- `src/DayByDay/DayByDay/ContentView.swift` — the *Today* button drawn conditionally, and a row
  drawn as a `Button` only where it offers something, under ADR-1019's exception. Both conditions
  are read off the kit and neither is computed here.
- `src/DayByDay/DayByDayUITests/WalkthroughUITests.swift` — one tap before the existing assertion,
  under ADR-1029: the layer still proves the shell drew and still says nothing about what it drew.
- `docs/adr/` — **nothing.** `CONTEXT.md` § *Offered* already carries the decision, the reasoning
  and the chevron exception, including why `add-screen-navigation` (#93) refused to let the screen
  say whether it can move either way and why that refusal stands. An ADR would restate a durable
  record in a second place that can drift.
- `CONTEXT.md` — **nothing.** **Offered** was landed at the Feature grill, product-wide, and
  *target* is used inside that same paragraph. This Story settled where an already-agreed rule lives
  in the code and coined nothing.
- **Not touched:** the `record`, `commitment` and `schedule` capabilities; `Commitment`, `Tick`,
  `History`, `RecordStore`, `Roster` and every record already kept; `showToday()`, `tick(_:)`,
  `enter(_:on:)` and `takeBackLast(on:)`, all of which go on accepting exactly what they accept
  today.
