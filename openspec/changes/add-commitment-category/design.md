## Context

See `proposal.md` § *Why*, and `grill.md`, whose twenty-five settled answers this delta is written on.
**Settled answer 24 reversed settled answer 14's seam rule on the phone, on 2026-09-08**, and the
sections it moved are § *The offset a screen takes is over the group it was dropped in*, § *What the
mark was for, and what draws it now* and § *The shell rides this Story*; § *Open Questions* 1 records
the reversal beside the answer it replaced.
What matters here is that a **category** is a word the person chose, held by the roster against a
commitment, and that **grouping is a second reading of the order the roster already holds**. Once
those two are fixed everything else follows: the commitment gains nothing, the day view gains no
rule about arrangement, and the one grouping rule in the product lives in one place that both
screens read.

Seven facts read off this worktree at `19fb199`, 2026-09-08. The first five were measured for this
document; the last two decide how big the change is and are the ones to re-check before starting.

- **The commitment is untouched, and that is the point.** `Commitment.swift` and
  `CommitmentCoding.swift` hold four parts and a kind's payload; nothing in this change opens
  either. `Roster.Entry` already holds two things beside the commitment — `keptUntil` and
  `isRemoved` — so a third is a field on a struct that exists for exactly this purpose.
- **The roster file needs a form bump and cannot avoid one.** `RosterDocument.currentVersion` is
  `3` and `RosterEntryRecord` has `commitment`, `keptUntil` and `removed`. A category has to be
  written, so unlike `add-roster-order` this change cannot ride the existing form.
- **An explicit `null` is distinguishable from an absent key, and that is what the shape guard
  needs.** Measured by compiling and running a probe, 2026-09-08: a hand-written `encode(to:)`
  calling `container.encode(optional, forKey:)` writes `{"category":null,…}` for `nil`, and on the
  way back `container.contains(.category)` answers `true` for an explicit `null` and `false` for an
  absent key. So "this commitment is under no category" and "this form has no categories in it" are
  two different bytes, which is what lets `RosterStore.init(at:)` check the whole document's shape
  against its declared version exactly as it already does for `removed`.
- **`DayView` is formed from `[Commitment]` and holds `rows`; `DayScreen` hands it
  `roster.commitments(on:)` at three call sites.** `DayView.swift:42`, `:51`, `:61` and
  `DayScreen.swift:76`, `:209`, `:217`. Nothing between the roster and the rows reorders anything
  today, which is why handing groups down that path costs one type and no rule.
- **`CommitmentsView.swift` draws the kept list as one flat `ForEach` inside `Section("Kept")` with
  `.onMove` attached**, and `screen.kept[index]` resolves the dragged row. That arrangement is what
  the 2026-09-08 walkthrough found wanting, and § *The shell rides this Story* replaces it with a
  `Section` per group.
- **`onMove(perform:)` is declared on `DynamicViewContent`** — read out of `iPhoneOS26.5.sdk`'s
  `SwiftUI.swiftinterface`, 2026-09-08, at line 10353 — and takes `Optional<(IndexSet, Int) -> Void>`.
  Its `IndexSet` and its `Int` are both over the `ForEach`'s **own** data, and no overload names two
  collections, so **a `Section` per group means every offset `.onMove` hands the shell is already
  counted inside one group.** That is the fact the new seam is shaped to, and it is also why
  § *Questions for you* 1 exists.
- **580 tests pass**, `swift test` from `src/DayByDayKit`, this branch cut from `main` at `f8236be`
  which includes `add-roster-order` (#161).
- **`pnpm run check:scenarios` reports `129/206 scenario(s) covered`** for this change. Those 129
  are the scenarios this delta carries verbatim from the current specs; **no test behind any of them
  may be renamed, moved, or have an assertion changed.** Seventy-seven are new.

`CONTEXT.md` fixes the vocabulary — the new **category**, and the amendments to **roster**, **roster
store**, **commitments screen**, **day view** and **move** — and the grill landed all of it before
this folder existed. Two lines of it are corrected here; § *The day view is handed its groups, and
`CONTEXT.md` is corrected* says which and why, and the second correction is the drag-mark paragraph
settled answer 21 landed, which settled answer 24 has since made false. Writing the delta turned up
no new headword.

## Goals / Non-Goals

**Goals:**

- A word a person types, held against a commitment, changeable as often as they like, that re-keys
  nothing already recorded.
- **One** grouping rule, in one place, that both screens read — so the two can never disagree about
  where a group sits.
- A day view that still orders nothing of its own. Grouping is handed to it, so the requirement
  that has held since `add-day-view` (#70) is left untouched.
- A drag that does what it looks like it does: dropping a row under another heading files it there.
- A roster file that moves forward one form and reads all three behind it, with no migration pass
  and nothing asked of the person.

**Non-Goals:**

- More than one category per commitment, nested categories, and a category on anything but a
  commitment. Settled answers 2 and 4.
- A list of categories held anywhere: no create, no delete, no rename-everywhere. Settled answers 7
  and 8. Renaming a word across five commitments is retyping it five times, and if that bites it is
  a want.
- Grouping the stopped list, and grouping or filing anything from the day screen. Settled answers 13
  and 16.
- Any order the app works out — alphabetical groups, groups by size, uncategorised first. Every
  argument the roster has ever made against inventing an order still stands.
- Any change to `record`, `History`, `Tick`, `RecordStore`, `RecordDocument`, `Commitment`,
  `CommitmentRecord` or `schedule`.

## Decisions

### The seam

**No new file and no new capability.** Five existing seams gain members, and two small nested value
types are added beside them. Every scenario in the delta is driven at one of these:

- **`Roster.Group`** — `public let category: String?` and `public let commitments: [Commitment]`.
  A `nil` category is the group of the commitments under none, which is always last where it
  exists.
- **`Roster.groups: [Group]`** and **`Roster.groups(on date: CalendarDate) -> [Group]`** — the whole
  of the grouping rule, and where every scenario under *A roster reads the commitments it is keeping
  in groups* is driven. `Roster.commitments` and `Roster.commitments(on:)` are untouched and go on
  answering flat, in the roster's own order.
- **`Roster.put(_ commitment: Commitment, under category: String?) -> Bool`** — the fifth act.
  `Roster.Entry` gains `category: String?`.
- **`Roster.add(_ commitment: Commitment, under category: String?) -> Bool`**, beside the existing
  **`Roster.add(_ commitment: Commitment) -> Bool`** — the two forms of the offer, § *A commitment
  is offered with a category or without one*.
- **`Roster.move(_ commitment: Commitment, toOffset offset: Int, under category: String?) -> Bool`**
  — replacing the two-argument form outright rather than defaulting it. A default of `nil` would
  read as "leave the category alone" and mean "take it off", which is the one way this seam could be
  silently wrong.
- **`RosterStore.put(_:under:) throws -> Bool`**, **`RosterStore.add(_:under:) throws -> Bool`** and
  **`RosterStore.move(_:toOffset:under:) throws -> Bool`** — the same shapes as `remove`, writing
  before they report, and reporting what the roster reports.
- **`CommitmentsScreen.keptGroups: [Roster.Group]`** and **`CommitmentsScreen.categoriesInUse:
  [String]`** — what the screen draws and what its form offers. **`kept` stays**, and is the entries
  read across the groups, in the order they are drawn. That is what keeps every carried scenario
  saying "what it keeps is three entries" true, and it is the list the move's offset is counted
  over.
- **`CommitmentsScreen.put(_ commitment: Commitment, under category: String?) -> Refusal?`** — the
  same shape as `keepAgain`. `RefusedChange` gains a sixth case, `categorising(Commitment, Refusal)`.
- **`CommitmentsScreen.define(name:on:keptFrom:under:)`** — a fourth argument, no default. The form
  always has a category field, so it always has something to say.
- **`CommitmentsScreen.move(_ commitment: Commitment, toOffset offset: Int, under category: String?)
  -> Refusal?`** — replacing the two-argument form outright rather than defaulting it, for the reason
  `Roster.move` gives one line above, and **the offset is counted over the entries drawn in the group
  named by `category`**, not over `kept`. Every existing caller and every carried test gains the
  third argument; because every carried scenario describes a roster with nothing under a category,
  the group they mean is the one under none and `nil` is what they pass. This is the signature
  settled answer 24 reversed, and § *The offset a screen takes is over the group it was dropped in*
  is the whole of it.
- **`DayView.Group`** — `public let category: String?` and `public let rows: [Row]`.
  **`DayView.groups: [Group]`**, and **`DayView.rows`** stays as every row read across the groups,
  in drawing order.
- **`DayView.init(of groups: [Roster.Group], on:in:)`**, beside the existing
  **`DayView.init(of commitments: [Commitment], on:in:)`** which means one group under no category;
  and the same pair for **`previousDay`** and **`nextDay`**. The commitment-taking form is what
  keeps the day-screen suite's existing tests unchanged, and it is honest rather than a shim: a
  caller with nothing to say about categories says nothing.

### Where the grouping is worked out, and why not in the day view

**The roster answers in groups, and both screens draw what they are handed.** This is the decision
the whole change turns on, and the alternative — a flat list of commitments-with-categories handed
over, grouped by whoever draws it — loses on two counts.

First, **the day view would have to invent an arrangement.** `day-screen/spec.md:410` has said since
`add-day-view` (#70) that *"A day view's rows SHALL appear in the order its commitments were handed
to it… The day view SHALL NOT impose an order of its own"*, and ADR-1037 leaned on exactly that
sentence when it put the order in the roster rather than on a screen. Grouping in the day view would
be the first order it ever made. Handing the groups in leaves that requirement **untouched by this
change** — it is not carried in the `day-screen` delta at all, because nothing in it becomes false.

Second, **two screens would hold the same rule.** The commitments screen and the day view must place
groups identically or a person reads two different arrangements of one roster; two implementations
of "a group sits where its first commitment sits, and the uncategorised come last" is precisely the
"nothing has to keep two orders in step" that ADR-1037 bought and this would sell back.

So `Roster.groups` is the rule, and the day view's own contribution is one thing that genuinely
belongs to it: **a group with nothing due on the date is not drawn**, because that is a statement
about what a date asks of you rather than about what a person keeps.

**The roster is not inventing an arrangement by doing this.** It reads its one order a second way,
from the categories it already holds. It sorts nothing, and the only rule that is not "walk the
order" — the uncategorised group last — is the one arrangement that leaves a roster nobody has
categorised looking exactly as it looked before categories existed.

### A category is the roster's, and ADR-1038

Settled answer 4, taken at the fifth grooming pass and not re-opened at this grill: the category is
held on the roster's entry, not as a fifth part of the commitment. **ADR-1038** is written, and it is in the diff
this gate signs rather than owed to the implementation, because `docs/adr/**` is `spec-author`'s to
write (`AGENTS.md` § *Agent roles*) and because a reader who meets ADR-1030 will otherwise infer the
opposite. `tasks.md` § 10 confirms it rather than writing it.

ADR-1023 refused *kept until* a place on the commitment because a tick embeds the whole commitment
by value, so a part a person changes orphans every tick already recorded. ADR-1030 then let the
**kind** be a fourth part on exactly one ground: a kind never changes, and changing it is what
changing a commitment is. **A category is the opposite of a kind on that one axis** — it is a label
a person is expected to move — so ADR-1023's argument reaches it and ADR-1030's exemption does not.
That is the whole decision, and it is worth a record because the two ADRs read together look like a
precedent for a fifth part.

The consequences are the good ones: refiling a commitment re-keys nothing, every tick stands, two
commitments alike in all four parts are still one commitment however they are filed, and a
commitment the roster has stopped keeping goes on being under the category it was under.

**ADR-1030 is not amended.** Its decision is unchanged and its reasoning is unchanged; ADR-1038
cites it rather than moving it.

### A commitment is offered with a category or without one

Writing the delta turned this up and it is arithmetic rather than taste. A commitment is offered to
a roster in two circumstances that want opposite things:

- **A form a person just filled in** has a category to say, possibly "none", and what it says must
  win — otherwise there is no way to take a category off while taking a commitment up again, and
  settled answer 19 would have nothing to stand on.
- **A commitments screen's one tap on a stopped commitment** asks for nothing at all: no name, no
  rhythm, no day (that is the existing requirement's own wording) and therefore no category. It must
  leave the category alone, or every stopped commitment would come back uncategorised.

A single `add(_:under:)` cannot express both, because `nil` already means "under none". A double
optional would; two overloads say it in the domain's own words instead, and the requirement states
the two asks rather than the two signatures. `DayScreen`'s day-one take-on uses the form that says
nothing, which is right: day one has no categories to give.

### The offset a screen takes is over the group it was dropped in

Until this change the commitments screen's kept list and the roster's own order were the same
sequence, so one offset meant one thing. Grouping makes them two sequences and the drop has to say
which group it landed in, so the delta takes **a place inside a group**: a commitment, the group,
and an offset counted over the entries drawn in that group.

**This is the reversal, and the thing it buys is the end of a group.** The delta first took an
offset counted over the whole drawn list, with the category read off the entry standing at it — the
answer to residual question 1, taken on my recommendation. On the phone on 2026-09-08 it was wrong
in the hand and the reason is arithmetic: the place after a group's last row and the place before
the next group's first row are **one offset** on a flat list, so one of the two must be unreachable,
and the one that was given up was the end of a group. A person could not append a row to a group at
all — every attempt fell into the group below. Counting the offset inside the group gives those two
places one offset each, and `grill.md` § *Settled* 24 is where the owner reversed it.

Given a group *g* and an offset *k* over the entries drawn in it:

- **the category** is *g*'s own, whatever *k* is — the drop carries the group it landed in;
- **the roster's offset** is the place immediately before the entry drawn at *k* in *g* among the
  commitments the roster is keeping, or immediately after the last entry drawn in *g* where *k* is
  the number drawn in it.

Because the moved commitment is under *g*'s category once the drop is made, and a group's entries
are drawn in the roster's own order, that is the place that draws it where it was dropped.

**The shell still converts nothing**, which is what ADR-1019's guard requires and what makes a
`Section` per group affordable at all. It passes two things it already holds: the section's own
identity, which is a constant it drew the heading from, and `onMove`'s `Int` untouched. There is no
line in `CommitmentsView.swift` that adds, subtracts or counts — strictly less than the flat
arrangement needed, which had to work out which drawn offset each heading sat above.

**Two offsets change nothing at all, and the carve-out is now entirely inside one group.** The
offset an entry is drawn at within its own group and the one just after it both leave it where it is
drawn, and both leave its category alone because the group it was dropped in is the group it was
already in. Dropped in any other group there is nothing to carve out: the category changes at every
offset that group has, even where the drawn order would not move. That is simpler than the rule it
replaces, which had to carve the category out too because the second of the two offsets named an
entry that might belong to the next group.

**A group nobody is in is a group no drop can land in.** A category no kept commitment is under —
including no category at all, where everything kept is under one — is drawn nowhere, so the shell
cannot produce the ask; the screen answers it as it answers every other ask for no change, by doing
nothing and saying nothing. Answering it by creating the group would be the screen inventing a place
a person could not have pointed at, and it would move a commitment in the roster's order as a side
effect of a gesture nobody made.

**One consequence is stated in the requirement rather than hidden:** dragging a group's *first*
commitment away moves the group, because a group sits where its first commitment sits. A person who
drags the top row of "Supplements" to the bottom of the screen may see the whole "Supplements" block
follow. That is settled answer 11 read at its edge, not a defect, and it has a scenario.

### What the mark was for, and what draws it now

**The requirement *A commitments screen says which group a drop would join, while a drag is live* is
out of this delta, with all nine of its scenarios**, and `CommitmentsScreen.landing(dropping:at:)`
and its `Landing` enum are off the seam. This is the second thing settled answer 24 moves, and it is
a consequence of the reversal rather than a decision taken beside it, so it is set out here for the
gate to read.

Settled answer 21 asked for the mark, and it said what it was for in its own words: the seam rule at
residual question 1 was *"ambiguous by construction, and this is what makes it legible"*. The
ambiguity was that one offset on a flat drawn list stood between two groups and had to pick one, with
nothing on screen to say which. Counting the offset inside a group **removes the offset that was
ambiguous.** There is no longer a place between two groups: there are places inside Supplements and
places inside Sport, and which one a finger is in is drawn on the phone as the section it is in,
permanently and before the drag starts. **The `Section` per group is the mark**, and it is drawn by
the arrangement rather than answered by the kit.

Keeping the requirement would cost more than deleting it and leave less. Its rule was *"the same
arithmetic `move` acts on, read instead of acted"* — and `move`'s arithmetic now begins with a group
the caller names, so a `landing(dropping:at:under:)` could only hand back the group it was just
given. Six of its nine scenarios, including the load-bearing *the group a commitments screen says a
drop would join is the group the drop puts the commitment in*, would be rewritten into tautologies,
and `openspec/specs/commitment/spec.md` would carry them permanently under rule 2. A requirement
that cannot be got wrong is not a requirement.

**What settled answer 21 chose is kept where it still applies.** It said a mark belongs on the
heading and never on the dragged row, because the row is under a moving thumb; a section header is
exactly that, and it is the one thing on the screen that now cannot move with the row. § *The shell
rides this Story* is where that lands.

### The form on disk moves to form 4, and ADR-1031 is amended

`RosterDocument.currentVersion` goes to `4` and `RosterEntryRecord` gains `category: String?`,
**written on every entry at form 4 and on none before it** — `null` where the commitment is under
none. The shape-against-form guard `removed` already has is extended one field: a document declaring
form 1, 2 or 3 that carries a `category` key is refused as content that is not a roster store, and
so is one declaring form 4 that omits it. The measurement in § *Context* is what makes that
possible; `category` cannot be inferred from absence the way `keptUntil` is, because "absent" and
"under none" would otherwise be the same bytes.

**ADR-1031's reversal trigger fires here and the ADR is amended in place** (ADR-1020), in this
change folder's own diff. Its trigger reads *"a fourth form, or a form that differs by more than a field"*,
and the roster document's fourth form is exactly the first half of that. The amendment records that the trigger
fired and that the decision held: four forms differing from
one another only by a field being present or absent still read under one comparison against a
version already in hand, so **the "decode path per form" the trigger reserved is still not owed** —
what is owed is saying so out loud rather than letting a named trigger pass unremarked. If the
implementation finds it needs a second decode path, **stop and report it**: that is a different
amendment and the owner's call.

Byte-stability is unaffected. `add-roster-store`'s `design.md` fixed `.sortedKeys` for a keyed
container's keys; a new key sorts into place and the roster's own array order is untouched.

### The stale titles, and the requirements not carried

Three requirement titles are made wrong or incomplete by this change and none of them can be fixed,
for the reason `add-roster-removal` measured and `add-roster-order` re-applied: `openspec` 1.10.0
refuses a MODIFIED requirement that omits a scenario the current spec has, so the only way to drop
one is to RENAME the requirement, which appends its whole block to the bottom of the spec at archive
time, permanently, in a file that may not be hand-edited afterwards (rule 2).

- **`A commitments screen defines a commitment from a name, a rhythm and the day it is kept from`**
  now defines one from four things. The requirement is MODIFIED and its first sentence says four, so
  the correction sits one line under the wrong title.
- **`A roster store reads a roster kept before a commitment carried a kind`** now reads three
  earlier forms. Same treatment, same reason.
- **`A commitments screen lists the commitments its roster keeps, in the order they were taken on`**
  was already stale before this change and is carried anyway, because grouping does change what it
  says.

And three requirements are deliberately **not** carried, which is where most of the delta's size was
saved:

- **`A day view is in the order it was handed its commitments`** — untouched, and § *Where the
  grouping is worked out* is why that is the design working rather than an omission.
- **`A day view is the commitments due on a date, each with whether it is kept`** — every sentence
  in it stays true. A day view is still formed from some commitments, a date and a history; the
  commitments now arrive in groups, and the ADDED requirement says so. Carrying eleven scenarios to
  add "in groups" to one sentence would be cost with no correction at the end of it.
- **`A commitments screen takes a stopped commitment up again in one tap`** — its rule is unchanged
  and the category question it raises is answered where the answer belongs, in *A roster refuses a
  commitment it already holds* (the offer that says nothing leaves the category alone) and in *A
  commitments screen lists what has been stopped* (which carries the scenario).

### The shell rides this Story

`CommitmentsView.swift` gets the category field, the categories offered and the grouped kept list;
`ContentView.swift` gets the grouped day view. Under ADR-1019's 2026-09-04 amendment, whose three
conditions hold: the shell is the immediate consumer, landing in the same PR; it introduces no
behaviour the kit does not specify — every group, every order, every refusal and the whole meaning
of a drop is behind the seam; and it is `tasks.md` § 9, its own section, for the reviewer.

**The kept list becomes a `Section` per group**, each with its category as the section's header and
the group with no category as a section with none, each holding one `ForEach` over that group's
commitments with `.onMove` attached. **This reverses what this section said before 2026-09-08**, and
the reversal is settled answer 24's: the flat `ForEach` was chosen to keep `.onMove`'s offset
counted over the whole drawn list, and that list is the thing that made the end of a group
unreachable.

**Nothing crosses the seam to buy it.** `.onMove` is declared on `DynamicViewContent`, so the `Int`
it hands a section's `ForEach` is already counted over that group's own entries — the shape
`CommitmentsScreen.move(_:toOffset:under:)` now takes. The shell passes it untouched, beside the
section's own identity, which is the `Roster.Group` it is drawing and not something it worked out.
That is **less** arithmetic than the flat arrangement, which had to build a map of drawn offsets to
know which entry each heading sat above; a shell that computes nothing cannot compute it wrongly,
which is ADR-1019's guard read forwards.

**Two things the phone found are drawn right by this arrangement and are not requirements** —
`grill.md` § *Settled* 25, recorded so nobody solves them twice:

- **The heading no longer drags with its row.** It dragged because a heading and its row were one
  `ForEach` element; a section header is outside the `ForEach` entirely and there is no gesture that
  can pick it up. Nothing has to be written to get this, and `.moveDisabled` is not the answer to it.
- **There is a visible boundary before the commitments under no category, on both screens.** A
  `Section` with no header still draws a section break in a grouped `List`, so the last category ends
  somewhere a person can see. **No heading is invented for that group** — settled answer 11 stands,
  and what was missing was a boundary and not a name.

**`ContentView.swift` takes the same shape for the same second reason.** The day view's groups become
a `Section` each, header where there is a category and none where there is not, which is where the
day screen's half of that boundary comes from; it has no drag, so the first defect never reached it.
Two things to keep: a row's identity must stay stable across a tap — the offset within its own
group's `ForEach` is, exactly as the flat offset was — and the day view's `rows` stays the flat read
across the groups for everything else that uses it.

**The stopped list keeps its own single `Section` and gains nothing**, which is what makes "the
stopped list is not grouped" true on a phone rather than only in a requirement. It is now one section
among several rather than the second of two, so it wants a header that says so.

**One thing about this arrangement is not yet known, and it is § *Questions for you* 1.** `.onMove`
names one collection, so a drag that starts in one section may well not be deliverable into another
— which would leave settled answers 14 and 15 specified, tested at the seam, and unreachable by drag
on the phone until a Story rewrites the gesture. `tasks.md` § 9.5 measures it at the walkthrough and
**stops** rather than reaching for a custom `draggable`/`dropDestination` drag, which would put
"which row am I over" in `CommitmentsView.swift` and is the one thing ADR-1019's guard forbids.

### The day view is handed its groups, and `CONTEXT.md` is corrected

`CONTEXT.md` § *Day view*'s 2026-09-08 amendment reads *"A day view draws its rows in **groups**,
one per **category**, and this is the one ordering it makes that is not the order it was handed"*.
Writing the delta made that sentence false in one clause: the day view **makes** no ordering, it is
handed one. The rest of the amendment already says so — *"It is not a rule the day view invented —
the order is still the person's, read off the roster"* — so the correction is to the clause and not
to the decision. It is **made in this change's own diff**, stamped as a correction rather than as a
second amendment, and `tasks.md` § 10 confirms it against the code rather than making it.

This is recorded here rather than done quietly because `CONTEXT.md` is the grill's output and
correcting one is worth a paragraph.

## Risks / Trade-offs

- **`add-number-entry` (#139) is open, out of draft, and holds 810 added lines in
  `openspec/specs/day-screen/spec.md`.** It modifies *A day view is the commitments due on a date*,
  *A day view is in the order it was handed its commitments* and *A day view is a value*, and this
  delta modifies the third of those. → **If #158 merges first, this delta's `day-screen` file must
  be rewritten against the new spec before it can validate**, because a MODIFIED requirement may not
  drop a scenario the current spec has. It is not a git conflict and the rebase will look clean; the
  failure shows up at `openspec validate --strict`. `tasks.md` § 1.3 measures it before anything is
  written and § 10.3 re-measures it before the review. **The cheapest order is to merge #158 first**,
  and that is a recommendation to the owner rather than a decision this Story can take.
- **The delta is the largest this repo has shipped — 206 scenarios, 129 of them carried verbatim.**
  → Unavoidable at this scope: `openspec` replaces a MODIFIED requirement whole, and twelve
  `commitment` requirements have a sentence that is false once a category exists. The saving that
  was available has been taken — § *The stale titles* names the three requirements deliberately not
  carried, and `tasks.md` § 1 gives the implementer the covered count so they start from a number.
- **The scope is the grill's, chosen against the grill's own recommendation three times** — settled
  answers 9, 10 and 14 each record a recommendation to do less and a decision to do more, which is
  why this Story spans two capabilities and both screens. → Recorded rather than re-litigated. It is
  said here so that a reviewer reading the size knows it was bought deliberately.
- **A person who files a commitment loses sight of where it sits in the roster's order.** Giving a
  commitment a category moves it on screen and not in the roster, so clearing it moves the row back
  somewhere the person did not put it. → Settled answer 17, and the delta makes it visible with a
  scenario rather than leaving it to be discovered. The alternative — a category change that also
  reorders — would make one order out of two decisions.
- **Dragging a group's first row moves the group.** → § *The offset a screen takes* names it, and it
  is the price of "a group sits where its first commitment sits". Uncategorised-first and
  alphabetical groups were both offered at the grill and declined.
- **A drag alone can never lift one group above another, and this Story accepts that** — settled
  answer 22. What does work is two steps: drag the row into place, then set its category back with
  the field, which changes no order. → Possible and not discoverable, and the answer is settled
  answer 23's own Story, taken straight after this one. It is recorded here and **not designed
  for**: nothing in this delta anticipates it, and the grouping rule written here is what that Story
  will be grilled against.
- **A drag may not be able to leave its section, which would make settled answers 14 and 15
  unreachable on the phone in this Story.** `.onMove` names one collection and the SDK publishes no
  overload that names two — § *Context*. → § *Questions for you* 1 puts it to the owner, `tasks.md`
  § 9.5 measures it at the walkthrough, and the requirement is true and tested at the seam either
  way. Worth knowing at G4: this is the one part of the Story whose visible result is not guaranteed,
  and the reason it is here at all is that the arrangement that guaranteed it is the one that made
  the end of a group unreachable.
- **This delta has been rewritten once after implementation, and the second G4 is the price.**
  Settled answer 24 reversed a seam rule the owner had already approved, after seeing it on the
  phone. → Taken deliberately, and cheap by comparison: what changes is one signature, one
  requirement's prose, six scenario bodies, two scenario titles and a requirement that is deleted
  rather than rewritten into a tautology. Every carried scenario and every other requirement in the
  delta is untouched.
- **The form-4 shape guard rests on a `Codable` detail.** `contains(key)` telling `null` from absent
  is measured, not remembered, and the measurement is in § *Context*. → If it stops holding, the
  guard silently weakens rather than failing loudly, so `tasks.md` § 5 writes the two refusal
  scenarios before the happy path.
- **A phone that opens this build and changes nothing keeps a form-3 file for ever.** → That is
  ADR-1031 working as designed, and the "reading changes nothing at its place" scenario is carried.

## Open Questions

**One is outstanding — § *Questions for you* 1, raised on 2026-09-08 and about what the shell can
draw rather than about what the delta says.** The rest are settled: `grill.md` § *Left open* named
three, the residual round asked two more, and settled answer 24 has since reversed the first of
those. What each one settled to:

1. **A drop carries the group it landed in — reversed 2026-09-08, and the answer it replaces is left
   standing here on purpose.** Residual question 1 was answered on my recommendation: a drop on the
   seam between two groups joins the group *below*, the offset stays the single one
   `add-roster-order` fixed, and the cost was priced as "one unreachable slot, reached in two drops
   instead". **That price was wrong.** The unreachable offset is the end of a group, so a person
   could not append a row to a group at all — every drop meant for the bottom of Supplements landed
   in Sport. The owner found it by hand at the § 9.5 walkthrough (`grill.md` § *Settled* 24) and
   reversed it: the offset is now counted inside the group the drop landed in, and the drop carries
   that group's category. § *The offset a screen takes is over the group it was dropped in* carries
   the rule, § *What the mark was for, and what draws it now* carries what it takes out with it, and
   `grill.md` § *Left open* 4 says why settled answer 14 and residual answer 1 are left standing in
   that file rather than edited. **The lesson is the pricing and not the choice**: "one unreachable
   slot" was counted as a slot when it was a *kind* of slot, one per group, and the one a person
   reaches for most.
2. **The form offers the categories the commitments the screen is *keeping* are under**, and not
   ones only a stopped commitment carries. Residual question 2, answered on the recommendation. The
   offering exists so a typed word lands on an existing heading, the stopped list draws no headings,
   and a stopped commitment brings its own category back when it is taken up again in one tap.
   `grill.md` records that this one is a finding about the grill rather than a question only the
   delta could raise: settled answer 7 says "the roster's commitments" where a roster holds three
   states.
3. **B-030 is answered by this Story and is still a want in `docs/backlog.md`.** Nothing in the
   delta depends on it; moving it to *Decided* is the next grooming pass's work, and `tasks.md`
   § 10.6 leaves a line for it rather than reaching into the backlog from a Story branch.
4. **An ADR is owed for a category being the roster's** — decided as **ADR-1038** in § *A category is
   the roster's, and ADR-1038*, numbered against every remote branch rather than against `main`
   alone: `main` ends at 1037 and `origin/story/139-add-number-entry` holds 1036, checked with
   `git ls-tree -r --name-only <branch> -- docs/adr` over every remote, 2026-09-08. A second record
   is owed that the grill did not foresee — **ADR-1031 amended in place**, because this change fires
   the reversal trigger that ADR wrote for itself.
5. **A draggable group heading is a Story of its own**, written after this Story's G4 and taken
   before #148 `add-commitment-editing` — settled answers 22 and 23, and `grill.md` § *Left open* 3.
   Nothing in this delta depends on it and **nothing in this delta designs for it**: a group's
   members need not be adjacent in the roster's order, so moving one gathers and relocates a block,
   which is the first act in this product that would move more than one commitment at once. That
   needs a grill of its own, against the grouping rule written here.

One thing is settled but not yet *known*, and it is not a question for the owner: whether
`add-number-entry` (#139) lands on `day-screen` first is a fact the implementer re-measures at
`tasks.md` § 1.3.

## Questions for you

One question, raised while rewriting the delta for settled answer 24 and outstanding at the time
this was written. **The delta is written on the recommended answer** and does not change either way;
what changes is `tasks.md` § 9 and what you should expect to see at the next walkthrough.

1. **A `Section` per group probably costs the cross-group drag.** `.onMove` is declared on
   `DynamicViewContent` and its `IndexSet` and `Int` are both over one `ForEach`'s own data
   (`iPhoneOS26.5.sdk`, `SwiftUI.swiftinterface:10353`); no overload names two collections. So a
   drag that starts in the Supplements section may simply not be deliverable into the Sport one, and
   settled answers 14 and 15 — a drop into another group files it there, a drop among the
   uncategorised clears it — would be reachable at the seam and by the category field, but not by
   dragging. It could not have been asked before, because it only exists once the shell is fixed as
   a `Section` per group, which is what the reversal fixed it as.
   - *Recommended:* **take it.** The defect you reported is the one being fixed and it is fixed
     either way; refiling already has a one-tap route on the row; and the gesture that would restore
     the cross-group drag is a custom `draggable`/`dropDestination` drag, which is a shell rewrite
     with arithmetic in it, an ADR-1019 question, and naturally part of settled answer 23's
     draggable-group-heading Story rather than this one.
   - *If you say the cross-group drag has to work in this Story:* nothing in the delta moves — the
     requirement is written the same way whichever gesture drives it — but `tasks.md` § 9 grows a
     shell rewrite, ADR-1019's guard has to be re-argued for it, and the Story stops being one an
     implementer can finish from the delta alone.
   - *Either way:* `tasks.md` § 9.5 measures it on the phone and reports what it found, and a
     surprise there is a stop and not a quiet fix.
