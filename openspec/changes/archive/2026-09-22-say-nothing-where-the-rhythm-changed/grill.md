# Grill — say-nothing-where-the-rhythm-changed

*7 questions over 2 rounds, 2026-09-21 — four at the grooming pass that promoted B-056, three at
the Story grill. Two fact agents; no fact was sent to the owner.*

## Settled

1. **Remove, not hide.** The line between eras and the graph's rule leave as REMOVED
   requirements, with their scenarios; no setting keeps them reachable. *Nothing the owner said
   asks for a switch, and a setting is a control that needs a screen of its own.*
2. **Nothing stands between two eras.** The months and weeks run unbroken, and so does the
   graph's trace. No wordless mark, no gap. *The marker was landed at #272 on the designer's
   reasoning that a reader who sees the counts shift with no word for it sees a defect; the owner
   read the same page and called the line clutter. The head already says the newest era's rhythm
   and the earliest era's day kept from, and that stays the only place a rhythm is said.*
3. **This Story runs ahead of #275 and #276.** Both are now blocked by #300 on the tracker. *A
   deletion, the smallest Story #271 has had, and the total and note pages are then written
   against a spec that already lacks the marker rather than rebased over its removal.*
4. **The reason, for the record: clutter.** *It breaks the run of months and weeks, and the
   graph, for something the head already says.*
5. **Every era boundary goes unmarked, whatever ended the older era.** A rhythm change, an
   interval restart, a range or a target changed on the sheet: none draws a line or a rule.
   *Keeping the line for restarts alone would keep the whole requirement for one case.*
6. **The walk is three pictures.** A tick, a quota and a number look-back, each at a commitment
   with two eras: months and weeks running unbroken, and the graph's trace crossing the boundary
   with no rule. *The three kinds are the three screens the owner named; one line each.*
7. **No `phone:` line.** *A removal has no gesture, no paging and nothing to feel; the simulator
   pictures are the whole walk.*

## What the fact agents found, for spec-author

Facts, not decisions; they bound the delta rather than shape it.

- Two requirements carry the marker today: *A look-back says where the rhythm changed, between
  its lines* (six scenarios) and *A number commitment's graph says a rule where one era gives way
  to the next* (three scenarios). Nine scenarios, not eight.
- One shipped scenario under a *different* requirement names the line in its THEN — the one
  that lists a weekday era's months beside a quota era's weeks each in its own unit — so it is
  MODIFIED, not left alone.
- The tests: nine named for those scenarios, one extra test that is not a scenario (two rhythm
  changes inside one month, newest first, added on a G7 finding at #272 and reaching
  `changedLinesFor` directly), and one incidental assertion inside the own-unit scenario's test.
  Ten tests touch the marker.
- The head is unchanged: the newest era's rhythm in words and the earliest era's day kept from,
  already required and already shipped. A month two eras share is still one line whose fraction
  sums both; a week two quota eras share is still said once and judged by the newer. None of
  that moves.
- `CONTEXT.md` carries five sentences that describe the line or the rule, in the *Look-back*,
  *Era* and *Chain* prose; they are reworded, and no term is added or removed. No ADR mentions
  the marker itself; ADR-1055 mentions the era boundary only as the thing chaining was accepted
  against, and stands.
- Nothing in #275's or #276's intent, and nothing in the note-or-total requirement already in
  the spec, touches the marker.
- The layout round was asked and `designer` answered *no layout question here*: the shipped
  pages minus the marker, nothing in its place. One leftover it found while drawing, for
  `design.md` § *What the shell draws* rather than for a round: the graph card's bottom padding
  is sized for two label lanes, the dates and the era labels the rules fed; with the rules gone
  the lower lane is always empty, so the padding drops to what the dates lane alone needs, or
  walk picture three shows a blank band under the axis.

## Terms landed in CONTEXT.md

None. **Era**, **chain** and **look-back** stay as they are; the prose that mentions the line
between eras is spec-author's to reword.

## Left open

None. Every question the frontier raised was answered, and the two that could have been open
— whether a restart is a different event from a rhythm change, and whether anything quieter
should stand between eras — were both put to the owner and closed.
