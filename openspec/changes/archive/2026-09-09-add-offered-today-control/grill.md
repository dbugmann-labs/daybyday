# Grill — add-offered-today-control

*10 questions over 3 rounds, 2026-09-08.*

This Story is the **offered rule** made real on the day screen, over both of its halves at once —
the Today control and the row for a day that has not arrived. `CONTEXT.md` § *Offered* was landed
at the Feature grill that reopened `FEAT: day-screen` (#27) and settled that the two are one rule;
what this grill settled is where that rule lives in the code and what it does not touch.

## Settled

1. **The screen answers whether the Today control is offered**, rather than the shell working it
   out. *`DayScreen` exposes neither the today it was handed nor the day it is showing — both are
   `private` (`DayScreen.swift:24-25`) — so the shell has nothing to hide the button on. The
   alternative was making those two days public and comparing them in `ContentView`, which puts the
   offered judgement in a file no test reaches. `CONTEXT.md` § *Offered* already says what bounds
   the rule is what the screen holds the answer to, and gives a Today button on today as its
   example.*

2. **That answer is about the control, not about the position.** The screen says whether it offers
   the way back to today, phrased in the offered vocabulary — not whether it is showing its today.
   *The two days stay private, and the next control added anywhere gets the same shape instead of
   re-arguing it. The rejected alternative answers one fact rather than one per control, but makes
   the screen's internal today readable.*

3. **`showToday()` stays callable and unchanged when it is not offered.** The shipped requirement
   *A day screen goes straight back to the today it was handed* stands verbatim, including "a day
   screen already showing its today SHALL be left showing it… going back SHALL be an answer rather
   than a refusal" (`openspec/specs/day-screen/spec.md:1002`). *Offered governs what is drawn as a
   target, not what the seam accepts — the same split a tap on a row that offers nothing already
   has. Making it a refusal would reopen a requirement past G4 and give the screen a second way to
   say no that nothing on the screen could trigger.*

4. **A row is not a target exactly when it offers nothing**, rather than when its date has not
   arrived. *Identical in effect today — every kind offers exactly one of a tick, a number entry, a
   note entry or a total entry on an arrived day — so this is a choice of which sentence the
   requirement states. `CONTEXT.md`'s is "a screen draws as a target only what it offers", and it
   does not have to be reopened when a fifth kind lands.*

5. **That answer lives on the row, derived from the offers it already computes**, not as four `nil`
   checks in the shell. *There is no `offersTick` today: the four are optional-returning factories
   (`DayView.swift:62, 73, 106, 130`), each repeating the same `guard today.days(until: date) <= 0`.
   One derived answer is the "one rule over every row rather than four" the Feature grill settled.
   Left in the shell, a fifth kind added later silently makes its rows tappable again.*

6. **The row's answer is asked as of a day the caller supplies**, exactly like the five row offers
   before it. *Consistency with `tick(asOf:)`, `numberEntry(asOf:)`, `noteEntry(asOf:)`,
   `totalEntry(asOf:)` and `offersTakeBackLast(asOf:)`. The rejected alternative put it on
   `DayScreen`, which holds its own today — it would have closed the skew in item 3 of § Left open
   at the cost of duplicating a row answer on the screen.*

7. **The shipped requirement *A day screen tells nothing on a row where there was no tick to
   refuse* keeps its day-that-has-not-arrived case, unchanged.** *Item 3 leaves the seam callable,
   so a tap on a non-target row is still reachable behind the seam even though no UI can produce
   one. Deleting the case would leave a public seam call with no stated answer.*

8. **The shell wiring rides this branch.** Hiding the Today button (`ContentView.swift:126-132`,
   drawn unconditionally today) and ungating the row tap (`ContentView.swift:164-212`, every row a
   tappable `Button` regardless of offers) land on `story/174-add-offered-today-control` rather than
   a `chore/` one. *ADR-1019's 2026-09-04 amendment allows exactly this: shell work that exists only
   to make a Story usable. The want is about what a person sees, so a Story stopping at the seam
   leaves it unserved.*

9. **The walkthrough moves a day back before asserting the Today button.**
   `WalkthroughUITests.swift:26-28` asserts `app.buttons["Today"]` exists on a screen that opens on
   its today, so it goes red the moment the button is hidden. *One extra tap keeps ADR-1029's rule
   that the layer proves the shell drew rather than what it drew, and the assertion then also fails
   if the button is hidden everywhere. Dropping it would leave the Today button with no smoke
   coverage at all.*

10. **No ADR is owed.** *`CONTEXT.md` § *Offered* already carries the decision, the reasoning and
    the chevron exception — including why `add-screen-navigation` (#93) refused to let the screen
    say whether it can move either way (`openspec/specs/day-screen/spec.md:1061`) and why that
    refusal stands: that answer is the same on every day anyone will look at, and this one is not.
    An ADR would restate a durable record in a second place that can drift.*

## Terms landed in CONTEXT.md

None. **Offered** — the term both halves of this Story turn on — was landed at the Feature grill on
2026-09-08, product-wide rather than this screen's, and *target* is used inside that same paragraph.
This grill settled where an already-agreed rule lives in the code, and coined nothing.

## Left open

One, and it is deliberately not this Story's:

- **The shell reads its own clock per row.** `ContentView.swift:164` asks each row what it offers as
  of `today()`, a `Calendar.current` read (`ContentView.swift:59-62`), while the screen holds a today
  it was handed at `init` and re-handed on `shown(asOf:)`. The two can disagree across midnight, and
  gating the row tap the same way inherits that. It predates this Story — all five existing row
  offers are already asked that way — and closing it means either exposing the screen's today or
  moving row answers onto the screen, both of which this grill rejected on their own merits. **It
  belongs in `docs/open-questions.md` as an open technical decision, and is not a requirement this
  delta owes.**

Every other question the frontier raised was answered.
