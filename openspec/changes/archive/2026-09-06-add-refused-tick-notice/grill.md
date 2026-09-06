# Grill — add-refused-tick-notice

*10 questions over 3 rounds, 2026-09-06.*

The Feature grill at the fourth grooming pass had already settled the shape of this: a refused
tick is told **on the row that was tapped, under its name**, it lasts **until the app is shown
again or a tick on any row is kept**, and **every refused tick is told the same way** — no cause
named apart, on ADR-1021's reasoning. `CONTEXT.md` § *Day screen* carries that, and `docs/backlog.md`
records it against B-027. This grill settled only the edges that were invisible until someone tried
to phrase the requirement.

## Settled

1. **A day move clears the notice.** Moving to the day before, the day after, or straight back to
   today ends it. *The notice is about a tap on a row of the day you were on; a day you have left
   has no row to say it under, and carrying it forward would put a message under a commitment that
   refused nothing. This is a third end to the lifetime, and it is the cost of the answer.*
2. **A move with nowhere to go leaves it standing.** On the first supported date, on the last, or
   going back to today while already on today. *"A move with nowhere to go leaves a day screen
   exactly as it was" is already a requirement and the notice is part of how it was — the person
   has not left the day they tapped on, so it is still true. The clearing rule is therefore about
   the day being shown changing, not about the gesture.*
3. **At most one notice on a screen, on the row tapped last.** A second refused tap moves it rather
   than adding to it. *One refusal is one event; two notices say the same thing twice, and the
   second tap is the one the person is waiting on an answer for.*
4. **Any change that reaches the place clears it, not only a tick made.** A take-back that lands
   ends it exactly as a tick that lands does. *`CONTEXT.md` said "a tick on any row is kept"; the
   notice means the place would not take your change, and a take-back landing is as much proof to
   the contrary. One rule rather than two.*
5. **A screen that is not keeping a record says nothing on the row.** A tap there produces no
   notice; the screen's own statement that it is keeping no record stands alone. *It already says
   more than a per-row notice would, the two would share a lifetime and clear together, and
   ADR-1021 already accepted that taps on such a screen are silent.*
6. **A tap on a row for a day that has not arrived says nothing.** *Such a row offers no tick, so
   there is no tick to refuse; the notice means a change did not reach the place, and here there
   was no change. The honest answer to a future day is a row that does not invite the tap, which is
   B-028's territory and not this Story's.*
7. **A tick that could not be kept is still refused to the caller, and the notice is added
   alongside.** *They serve different readers: the notice is what a person sees, the refusal
   reaching the caller is what a test asserts on and what stops a future shell swallowing a failure
   again — which is the bug this Story exists to close (`docs/open-questions.md`, "The shell
   swallows the one failure a tick reports"). Dropping it would trade one silence for another.*
8. **The notice does not say which of make or take-back failed.** One notice for both. *The same
   test ADR-1021 applied to a record that would not open: two messages earn their keep only where a
   person can act on them differently, and here the answer to both is that the row shows what is at
   the place and the tap did not land.*
9. **What a screen says about keeping a record does not change when a write fails.** A screen that
   opened its record still says it is keeping one. *That answer is about whether the store opened at
   its place and is formed again only when the app is shown; a refused write is one change refused,
   not a store that will not open. Keeping them apart means the screen never guesses which condition
   a failed write proves.*
10. **Row identity is inherited, not fixed here.** Two rows of one day view may be equal
    (`docs/open-questions.md`, "The shell identifies rows by equality"), and where they are, the
    notice shows under both. *Two equal rows means two commitments identical in name, schedule and
    kept-from — nothing has asked for that, and giving a row an identity changes what a row is,
    the shell's list and several requirements. A Story of its own, not a rider on this one.*

Two things the existing spec already answers, recorded so nobody re-opens them: a row the screen's
day view does not hold "SHALL change nothing at all", so a stale row raises no notice; and being
shown again ends the notice whether or not the record can then be read, because being shown re-forms
what the screen says from what is at the place.

## Terms landed in CONTEXT.md

No new term. § *Day screen* was **amended** — the notice's lifetime now has three ends rather than
two (the day being shown changing is the third), it is at most one per screen, it is cleared by any
change that reaches the place rather than by a tick alone, and it is silent where there was no tick
to refuse. The amendment rule in `docs/adr/README.md` applies: the decision is edited into the entry
that holds it rather than given a new one.

No ADR. Nothing here was hard to reverse or surprising on its own — every answer is ADR-1021's
reasoning applied one step further, and the entry in `CONTEXT.md` is where a future reader will look.

## Left open

None. Every question the frontier raised was answered. Three things were found next to it and
deliberately left outside this change, all already on the record:

- **Two equal rows share a notice** — settled item 10, inherited from
  `docs/open-questions.md`'s row-identity gap.
- **Nothing automated proves the shell draws the notice** — `docs/open-questions.md`, *No UI smoke
  layer*. The notice must therefore be a fact on the day screen at the kit seam if it is to be
  tested at all.
- **`RecordStore.write` lets an encoding failure escape unwrapped** (`try encoder.encode` sits
  outside its `do`), so a refusal can arrive as something other than `RecordStoreError`. It does not
  change this delta — the notice follows any refusal — but it is worth an entry in
  `docs/open-questions.md` and is not this Story's to fix.
