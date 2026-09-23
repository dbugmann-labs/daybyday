# Grill — look-back-at-a-total

*15 questions over 4 rounds, 2026-09-23 — the fourth the layout round.*

Story #275, under `FEAT: look-back` (#271), `EPIC: Looking back` (#269). Intent: on a total
commitment's look-back page, draw each day's sum as a line with the target drawn across. Blocked by
#274 `look-back-at-a-number`, #300 `say-nothing-where-the-rhythm-changed` and #303
`give-a-commitment-an-identity`, all merged. #274 built the number's graph and #300 removed every
mark at an era boundary; the shipped requirement *A look-back at a commitment whose days take a note
or a total says no line* is the one this Story changes for the total half. What #274's `grill.md`
settled for a number's graph is what this one inherits unless a line below says otherwise.

One fact agent, no fact sent to the owner: a day whose last addition is taken back holds no record
at all, so no day can hold a sum of zero; each era carries its own target, so the target any day was
owed is recoverable; a day is kept where its sum reaches its target or more; the day screen refuses
an addition past thirty-eight significant digits, but the store reads a larger sum rather than
refusing it.

## Settled

1. **A day with no addition is no point, and the trace joins across it.** Exactly as a day with no
   number on #274's graph. *A drop to zero at every missed day is the gap-punishing mark ADR-1045
   forbids.*
2. **The target is drawn per era, stepping where it changed.** Each day is drawn against the target
   the era holding it declared — 120 until 3 March, 100 after. *A day is owed its own era's target;
   against the newest one, old days read as misses or overshoots of a target they were never set.
   The step is the target itself, not a boundary mark, so #300 stands: a boundary where only the
   rhythm changed draws nothing.*
3. **The graph is the page: no month lines and no whole.** Although a total's day can be kept. *The
   Feature as agreed at G1 — "a total's line with the target across" — and the rule already says
   which days reached it; the number page says no fraction either.*
4. **The values axis runs from zero to the greater of the highest sum and the highest target.** One
   axis for the whole graph, as on #274. *A sum is an amount, so its heights compare honestly from
   zero, and the target stays in view even over a stretch far below it.*
5. **Everything else about reading the graph is the number's.** The newest month in view on
   opening, a fixed scale that scrolls sideways, the picker of a month, three months, a year and
   all, nothing remembered between visits. *One way to read a graph on this page, whatever the
   kind.*
6. **A point that reached its target is marked kept; one that did not is not.** The owner's call
   against the recommendation, which was that the rule already says it. Kept is judged against the
   target of the era holding the point's day, and reaching it exactly is kept. How the mark looks
   is the layout round's.
7. **A total with nothing added yet draws its head and a sentence**, no graph and no rule, as the
   number page does. *An empty chart holding only a rule looks like something failed to load.*
8. **The sentence is "Nothing added yet."** *It names what a person does on the day screen, which
   is add; "no total" reads oddly for a sum.*
9. **The rule runs the whole dates axis**, from the day kept from through today or the day kept
   until, stretches with no point included. *Every day was owed the target whether anything was
   added or not, and the rule stays in view wherever the graph is scrolled.*
10. **A point is said as its sum of its day's target — "150 of 120".** The words the day screen's
    row uses, so kept or not is readable from the pair and the kept mark has a spoken equivalent.
11. **The walk shows four screens**: a month with days above, exactly at and below the target,
    kept marks and rule in view; a chain whose target changed, 120 then 100, with the step; the
    picker at "all", the whole run and the axis from zero; and a total with nothing added, the
    head and "Nothing added yet."
12. **No `phone:` line.** *The sideways scroll and the picker are #274's, already walked on the
    phone; nothing here is a new gesture.*
13. **The horizontal mark is the target rule.** *A line on this page is a row of text and the
    graph's path is its trace; "rule" has been free since #300 took the vertical era rule out.*
14. **The rule is labelled with its value** — the target at its newest end, and each earlier
    target where the rule steps. *Asked at the layout round, because the designer found that the
    axis says only zero and its top, so the one number the rule exists to show was never written;
    a finding about the grill, which should have asked it. Reading 120 off an axis from 0 to 150 is
    guesswork.*

## Terms landed in CONTEXT.md

- **Target rule** — new: the horizontal mark at the target each day was owed, across the whole
  dates axis, stepping with the era.
- **Look-back** — amended: what a total's page draws.
- **Graph** — amended: a total's graph, its points, the kept mark, its values axis.

## Layout

Option A, ringed when kept, chosen from three at https://claude.ai/artifact/9TodyrPaTtpnUGDSYmS8TY
— *a total's graph is the shipped number graph plus two things, the rule and the ring; the mark is
a shape rather than a colour or a size, so it reads as neither good-and-bad nor a score, and at All
the rings thicken into a band rather than a hedge or a blob. No riser where the target steps,
which keeps #300's rule without argument.* The rule's label, decision 14, was settled after the
drawing and is not in it. The wireframe follows, verbatim from the designer.

```
Option A — Ringed when kept   (recommended)

+------------------------------------------+
| <            Protein                     |  nav bar: back, and the name
| Protein                                  |  .largeTitle.bold
| Every day                                |  .subheadline, secondary
| +--------------------------------------+ |
| | KEPT FROM          1 September 2025  | |  dates card, unchanged
| +--------------------------------------+ |
| [ Month | 3 months |  Year  |   All   ]  |  picker, unchanged; Month on opening
| +--------------------------------------+ |
| | 150 |------------------------------- | |  gridline at the top bound, as shipped
| |     |  (•)     (•)                   | |
| |     |- -(•)- - - -•- -(•)           | |  target rule: dashed, secondary, the
| |     |   /  \ /  \/  \   \           | |  whole dates axis; 120 through 3 March
| |     |  •    •        \   (•)- - - - | |  then 100 from 4 March — the rule jumps,
| |     |                 •  /  \ (•)   | |  no vertical riser
| |     |                    •    •     | |
| |   0 |_______________________________| |  kept point: the shipped dot in the
| |      18 February 2026   10 March 2026 | |  label colour, ringed; not kept: the
| +--------------------------------------+ |  shipped dot, secondary, no ring
+------------------------------------------+  trace: secondary, joined across gaps
```

## Left open

None. Every question the frontier raised was answered. The tally-pass split that
`docs/open-questions.md` says #275 owes "if it reaches the function" is engineering, not a question
for the owner; whether this Story reaches it is `spec-author`'s to read and `design.md`'s to say.
The designer also read from the shipped code, unverified, that at All over several months the
dates axis's colliding month labels may leave only the newest standing; that is #274's graph and
not this Story's, and the walk's "all" picture is where it will show.
