## Context

See `proposal.md` § *Why*, and `grill.md` for what was settled. The facts this design turns on:

- The mark is two seam members and nothing else: `LookBack.Line.rhythmChanged(inWords:from:)`,
  appended between two lines, and `LookBack.Graph.rules`, an array of
  `Rule(day:rhythmInWords:fromInWords:)`. No other member says anything about a boundary.
- `LookBack.walkDays` places the line: two key-to-last-day dictionaries, a private `Unit` key over
  a calendar month or a calendar week, and a pass over the eras choosing whichever of the two lines
  holding a boundary day is lower. The day walk, the tallies, the sort and the totals never read it.
- `LookBack.graph` forms `rules` in one short `map` over the eras after its own walk; its days, its
  points and its bounds do not read them.
- Ten tests touch the mark: nine named for the nine scenarios this delta removes, one named for no
  scenario — two boundaries inside one month, newest first, added at #272's G7 and reaching the
  placement directly — and one assertion inside the mixed-chain test the delta modifies.
- `LookBackView` draws a `.rhythmChanged` line as a dimmed caption between two `Divider`s, and a
  graph boundary as a dashed `RuleMark` plus a label in a second lane under the dates axis: the
  dates labels sit 14pt below the plot, the era labels 30pt, and the card's `.padding(.bottom, 48)`
  is sized for both lanes. Four of its doc comments describe the mark.
- The head is untouched, and so are the chain, the tallies, the whole and the graph's bounds.

## Goals / Non-Goals

**Goals:** a page whose months and weeks, and a graph whose trace, run unbroken across every
boundary; that silence written as a requirement rather than left as an absence; a diff that is a
deletion plus two tests.

**Non-Goals:** anything quieter in the mark's place, and any setting that keeps it reachable (grill
decisions 1 and 2); the head, the chain, the tallies, the whole and the graph's bounds; what a
total's and a note's page will draw (#275, #276); the `walkDays` split `docs/open-questions.md`
owes.

## Decisions

### The seam

```swift
case LookBack.Line.rhythmChanged(inWords: String, from: String)   // removed
public let LookBack.Graph.rules: [LookBack.Graph.Rule]            // removed
public struct LookBack.Graph.Rule: Hashable, Sendable             // removed
public let LookBack.Graph.Rule.day: Int                           // removed
public let LookBack.Graph.Rule.rhythmInWords: String              // removed
public let LookBack.Graph.Rule.fromInWords: String                // removed
```

No member is added and none changes shape: `LookBack.Line` keeps `.month` and `.week`,
`LookBack.Graph` keeps its days, months, points and bounds, and `CommitmentsScreen.lookBack(at:)`
keeps the signature it has. The two tests this Story writes attach there, as every look-back test
does.

### The silence is a rule, not an absence

Removing the two requirements would leave the spec saying nothing at all about a boundary, and
nothing a test could fail. So one requirement is ADDED saying a look-back says nothing there, and
the two tests named for its scenarios assert an exact list of lines across a boundary and an exact
graph across one. Rejected: a delta of REMOVED blocks alone, which leaves the absence provable only
by the type having no case for it — true the day it ships and re-addable the next day without a
delta.

### The placement goes with the mark

`walkDays` loses the two key-to-last-day dictionaries, the `Unit` key, the `WeekKey` that only that
key needed, and the pass over the eras that chose a target — three of the five jobs
`docs/open-questions.md` § *`LookBack.walkDays` does five jobs* counts. What is left is the day
walk, the nil-line filter, the sort by last counted day and the totals. The split that question
wants is still not done here: it is a refactor, this Story does not change how a look-back counts,
and `tasks.md` § 1 books anything outside the four files as a finding.

### What the graph card draws under its axis

The lower of the card's two label lanes held the era labels alone, so with them gone it is always
empty and `.padding(.bottom, 48)` draws as a blank band under the dates — the leftover the designer
found while drawing (`grill.md` § *What the fact agents found*). The padding drops to what the dates
lane alone needs, read off the walk's third picture rather than guessed. There is no
`### What the shell draws` section here: the layout round was asked and answered *no layout question
here*, so `grill.md` carries no `## Layout` and ADR-1057 wants none.

### Migration

None — nothing persisted changes shape or encoding. A look-back only reads, and nothing on a phone
holds anything about a boundary.

### The records

`CONTEXT.md` § *Look-back* and § *Graph* each take one dated amendment saying that nothing stands
between two eras now, and naming the sentences it replaces — the file's own convention, the way
§ *Look-back*'s 2026-09-16 amendment replaces the sentence before it, rather than an edit inside a
dated paragraph. No term is landed and none dropped: **era**, **chain**, **look-back** and **graph**
all stand as they are. No ADR moves: none states the mark, ADR-1055 names the boundary only as what
chaining was accepted against, and a decision one delta undoes is not at an ADR's bar.

## Risks / Trade-offs

- A reader who sees the counts shift with no word for it reads a defect — the designer's reasoning
  at #272, which is what the mark was for. → The owner read that shipped page and called the line
  clutter; the head says the newest era's rhythm and the earliest era's day kept from, and the mark
  is one delta away if the phone says otherwise.
- The dashed rules also held a chain's two stretches of points apart, and without them a chain reads
  as one series. → Which is what an unbroken trace is for (`CONTEXT.md` § *Graph*): the numbers
  either side are the same numbers whatever rhythm asked for them.
- The deletion reaches a function two open questions already watch, so a careless hand could take
  the sort or the newer-quota rule with it. → The quota requirement's eight scenarios and the
  graph-span requirement's four are carried in the delta whole, and their tests stand guard on
  exactly that.

## Open Questions

None. `grill.md` § *Left open* is "None." with its reason, and writing the delta turned up no
question whose answer would change it: the card's empty lane is a consequence of a settled decision,
recorded above as one. No residual round is outstanding.
