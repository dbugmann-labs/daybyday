## Context

See `proposal.md` § *Why*, and `grill.md`, whose twenty-eight settled answers this delta is written on.
**Settled answer 24 reversed settled answer 14's seam rule on the phone, on 2026-09-08**, and the
sections it moved are § *The offset a screen takes is over the group it was dropped in*, § *What the
mark was for, and what draws it now* and § *The shell rides this Story*; § *Open Questions* 1 records
the reversal beside the answer it replaced. **Settled answer 26 then kept the cross-group drag** that
the reversal put at risk — and **settled answer 27 gave it up**, on the same day, after it had been
built twice and walked on the phone twice. What that moves is § *The shell rides this Story*,
§ *Risks* and `tasks.md` § 9, and in the delta itself **four passages of prose and one scenario title
and nothing else** — no requirement, no `SHALL`, no scenario clause, no signature — because the
requirement is about the ask a screen is given, a commitment, a group and an offset inside it, and it
reads the same whichever gesture delivers it. What moves is the prose that said a person *drags* a
row from one group into another, which is a thing this app does not do; § *Open Questions* 6 names
all five, records the reversal beside the answer it replaces, and
§ *The shell rides this Story* carries the two facts that were measured on the way, because they are
what the next Story inherits rather than what this one concluded.
What matters here is that a **category** is a word the person chose, held by the roster against a
commitment, and that **grouping is a second reading of the order the roster already holds**. Once
those two are fixed everything else follows: the commitment gains nothing, the day view gains no
rule about arrangement, and the one grouping rule in the product lives in one place that both
screens read.

Nine facts read off this worktree at `19fb199`, 2026-09-08. The first seven were measured for this
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
  counted inside one group.** That is the fact the new seam is shaped to. It is also what a `Section`
  per group costs: `.onMove` alone cannot carry a row out of one group and into another.
- **`draggable` and `dropDestination` read as usable here, and reading was not enough.** This is the
  measurement settled answer 26 required, made 2026-09-08 against the same `iPhoneOS26.5.sdk`
  `SwiftUI.swiftinterface`. It is left standing because every line of it is still true, and because
  **it is the trap**: the interface answers what a shell would be *asked to compute* and says nothing
  about which modifier a long press reaches. Settled answer 27 is what a phone answered, and it
  overrides this — § *The shell rides this Story*. Three lines say what was read:

  ```swift
  // :9451
  extension SwiftUICore.DynamicViewContent {
    nonisolated public func dropDestination<T>(for payloadType: T.Type = T.self, action: @escaping ([T], Swift.Int) -> Swift.Void) -> some SwiftUICore.DynamicViewContent where T : CoreTransferable.Transferable
  // :9453
    @available(*, unavailable, message: "Unavailable for DynamicViewContent, use `dropDestination(for:action:)` instead.")
    public func dropDestination<T>(for payloadType: T.Type = T.self, action: @escaping (_ items: [T], _ location: CoreFoundation.CGPoint) -> Swift.Bool, isTargeted: (Swift.Bool) -> Swift.Void = { _ in }) -> some SwiftUICore.View where T : CoreTransferable.Transferable
  // :23663
  extension SwiftUICore.View {
    nonisolated public func draggable<T>(_ payload: @autoclosure @escaping () -> T) -> some SwiftUICore.View where T : CoreTransferable.Transferable
  ```

  The `Int` at `:9451` is documented in the module's own `arm64e-apple-ios.swiftdoc` as *"the offset
  relative to the dynamic view's underlying collection of data"* — this section's own `ForEach`, so
  the same offset `.onMove` gives and the same one `CommitmentsScreen.move` now takes. **The
  geometric overload is `unavailable` on `DynamicViewContent` by name**, at `:9453`: SwiftUI itself
  withholds from a `ForEach` the API that would make a shell work out where a drop landed, and
  offers the index-handing one in its place. And it compiles, not merely reads: a probe with two
  `Section`s, `.onMove` and `.dropDestination(for:)` on each section's `ForEach` and `.draggable` on
  every row typechecks against `iPhoneSimulator.sdk` at `-target arm64-apple-ios26.0-simulator`.
  **It typechecks and it does not run**: on the phone, `.onMove` takes every long press and the
  `.dropDestination` beside it never fires. Typechecking was read as working, and that is the whole
  distance between settled answer 26 and settled answer 27.
- **580 tests pass**, `swift test` from `src/DayByDayKit`, this branch cut from `main` at `f8236be`
  which includes `add-roster-order` (#161).
- **`pnpm run check:scenarios` reports `129/206 scenario(s) covered`** for this change. Those 129
  are the scenarios this delta carries verbatim from the current specs; **no test behind any of them
  may be renamed, moved, or have an assertion changed.** Seventy-seven are new.

`CONTEXT.md` fixes the vocabulary — the new **category**, and the amendments to **roster**, **roster
store**, **commitments screen**, **day view** and **move** — and the grill landed all of it before
this folder existed. **Four of its paragraphs are corrected here**, and § *The day view is handed its
groups, and `CONTEXT.md` is corrected* says which and why: § *Day view*'s claim to make an ordering,
the drag-mark paragraph settled answer 21 landed and settled answer 24 made false, and the two
paragraphs — in § *Move* and § *Commitments screen* — that say a person drags a row between groups,
which settled answer 27 made false. **The domain each of those describes is unchanged**; what is
corrected is only the claim about the gesture. Writing the delta turned up no new headword.

## Goals / Non-Goals

**Goals:**

- A word a person types, held against a commitment, changeable as often as they like, that re-keys
  nothing already recorded.
- **One** grouping rule, in one place, that both screens read — so the two can never disagree about
  where a group sits.
- A day view that still orders nothing of its own. Grouping is handed to it, so the requirement
  that has held since `add-day-view` (#70) is left untouched.
- A move that carries a group as well as an offset, so that the end of a group is a place a person
  can reach. **Not** a particular gesture: the requirement is the ask, and what ships to drive it is
  a drag inside a group and the row's **Category** action across groups.
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
identity, which is a constant it drew the heading from, and the destination `Int` untouched — from
`.onMove`, counted over that section's own `ForEach` (§ *Context*). There is no line in `CommitmentsView.swift`
that adds, subtracts or counts — strictly less than the flat arrangement needed, which had to work
out which drawn offset each heading sat above.

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

**One consequence is stated in the requirement rather than hidden:** taking a group's *first*
commitment out of it moves the group, because a group sits where its first commitment sits. A person
who drags the top row of "Supplements" down inside its own group, or files it into "Sport" with the
row's **Category** action, may see the whole "Supplements" block move. That is settled answer 11 read
at its edge, not a defect, and it has a scenario.

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

**Settled answer 27 takes the last of the argument away rather than putting any of it back.** With
the cross-group drag given up, the only live drag left is one that starts and ends inside a single
section, so a finger is in the group it started in for the whole of it and there is nothing a mark
could tell a person that the arrangement is not already telling them. Refiling is now the row's
**Category** action, which is a tap on a named group and not a place on a screen. The deleted
requirement stays deleted for a second reason, and it is a stronger one than the first.

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

**The cross-group drag is given up, and the row's own *Category* action is what refiles across
groups.** `.onMove` names one collection, so a `Section` per group cannot by itself
carry a row out of Supplements and into Sport. That loss was offered at the second residual round
and declined (`grill.md` § *Settled* 26), so the shell was given a `.draggable`/`.dropDestination`
pair of its own; it was built, walked on the phone, rebuilt against a second theory of why it failed,
and walked again. It does not work, and **settled answer 27 gives it up**. What ships is `.onMove`
alone inside each section, which reorders within a group through Edit mode, and the **Category**
action already on every row, which files a commitment under any word the person types or picks and
which works.

```swift
Section {
    ForEach(Array(group.commitments.enumerated()), id: \.offset) { index, commitment in
        commitmentLine(Text(commitment.name), rhythmInWords: commitment.rhythmInWords)
            .swipeActions { /* Stop, Remove, Category */ }
    }
    .onMove { source, offset in
        guard let index = source.first else { return }
        screen.move(group.commitments[index], toOffset: offset, under: group.category)
    }
} header: {
    if let category = group.category { Text(category) }
}
```

**Two facts were measured on the way, and they are the inheritance rather than the conclusion.**
Both were found by instrumenting the shipped shell and walking it on the owner's phone, and neither
was guessable from a header file — § *Context*'s interface reading is true and predicted none of it:

- **`.onMove` and `.dropDestination(for:)` cannot share a `ForEach`.** With both closures logging,
  `.onMove` won **every** long press and dropped on the floor any drag that left its own section;
  `.dropDestination` never fired at all. Not sometimes, and not depending on where the finger went.
- **An abstract `UTType` was not what was missing.** The payload was moved off `public.content` and
  onto an exported type of the app's own, following Apple's own `Transferable` reordering example,
  and the row still snapped back. The second theory was wrong in the same way as the first.

**So the dead plumbing comes out.** `.draggable`, `.dropDestination(for:)`, the shell-local
`DraggedRow` payload, its `kept(_:)` resolver and the `import UniformTypeIdentifiers` that only
`DraggedRow` needed are all in `CommitmentsView.swift` today and reach nothing. They were left in
deliberately for one pass, because this section named them and a shell that stops matching its
`design.md` is the defect this Story has already killed three times. `tasks.md` § 9.0 takes them
out — the box that added them becomes the box that removes them.

**ADR-1019 stands untouched, and now trivially.** The one argument the shell still gives `move`
beside the commitment is `group.category`, the constant this `Section` drew its header from, and the
`offset` is the `Int` SwiftUI computed and documents as *"the offset relative to the dynamic view's
underlying collection of data"* (§ *Context*). No line in `CommitmentsView.swift` adds, subtracts,
counts rows or asks where a finger is; taking the drop path out removes the only place one could
have appeared. **No ADR is owed for this**, and none is written.

**Nothing in the delta moves, and that is the test this correction had to pass.** Every scenario
under *A commitments screen moves a commitment among the ones it keeps* is stated as an ask — a
commitment, a group and an offset counted inside it — and is driven at
`CommitmentsScreen.move(_:toOffset:under:)`. A drag inside a group reaches it, the **Category**
action reaches `put(_:under:)` beside it, and a cross-group drag would have reached it too. The kit
is untouched by settled answer 27: same seam, same 206 scenarios, same 782 tests.

**What is now unreachable by any gesture is stated rather than hidden.** The scenarios that describe
a commitment arriving in a group it was not in — *a commitment dropped among another group's entries
is put under that group's category* and its neighbours — are requirements of the screen that no
gesture in the shipped app produces, because the **Category** action files a row without giving an
offset. They are specified, tested and correct, and #168 is where a gesture reaches them: that Story
has to build a drag layer for group headings anyway, so it inherits both the requirement and the two
measurements above. `docs/backlog.md` is where the want goes if #168 does not take it.

### The day view is handed its groups, and `CONTEXT.md` is corrected

`CONTEXT.md` § *Day view*'s 2026-09-08 amendment reads *"A day view draws its rows in **groups**,
one per **category**, and this is the one ordering it makes that is not the order it was handed"*.
Writing the delta made that sentence false in one clause: the day view **makes** no ordering, it is
handed one. The rest of the amendment already says so — *"It is not a rule the day view invented —
the order is still the person's, read off the roster"* — so the correction is to the clause and not
to the decision. It is **made in this change's own diff**, stamped as a correction rather than as a
second amendment, and `tasks.md` § 10 confirms it against the code rather than making it.

**Two more paragraphs are corrected for settled answer 27, and the line they are corrected along is
the same one the drag mark was corrected along.** § *Move*'s 2026-09-08 amendment says *"a commitment
dropped into another **category**'s group is moved to where it was dropped *and* put under that
category"*, and § *Commitments screen*'s says *"Its drag now carries a second meaning: a row dropped
into another group is moved *and* recategorised"*. **The roster still does exactly that** — it is
what `Roster.move(_:toOffset:under:)` and `CommitmentsScreen.move(_:toOffset:under:)` answer, and
every scenario about it stands — so the domain is true and stays. What is false is the claim that a
person's **drag** is what delivers the ask. Both paragraphs are corrected to say what a person can do
— reorder inside a group by dragging, refile across groups with the row's **Category** action — and
to leave what a move *is* alone. A term's definition is what the roster does; a gesture is what a
shell offers, and only the second of the two changed.

This is recorded here rather than done quietly because `CONTEXT.md` is the grill's output and
correcting one is worth a paragraph.

## Risks / Trade-offs

- **Two Stories have landed on `day-screen` while this one was being written, and a third would be
  the same risk again.** `add-number-entry` (#158) merged, and `add-note-record` (#169) merged after
  it, together adding 720 lines to `openspec/specs/day-screen/spec.md`. The danger a MODIFIED
  requirement runs is that it may not drop a scenario the current spec has, and it is not a git
  conflict — the failure shows up at `openspec validate --strict`. → **Measured 2026-09-08 against
  current `main` and this delta is clean**: all fourteen MODIFIED requirements — twelve in
  `commitment`, two in `day-screen` — still exist under the same titles and drop no scenario, and
  `openspec validate --all --strict --no-interactive` exits 0 with `main`'s specs in place. Neither
  Story touched the two `day-screen` requirements this delta modifies; both added their own.
  `tasks.md` § 1.3 re-measures it before anything is written and § 11.3 again before the review,
  because a fourth Story landing here would not announce itself either.
- **What those two Stories did leave is a rebase this Story cannot finish by itself.**
  `add-note-record` (#169) changed `DayView.swift`, `DayScreen.swift`, `ContentView.swift` and three
  test files that this branch's implementation commits also changed. → Nothing in
  `openspec/changes/` or `openspec/specs/` conflicts, so it is not the stop `AGENTS.md` names; it is
  ordinary `src/` and `tests/` merge work and therefore `implementer`'s rather than `spec-author`'s.
  `tasks.md` § 11.3 is where it is resolved, and a conflict that reaches the change folder or the
  specs at that point **is** the stop.
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
- **No gesture lifts one group above another, and this Story accepts that** — settled answer 22.
  What does work is two steps: move the row into place, then set its category back with the field or
  the row's **Category** action, neither of which changes an order. → Possible and not discoverable,
  and the answer is settled answer 23's own Story (#168), taken straight after this one. It is
  recorded here and **not designed for**: nothing in this delta anticipates it, and the grouping rule
  written here is what that Story will be grilled against.
- **A drag files a row within its group and no further; refiling across groups is the row's
  *Category* action.** `.onMove` names one collection, so a `Section` per group — what makes the
  end of a group reachable — cannot carry a row out of one group and into another. The hand-written
  replacement was specified, built, walked, rebuilt on a second theory and walked again, and it does
  not work: `.onMove` wins every long press it shares a `ForEach` with, and an exported `UTType` did
  not change that (§ *The shell rides this Story*). → Settled answer 27 gives the gesture up.
  **Nothing in the delta moves** — the requirement is the ask and not the gesture — and the shipped
  app can still do everything the requirement describes, in two acts rather than one. What is lost is
  discoverability, and what is bought is a shell with no drop path in it at all: **ADR-1019 is
  untouched and no record is owed.** The want goes to #168, which needs a drag layer anyway.
- **Two evenings were spent on a gesture nothing in this repository can test** — settled answer 28.
  The Simulator has no GUI on this machine and XCUITest's synthetic touch never triggered
  `.dropDestination` in any configuration, so every attempt was a round trip through the owner's
  phone. → Recorded as a fact about the environment rather than about this Story, and the reason
  `tasks.md` § 9.5 is the only box in this change that tests a gesture at all. A future want that
  turns on one should be priced with that in it.
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

**None outstanding, and one carried forward that is nobody's to answer yet — 7.** `grill.md`
§ *Left open* now names five; the first residual round asked two more, of which settled answer 24 has
since reversed the first; and a second residual round asked one, which settled answer 26 answered on
2026-09-08 against my recommendation and settled answer 27 reversed the same day. What each one
settled to:

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
   needs a grill of its own, against the grouping rule written here. **It inherits 6 as well as
   this**: the cross-group drag this Story gave up is cheapest there, because that Story has to build
   a drag layer for headings anyway, and the two measurements in § *The shell rides this Story* are
   what it starts from rather than repeats.

6. **The cross-group drag is given up — reversed 2026-09-08, and the answer it replaces is left
   standing here on purpose, exactly as the seam answer at 1 is.** The second residual round asked
   whether to keep it once a `Section` per group had been fixed as the arrangement. I recommended
   taking the loss, on the ground that refiling keeps a one-tap route on the row and that settled
   answer 23's Story would write the custom gesture once for headings and rows together. **The owner
   declined** — the drop into another group is the gesture settled answer 14 was chosen for, against
   my recommendation then too (`grill.md` § *Settled* 26) — and the measurement the answer turned on
   came back on the side of keeping it: the SDK hands the shell a group's identity and an index and
   asks it to compute nothing, so ADR-1019 was untouched and no record was owed.

   **That measurement was of the wrong thing.** It read the interface, and the interface does not say
   which modifier a long press reaches. Built, walked on the phone, rebuilt against a second theory
   of the failure and walked again, the drag never worked: `.onMove` wins every long press it shares
   a `ForEach` with and drops any drag leaving its section on the floor, and moving the payload off
   `public.content` and onto an exported type of the app's own changed nothing. **Settled answer 27
   gives the gesture up.** What ships is `.onMove` inside a group through Edit mode and the row's
   **Category** action across groups.

   **No requirement moves, and that is the point worth reading at this gate.** The requirement is the
   ask a screen is given — a commitment, a group, an offset counted inside it — so it reads the same
   whichever gesture delivers it; the kit is untouched, all 206 scenarios stand, one of them under a
   new title, and all 782 tests are green.

   **What does move in the delta is prose that claimed the gesture, and one scenario title.** This
   folder archives into `openspec/specs/commitment/spec.md`, where a reader has only what it says, so
   a sentence telling them a row is dragged from one group into another is evidence of a feature that
   does not exist. Five passages said it and all five are corrected: in
   § *A roster moves a commitment among the ones it keeps*, the paragraph on why a move carries a
   category; in § *A commitments screen moves a commitment among the ones it keeps*, the paragraph on
   what a drop says the row is now under and the one on a group's first commitment taking the group
   with it; in § *A commitments screen puts a commitment under a category*, the second of the two ways
   a category changes; and the scenario title
   `moving a group's only entry into another group leaves one heading fewer`, which read `dragging …`
   until this pass. **A scenario title is the worst of the five places for a false word** — it is what
   `check:scenarios` prints and what a test is named for — which is why it is renamed even though the
   behaviour it pins is unchanged and reachable through **Category**, and why `tasks.md` § 9.0 carries
   the matching test rename rather than leaving it to be noticed.

   **One passage that names a drag is deliberately left standing**: the sentence in
   § *A commitments screen moves a commitment among the ones it keeps* that calls the gesture a drag,
   a drag its own confirmation and dragging back the undo. It is carried verbatim from the spec
   `add-roster-order` (#146) shipped, and it is still true of the drag inside a group, which is the
   only drag left. Correcting it would be rewriting a shipped requirement for a word that is not
   wrong.

   What moved outside the delta is `design.md` § *The shell rides this Story*, § *Risks*, this entry,
   `proposal.md` and `CONTEXT.md`, and **`tasks.md` § 9.0 takes the dead plumbing out** and renames
   the one test. ADR-1019 is still untouched, and now for a stronger reason: there is no drop path in
   the shell to guard.
   **The lesson is which measurement was made**: a header file answers what a shell would be asked to
   compute, and this question was about what a finger reaches. Only the phone answers that one, and
   settled answer 28 records that nothing in this repository can stand in for it.

7. **The reorder lag is unexplained, and it is carried out of this Story rather than closed** —
   `grill.md` § *Left open* 5. On the phone, a moved row leaves its old place empty for about a
   second before the list settles. The obvious cause is dead: `RosterStore.write` measured 13ms and
   the whole of `CommitmentsScreen.move` 16ms, and a recorded simulator reorder settles in 0.2–0.4s.
   It was never judged a second time, because the gesture stopped working before it could be.
   **It is not a question for the owner and nothing in this delta turns on it** — no requirement is
   about how long a list takes to settle — so it is recorded here rather than asked. The remaining
   candidate nobody has excluded is that the rows are keyed by position, which `tasks.md` § 9.4 says
   is deliberate and stable across a tap. It belongs to whoever next holds a drag on a real device,
   which is #168.

One thing that was settled but not yet *known* when this was first written is now known, and it was
never a question for the owner: `add-number-entry` (#139/#158) has merged, and so has
`add-note-record` (#169). Both landed on `day-screen`, **and this delta validates against both** —
§ *Risks* carries the measurement. The implementer re-measures it at `tasks.md` § 1.3 anyway,
because a further Story landing here would look exactly the same until it did not.
