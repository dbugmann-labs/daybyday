# Grill — look-back-at-a-number

*16 questions over 4 rounds, 2026-09-17 — the fourth the layout round.*

Story #274, under `FEAT: look-back` (#271), `EPIC: Looking back` (#269). Intent: on a number
commitment's look-back page, draw its numbers as a line over dates, everything since the day it
was kept from. Blocked by #272 `look-back-at-a-tick`, merged: the page, the seam
(`CommitmentsScreen.lookBack(at:)`, `LookBack`, `LookBack.Line`), the chain of eras, the
rhythm-change line and the whole all exist, and the shipped requirement *A look-back at a
commitment whose days take a number, a note or a total says no line* is the one this Story
modifies. #273 `look-back-at-a-quota` is merged too. #275 `look-back-at-a-total` is blocked
behind this Story because it draws the same thing with a target across; what is settled here is
what it inherits.

## Settled

1. **The drawn thing is a graph.** The look-back spec already uses *line* for a text row — a
   month line, a week line, the rhythm-changed line — so the delta says **graph** for what a
   number's page draws, and **point** for one day's number on it. *The owner's own word: Epic #1
   excluded "graphs" by name, and Epic #269 exists to allow them.*
2. **Days with no number are joined across.** One unbroken graph through the days that hold a
   number, a point on each; a single number is one point; no number at all draws no graph, and
   the page stays as it is today. *A number stands only on a due day, so a gap is a day the
   rhythm did not name or a due day nothing was entered on, and nothing tells them apart; a break
   at every gap is the gap-punishing mark ADR-1045 forbids, and a weight logged three times a
   week is still one trend.*
3. **The dates axis runs from the earliest era's day kept from through today, or through the
   day kept until where the roster has stopped keeping the commitment.** The same span the tick
   page counts over, whatever days hold a number: a late start or a lapse is visible as empty
   rather than hidden. A number on a day after the day kept until can exist and is not drawn;
   one before the day kept from cannot exist. *Same rule as every other page; a span that fits
   the numbers would make a one-number page one day wide.*
4. **The values axis spans the range where the newest era declares one, and fits the numbers
   drawn where it declares none.** A mood of 7 on a range of 1–10 is drawn as 7 of 10, and a flat
   week reads flat. Where a number drawn falls outside that range — an older era's, once #262
   lets a range change — the axis widens to hold it. *Fitting the numbers turns 6, 7, 7, 6 into a
   mountain range and puts a 40–150 weight on a flat line at the top.*
5. **No figure beside the graph.** No whole, no latest number, no lowest or highest: the graph is
   the page. A number's page keeps saying no whole. *A kept-out-of-due fraction answers the tick
   page's question, the latest number is the day screen's, and thin first — a figure is a want
   for later.*
6. **A fixed scale that scrolls sideways, with a picker of spans.** The owner departed from the
   recommendation, which was the whole span fitted into the width: a daily weight over two years
   would blur seven hundred points into one trend and lose the days. The graph keeps a fixed
   number of days in the width and scrolls sideways within it; a **picker** offers the spans, and
   sideways scrolling stays possible under every span. *Pinch-to-zoom was declined at the
   follow-up: a picker does most of the job, a simulator can tap it, and a pinch would be a
   phone line in every walk that touches the graph.*
7. **The picker offers a month, three months, a year and all.** Each is how many days fit in the
   width; "all" is the whole span of decision 3 in the width, the trend at a glance. *Four steps,
   each about three times the last.* Exactly how many days a month or a year is here is
   `design.md`'s.
8. **On opening, the newest month is in view.** Scrolled to the newest end, about a month of days
   in the width, ending today or the day kept until; where the whole span is shorter than that,
   the whole span. Nothing is remembered between visits: each opening starts the same. *The
   recent days are what a person opened the page for; the trend is one tap away.*
9. **One values axis for the whole graph, not for the days in view.** Where the axis fits the
   numbers (4), it fits every number on the graph, so the graph does not jump as it scrolls and
   a month reads against the whole. *The same point at two heights in two views is a graph that
   reshapes under the thumb.*
10. **An era boundary is a vertical rule on the graph, labelled as the rhythm-changed line is.**
    One rule at each boundary, at the newer era's day kept from, saying that era's rhythm in words
    and its day — what the tick page's rhythm-changed line says, composed the same way. The graph
    stays one unbroken trace across it. *A person who changed from daily to three-a-week should
    see where, not only that the points thinned.*
11. **A number's chain runs across a range change.** Story #262 will make changing a range
    supersede, as changing a rhythm does; the chain reads eras by resemblance on "the same kind",
    and equality on the kind compares the range, so without this the page would begin at the
    change. For a commitment whose days take a number, the resemblance rule ignores the range the
    kind carries: same name, the number kind whatever its range, day kept until the day before.
    One MODIFIED requirement in `look-back`; nothing in `commitment` and nothing in #262 moves.
    The roster already holds two number commitments differing only by range, so the scenario is
    constructible at the seam today. *Mood narrowed from 1–10 to 1–5 is still one graph to the
    person who narrowed it.* Whether a total's chain ignores its target is #275's question.

    *Found stale by `spec-author`, 2026-09-17.* #262 `change-range-and-target` merged as
    `d281584` after this worktree was cut and before this question was asked, and its delta
    already reads eras by "the same name and a kind of the same sort — a number behind a number,
    a total behind a total, whatever it carries", total included, with `LookBack.chain` calling
    `Kind.isOfTheSameSort(as:)`. The answer above stands and is shipped; the MODIFIED requirement
    it asked for is not in this delta, because as written it would have reverted #262's wording
    at archive. The behaviour is covered by the scenario that chains two eras of different
    ranges under one graph. **A finding about this grill:** the fact agent read the spec at the
    cut and nobody re-fetched before the round; a `git fetch` and a read of `origin/main`'s spec
    would have caught it. ADR-1055 still says "the same kind" where the shipped spec says "a kind
    of the same sort" — #262 left it so, and that is a known gap in `docs/open-questions.md`, not
    this Story's.
12. **The rule at a range-only boundary says what every rule says: rhythm and day.** After #262,
    a range change with the rhythm unchanged reads "Every day · 4 March 2026" at the rule — that
    something changed, not what. One label shape for one kind of mark; the range is said nowhere
    on the page and the values axis already shows it. *Two label shapes for one mark, and the
    range in words on the page for the first time, was the alternative.*
13. **The walk — five pictures, one `phone:` line.** There is no seed for number days, so the walk
    types each number into the day screen's entry, one past day at a time; about ten entries buy
    one picture. W1 the day-one *Weight* commitment with about ten numbers over three weeks, as
    the page opens — the newest month, light. W2 the same in the dark appearance. W3 the same
    after picking "all". W4 a number commitment whose rhythm was changed through the edit sheet,
    showing the rule at the boundary. W5 a number commitment with no number yet — the head and
    no graph. `phone:` scroll the graph sideways under a month span. *Sideways scrolling is a drag
    no simulator proves; every other step is a tap or a push.*
14. **The layout round** — § *Layout* below, appended after the rest of this file was written:
    Option A, and the empty page's sentence.

**Consequences the facts settle, not asked because no preference is involved.**

- A number is kept exactly where it holds a number — `record`'s *kept* requirement — and a
  number stands only on a due day on or after the day kept from. The graph therefore marks
  nothing about kept or missed: a point is a day with a number, and there is no third state.
- The head is unchanged: the newest era's rhythm in words, the earliest era's day kept from,
  and kept-until where the roster has stopped keeping the commitment. A note's and a total's
  pages still say no line, no graph and no whole (#276, #275): the shipped requirement narrows
  to those two kinds.
- No requirement anywhere says how a number's value is said in words; the day screen reads one
  and never writes one, and the record keeps numbers digit for digit. The values axis needs
  numbers said, and the delta fixes how — this package's own English, no locale, as the months
  and days are fixed — so that it is testable; the exact form is `design.md`'s and the delta's.
  The dates axis says its dates under the shipped formatting requirement, and a week-scale label,
  if the designer draws one, is the one place a month is short (#273).
- Everything public on `LookBack` is a string today. A graph needs the points as values the
  shell can plot — a day and a number each — plus the span and the axis bounds; the seam's shape
  is `design.md`'s. The scale, the picker and the sideways scroll are the shell's drawing state
  and cross no seam: the seam answers the points, the span, the bounds and the rules, tests
  attach there, and the walk pictures show the scale and the picker. A scenario no seam can
  drive is a walk line, not a test.
- The rule of decision 10 stands at the newer era's day kept from; where a boundary's two eras
  are both numbers, the point on the older era's last day and the point on the newer era's first
  day are joined like any two points (2).
- Today is the one the commitments screen is already handed (`CommitmentsScreen(asOf:)`), never
  a clock read in the kit (ADR-1004). Nothing is persisted, so no `### Migration`; ADR-1047's
  budgets apply. No `commitment` delta: #262 is in flight on that capability and the ninth pass
  made one on this Feature's Stories a stop at G4.
- Two debts named in `docs/open-questions.md` land on the next Story here, and this is it.
  *`LookBack.walkDays` does five jobs* is owed by the next Story that changes how a look-back
  counts, "#274 or #275 if either reaches this function"; a graph reads numbers over the span
  rather than counting, so whether this Story reaches `walkDays` is `design.md`'s call, and if it
  does the split is a `tasks.md` box, not a fix-round afterthought. *`look-back-at-a-quota`'s
  wireframe says "nav bar: back only"* is corrected by the next Story that touches the
  look-back's `design.md` — this one; the shipped page says the name in the bar and in the body.
- Swift Charts is available to the shell (the app target is iOS 26, the kit iOS 17) and nothing
  in the repo imports it yet. Whether the shell draws the graph with it or by hand is
  `design.md`'s; the kit stays SwiftUI-free either way.

**ADR.** Decision 11 amends ADR-1055, *a look-back reads eras by resemblance*: its resemblance
rule compares the kind whole, and its named prices do not list the range change its own first
paragraph says supersedes. `spec-author` amends that ADR's text rather than writing a new one.
ADR-1045 says charting a *run of days* is what *nothing congratulates you* forbids; a graph of
numbers charts values, not a run, and a sentence saying so belongs where that ADR is read, if
anywhere. Nothing else looks owed: 6 to 9 are shell layout, cheap to reverse, and the mockup
records them.

## Terms landed in CONTEXT.md

**The conductor named these; `spec-author` lands them.** One new term, two amendments.

- **Graph** — new. What a number's look-back page draws: one unbroken trace through its
  **points**, a point for each day that holds a number, over a dates axis running from the day
  kept from through today or the day kept until, at a fixed scale that scrolls sideways, with a
  picker of spans. Deliberately not a *line*, which on this page is a text row. Nothing on it
  marks a missed day: a gap is joined across, because a graph that breaks at the first gap is
  the wall of squares ADR-1045 forbids.
- **Look-back** — amended. A number's page draws its graph, no whole and no figure beside it;
  the newest month is in view on opening; an era boundary is a rule on the graph saying what the
  rhythm-changed line says. Replaces "a number's page draws its numbers as a line over dates".
- **Era** — amended. A changed range ends an era too, once #262 lands, and a number's chain runs
  across it: resemblance for the number kind ignores the range it carries.

## Left open

None. Every question the frontier raised was answered; the owner departed from the
recommendation once (6, the fixed scale) and that departure raised four questions of its own
(6's follow-up on how zoom is offered, 7, 8 and 9), which were asked and answered. Every other
edge the facts turned up is a consequence of a decision already made rather than a preference,
and is listed above so `spec-author` does not re-decide it. The layout is § *Layout* below,
appended after this section was written.

## Layout

**Option A**, one graph card with the picker above it, chosen from three at
https://claude.ai/artifact/GiwXkKSq5686jPyfLcVr6b — *it is the shipped page with one new object
on it, a card of the dates card's own fill and radius, and it is the only option that shows all
four spans at once; the span is the page's one control, and decision 6 chose the fixed scale so
that a person moves between spans.* One more answer from the same round, shell wording and no
requirement:

- **The empty page says "No number yet."** A number commitment with no number draws the head and
  that sentence in place of the shell's "Nothing is counted here yet.", which was written for a
  page of fractions; the tick and quota pages keep theirs. One shell string, a `tasks.md` box
  under the shell section.

Three things the designer turned up while drawing, handed to `spec-author` and none a decision of
this round:

- **The dates axis needs no new words.** At the month and three-month spans it says a day in the
  shipped day form, "24 August 2026", about three across the width; at the year and all spans it
  says the shipped month form, "February 2026". Both are requirements already, so the axis invents
  no string and the week's short month names are not needed — worth a `design.md` line.
- **An era label does not always fit beside its rule.** The composition is fixed (decision 10), so
  Option A slides the label along its lane under the dates axis, left-aligned to its rule. Two
  boundaries a few days apart collide in every option; they overlap and the older wins the lane.
  A `design.md` line, not a layout choice.
- **The trace is drawn in the label colour, not the accent.** The accent says *this is a control*
  everywhere else in the app, and no colour on this page may say good or bad (ADR-1045).

The mockup's example figures are examples: every number on a graph, the values-axis ticks, and the
span names "Month / 3 months / Year / All" — decision 7 settled the four spans, not their words.
Every wireframe says the nav bar carries back and the name, as the shipped page does; this corrects
#273's "nav bar: back only" line (`docs/open-questions.md`).

The wireframe follows, verbatim from the designer.

```
Option A — one graph card, the picker above it, an era label lane under the dates

+------------------------------------------+
| <            Weight                      |  nav bar: back, and the name
|                                          |
| Weight                                   |  .largeTitle.bold      name
| Mon, Wed, Sat                            |  .subheadline, dimmed  rhythmInWords
|                                          |
| +--------------------------------------+ |
| | KEPT FROM           1 January 2026   | |  dates card, unchanged; a KEPT UNTIL
| +--------------------------------------+ |  row below it only where stopped
|                                          |
| [ Month | 3 months |  Year  |   All   ]  |  segmented picker, full width, above the
|                                          |  card; "Month" selected on opening
| +--------------------------------------+ |
| | 150 |. . . . . . . . . . . . . . . . | |  graph card: the dates card's fill and
| |     |                :               | |  radius. Values axis pinned in a lane at
| | 120 |. . . . . . . . : . . . . . . . | |  the left; it does not scroll, and it is
| |     |                :               | |  the whole graph's axis, not the days in
| |  80 |-•-•-_          :               | |  view (grill 9)
| |     |      `•-•-_  • :               | |
| |     |            `•-•: •--•   •--•   | |  the trace: one point per day holding a
| |  40 |________________:_______________| |  number, joined across the days between
| |      24 August 2026  :  14 September | |
| |                      :        2026   | |  dates axis, scrolls with the plot
| |       Mon, Wed, Sat · 9 September 2026 | |
| +--------------------------------------+ |  era label lane, under the dates,
|                                          |  left-aligned to its rule, scrolling
+------------------------------------------+  with it

the plot scrolls sideways under the thumb; on opening it sits at the newest end, so
the trace runs off the left edge and stops flush at the right. No whole, no figure.
```
