## Context

See `proposal.md` § *Why*, and `grill.md`, whose twenty settled answers this delta is written on.
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
- **`CommitmentsView.swift:62` draws the kept list as a `ForEach` inside `Section("Kept")` with
  `.onMove` attached**, and `screen.kept[index]` resolves the dragged row. The offset is passed
  through untouched, which is the arrangement `add-roster-order` fixed and which § *The offset a
  screen takes is over what it draws* keeps.
- **580 tests pass**, `swift test` from `src/DayByDayKit`, this branch cut from `main` at `f8236be`
  which includes `add-roster-order` (#161).
- **`pnpm run check:scenarios` reports `129/205 scenario(s) covered`** for this change. Those 129
  are the scenarios this delta carries verbatim from the current specs; **no test behind any of them
  may be renamed, moved, or have an assertion changed.** Seventy-six are new.

`CONTEXT.md` fixes the vocabulary — the new **category**, and the amendments to **roster**, **roster
store**, **commitments screen**, **day view** and **move** — and the grill landed all of it before
this folder existed. One line of it is corrected here; § *The day view is handed its groups, and
`CONTEXT.md` is corrected* says which and why. Writing the delta turned up no new term.

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
- **`CommitmentsScreen.move(_:toOffset:)` keeps its shape and changes what its offset means.** It is
  now counted over `kept` as drawn, and the screen derives both the roster's offset and the category
  from it. This is the one signature in the change that is unchanged and not behaviour-preserving,
  which is why it is called out here rather than left to a reader of the diff.
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

### The offset a screen takes is over what it draws

Until this change the commitments screen's kept list and the roster's own order were the same
sequence, so one offset meant one thing. Grouping makes them two sequences, and the delta picks the
drawn one: **a drag happens on what a person is looking at.**

That puts one conversion into `CommitmentsScreen.move` and nowhere else. Given an offset *k* over
the drawn list:

- **the category** is the category of the entry drawn at *k*, or of the last entry drawn where *k*
  is the number drawn;
- **the roster's offset** is the place immediately before that same entry among the commitments the
  roster is keeping, or the number it is keeping where *k* is the number drawn.

Because the moved commitment is under that entry's category once the drop is made, and a group's
entries are drawn in the roster's own order, inserting it immediately before that entry draws it
where it was dropped. The shell still converts nothing and still passes `onMove`'s `Int` through
untouched, which is what ADR-1019's guard requires.

**Two offsets change nothing at all, and the carve-out now covers the category too.** The offset an
entry is drawn at and the one just after it both leave it where it is drawn; the second of the two
names the entry that follows, which may belong to the next group, so applying its category would
turn a drop-where-you-picked-it-up into a refiling. It is carved out at the screen and not at the
roster, because at the roster the offset says *where* and the category says *what*, and only the
first has anything to carve out.

**One consequence is stated in the requirement rather than hidden:** dragging a group's *first*
commitment away moves the group, because a group sits where its first commitment sits. A person who
drags the top row of "Supplements" to the bottom of the screen may see the whole "Supplements" block
follow. That is settled answer 11 read at its edge, not a defect, and it has a scenario.

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

**The kept list becomes one flat `ForEach` over `screen.kept`, not a `Section` per group.** A
`ForEach` per `Section` would hand `.onMove` an offset counted within that section, and the shell
would then have to convert it into an offset over the whole drawn list — a line that can be wrong in
a way a test would catch, which is the one thing ADR-1019's guard forbids. So the group's category
is drawn as a header row inside the same `ForEach`, and the offset passes through untouched exactly
as it does today. Whether SwiftUI's `.onMove` can cross a `Section` at all is therefore not a
question this design has to answer, and `tasks.md` § 9 does not ask it.

**The stopped list keeps its `Section` and gains nothing**, which is what makes "the stopped list is
not grouped" true on a phone rather than only in a requirement.

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
- **The delta is the largest this repo has shipped — 205 scenarios, 129 of them carried verbatim.**
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
- **The form-4 shape guard rests on a `Codable` detail.** `contains(key)` telling `null` from absent
  is measured, not remembered, and the measurement is in § *Context*. → If it stops holding, the
  guard silently weakens rather than failing loudly, so `tasks.md` § 5 writes the two refusal
  scenarios before the happy path.
- **A phone that opens this build and changes nothing keeps a form-3 file for ever.** → That is
  ADR-1031 working as designed, and the "reading changes nothing at its place" scenario is carried.

## Open Questions

**None.** `grill.md` § *Left open* named two, both `spec-author`'s to settle rather than the
human's, and both are settled above:

1. **B-030 is answered by this Story and is still a want in `docs/backlog.md`.** Nothing in the
   delta depends on it; moving it to *Decided* is the next grooming pass's work, and `tasks.md`
   § 10.6 leaves a line for it rather than reaching into the backlog from a Story branch.
2. **An ADR is owed for a category being the roster's** — decided as **ADR-1038** in § *A category is
   the roster's, and ADR-1038*, numbered against every remote branch rather than against `main`
   alone: `main` ends at 1037 and `origin/story/139-add-number-entry` holds 1036, checked with
   `git ls-tree -r --name-only <branch> -- docs/adr` over every remote, 2026-09-08. A second record
   is owed that the grill did not foresee — **ADR-1031 amended in place**, because this change fires
   the reversal trigger that ADR wrote for itself.

## Questions for you

Two questions came up while the delta was being written that the grill could not have reached from
the answers it had. **The delta is written on the recommended answer to each**, so what follows is
read against the diff rather than in the abstract.

1. **A drop that lands exactly on the seam between two groups — which group has it joined?** The
   place immediately after the last row of "Supplements" and immediately before the first row of
   "Sport" is one offset, and it can mean either group. The offset alone cannot say, so something has
   to decide.
   - *Recommended:* **the group below** — a row takes the category of the entry it comes to stand
     before, and of the last entry drawn when it goes to the end. The seam stays exactly the shape
     `add-roster-order` fixed: one offset, the gesture's own arithmetic, no conversion in the shell.
     The cost is one unreachable slot — a row already last in "Supplements" cannot be dropped onto
     the very top of "Sport", because that offset is one of the two that mean "where you picked it
     up"; a person gets there by dropping it below "Sport"'s first row instead.
   - *If you say the drop should carry the group it landed in:*
     `CommitmentsScreen.move(_:toOffset:)` gains a category argument, the four boundary scenarios in
     *A commitments screen moves a commitment among the ones it keeps* are rewritten, the shell has
     to name the section a drop landed in — which means a `Section` per group after all, and § *The
     shell rides this Story* is rewritten with it. Nothing else in the delta moves.
   - **The grill could not plainly have asked this.** It only becomes visible when a grouped drag is
     expressed as a single offset, which is a question about the seam rather than about the product.

2. **Which categories does the form offer — the ones commitments you are *keeping* are under, or
   also ones only a *stopped* commitment is under?** Settled answer 7 says "the categories in use are
   exactly the words on the roster's commitments", and a roster holds commitments in three states.
   - *Recommended:* **the ones you are keeping.** The offering exists so a typed word lands on an
     existing heading, the stopped list draws no headings, and a stopped commitment brings its own
     category back with it when it is taken up again in one tap — so nothing is lost by leaving it
     out, and a word from a list nobody is looking at is not offered.
   - *If you say stopped ones too:* the offering rule in *A commitments screen puts a commitment
     under a category* changes, three of its scenarios are rewritten, and the roster gains a read
     over the commitments it *holds* rather than the ones it keeps. A removed commitment's category
     would still be left out, which then needs saying.
   - **The grill could plainly have asked this**, and that is worth recording for the next one: the
     answer says "the roster's commitments" at a point where the roster holds three states, and the
     ambiguity is visible in the answer's own words.
