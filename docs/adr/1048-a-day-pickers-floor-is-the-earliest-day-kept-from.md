# 1048. A day picker's floor is the earliest day anything was kept from, clamped to the day being shown

- Status: accepted — the shape was the owner's at the Story grill of `add-day-picker` (#176) on
  2026-09-09; this record is written by `condense-day-screen-spec` (#201), the Story that deletes
  the prose which had been carrying the reasoning
- Date: 2026-09-10
- Deciders: Diego Bugmann
- Amended: 2026-09-10 — why the aggregate question belongs to the roster rather than to any
  commitment is added to the decision, by `condense-commitment-spec` (#204), which deletes the
  `commitment` requirement prose that carried it.

## Context

`add-day-picker` (#176) gave the day screen a control that reaches a day without stepping through
every day between, and bounded it. Its `design.md` § *No ADR is owed* judged that `CONTEXT.md`
§ *Reach* and § *Day picker* held the bound, the reason for it and the line between the control and
the screen, so a record here would restate a durable one in a second place that can drift.

Two things have changed since. `CONTEXT.md` says what a reach **is** — it is a definition, and it
carries the reason for the floor's *shape* rather than the argument for having one, for refusing
below it, or for never asking whether the picker is offered. Those lived in the requirement prose
and in an archived change folder, and this Story deletes the first; the second is not where a
reader looks, because `AGENTS.md` sends them to `docs/adr/`. Four of the rules below also have no
scenario, so with the prose gone the register would be the only place any of them is stated at all.

## Decision

**The floor is the earliest day anything on the roster has been kept from**, counting every
commitment the roster holds — the ones it has stopped keeping and the ones it has removed included
(ADR-1035). Their days still hold records that were kept, and a floor that rose when a commitment
was retired would put a day a person actually kept out of reach. Below that day nobody kept
anything, so a picker reaching further would offer a run of empty years.

**The roster answers it and the screen does not work it out.** A commitment reads back its name and
its kind and deliberately not the day it is kept from, so a screen computing the floor itself would
be reaching past a commitment for a part this domain does not hand out. The roster gives one
aggregate instead — where a person's history begins, and nothing about whose.

**The floor clamps to the day being shown.** Day navigation is unbounded, so a person can be
standing below the floor. A picker opening on a day it declared unreachable would be incoherent, and
one that could not take them back to where they were would be a trap; the clamp removes both, and
makes a floor above the day being shown unrepresentable rather than a case to describe. It is
asymmetric on purpose: pick a later day and the floor rises behind you, with the chevrons the way
back down. The alternative was a remembered low-water mark, which is state a screen would have to
carry across being shown.

**A pick below the floor is refused, and the screen is left exactly as it was.** Clamping would show
a day nobody asked for; silence is what the two ends of the calendar already answer with. This does
not put the seam at odds with `CONTEXT.md` § *Offered*, which lets a screen accept what it does not
draw as a target: the picker is not a control that stops being worth drawing, it is a control whose
extent has an end, and a day beyond that end is the same kind of thing as a day outside the
calendar. A bound the screen would not honour is not a bound.

**The picker is always offered, and nothing is answered about whether it is.** Forward it reaches to
the last supported date, so there is always another day to pick; a *whether it is offered* answer
would be yes on every day anyone will ever look at, which is the ground `add-screen-navigation`
(#93) refused `canShowPreviousDay` on and `add-offered-today-control` (#174) restated.

**Where there is nothing to take an earliest day from** — a roster that cannot be read, one written
by a later version, or a screen handed no commitments at a place holding nothing — the floor is the
today the screen was handed, and clamps from there like any other. A first launch is not one of
those cases: day one is written into the empty roster before the screen answers anything (ADR-1027),
so the reach is taken from the commitments just taken on.

**Why the roster owns the question, and not any commitment.** A commitment reads back the name it
was given and the kind its days take and nothing else — the day it is kept from is a part it is made
of, not a part it hands out — so one aggregate answer from the roster is the only way anything
outside `commitment` can learn where a person's history begins. That aggregate is the whole of what
is answered: which day, and nothing about whose commitment it came from. The question is therefore
about a roster rather than about the thing a screen is drawing, and is asked of the roster even where
a screen already holds every commitment it is showing.

## Consequences

- **The reach bounds the control and never the screen.** Day navigation, the swipe and the way back
  to today go on reaching as far as the calendar does; the requirement forbidding a stop at the
  earliest kept-from day is what this must never be read as narrowing, and it is stated there.
- **The floor can move under an open picker** — the roster is read again when the screen is returned
  to — but it only ever falls or clamps to the day being shown, so nothing a person is looking at
  becomes unreachable and no pick already made is invalidated.
- **The picker gives out the day being shown and never the today**, which is what keeps the way back
  to today underivable from it (ADR-1045, decision 12). Nothing mechanical stops a shell comparing
  the day being shown against a clock of its own; that is caught at review.
- **Four of these rules have no scenario** — the reach bounding only the picker, the three narrowings
  it must not make, saying nothing about being offered, and never giving out the today.
  `condense-day-screen-spec`'s `design.md` lists them as knowingly untested and one backlog want
  carries them.
- **`CONTEXT.md` § *Reach* and § *Day picker* stay the definition** and are untouched by this record,
  which is the reasoning behind them.
