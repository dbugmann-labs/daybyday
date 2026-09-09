## Context

See `proposal.md` § *Why* for the motivation and `grill.md` § *Settled* for the eight answers this
delta is written on. What matters here is the state of the code the change lands in, all of it on
`main` as of `fe540d5`, the commit this branch sat on when this section was written — and still true
at **`e0a4f6d`**, where the branch sits for the second G4: `openspec/specs/commitment/spec.md` is
byte-for-byte the same at both, and the two chores and the one Story that landed in between are all
`day-screen` and the shell.

- **`Roster` holds one order over one array of entries.** `Roster.Entry` already carries
  `category: String?` beside the commitment, the day it was kept until and whether it was removed
  (#147). `Roster.groups` and `Roster.groups(on:)` work the grouping out on every read from that one
  array — nothing is stored for a group, and there is nowhere for two readings to drift apart.
- **A group's place is derived.** ADR-1038's rule, shipped eight days ago: *a group sits where its
  first commitment sits in the order the roster holds its commitments*, and the group of the
  commitments under no category comes last wherever the first of them sits. This change does not
  touch that rule; it moves the commitments so that the rule draws the group somewhere else.
- **`Roster.move(_:toOffset:under:)` is the only thing that changes the order today**, and its
  offset is counted over the commitments the roster is *keeping*, over nothing else, with two
  offsets carved out that leave the sequence untouched.
- **`CommitmentsScreen` already holds `keptGroups` and `categoriesInUse`.** `categoriesInUse` is
  `keptGroups.compactMap(\.category)` — exactly the groups this change's offset is counted over,
  already public, already the order the screen draws.
- **The shell draws a `Section` per group with `EditButton()` in the toolbar**
  (`CommitmentsView.swift:238`), and each section's `ForEach` is keyed `id: \.offset`
  (`CommitmentsView.swift:79`).

## Goals / Non-Goals

**Goals:**

- One act at each of the three existing seams that moves a whole group, keeping the roster's single
  order and its single grouping rule.
- A group order that reads the same on every date, which is what forces the block to carry the
  stopped and removed commitments under the category.
- A refusal surface for a group move that is the same shape as the one a commitment's move already
  has, so nothing new has to be learned to read it.

**Non-Goals:**

- **No second order.** Nothing is stored for a group, no order over categories exists, and no
  entry survives a category's last commitment leaving it. That was the alternative the grill
  refused (`grill.md` § *Settled* 1).
- **No change to the grouping rule.** ADR-1038 is untouched, and no requirement of `day-screen` is
  carried in this delta — a group move changes what the roster answers with, not how anything draws
  it.
- **No new form on disk.** A group move rearranges entries that already carry everything it needs, so
  `RosterDocument` stays at form 4 and ADR-1031 is not reached.
- **No gesture in the delta.** The requirement takes a place; up, down, a picker or a dragged heading
  are all derivable from it and none of them is.

## Decisions

### The seam

**No new seam and no new type.** Three existing seams gain one member each, and one existing enum
gains one case. Every scenario in the delta is driven at one of these:

- **`Roster.move(group category: String?, toOffset offset: Int) -> Bool`** — the whole of the block
  move. `String?` rather than `String` deliberately: the roster reads back a group whose category is
  `nil`, so "move that one" is a thing a caller can mean, and refusing it in the open is worth more
  than making it unsayable. A category of nothing but blank space normalises to `nil` through the
  same `Blank` test every other category goes through (ADR-1039) and is refused with it.
- **`RosterStore.move(group category: String?, toOffset offset: Int) throws -> Bool`** — the same
  shape as `move(_:toOffset:under:)`: it writes before it reports, it reports what the roster
  reports, and it writes nothing when the roster came back unchanged.
- **`CommitmentsScreen.move(group category: String?, toOffset offset: Int) -> Refusal?`** — the same
  shape as `keepAgain`. Its guards are its own (`categoriesInUse`), so the roster's two refusals are
  never reached through it.
- **`CommitmentsScreen.RefusedChange.movingGroup(String, Refusal)`** — a seventh case, carrying the
  category. The only `Refusal` reachable through it is `.notKept`.

`Roster.Entry`, `Roster.Group`, `RosterDocument`, `CommitmentCoding`, `DayView` and `DayScreen` are
untouched, and so is every existing member of the three types above.

### A group move is a block move, and ADR-1044

**Every commitment under the category travels — kept, stopped and removed alike.** A commitment's
move does the opposite with what lies in its way: it *passes* a stopped or removed commitment rather
than pushing it, and that carve-out is written into the shipped requirement three times over. A
reader who has just read `Roster.move` will expect the same here, so the difference is worth an ADR
rather than a paragraph. **ADR-1044** is written in this diff.

The argument is not symmetry, it is that the other choice is observably wrong. `Roster.groups(on:)`
draws the commitments the roster had not stopped keeping on a date, each under its category, and a
group sits where its *first* commitment sits — so a stopped member left behind at the group's old
place would go on anchoring that group there. Move *Supplements* below *Sport* today, and January
still draws *Supplements* first. There is one order and it is the person's; a group order that only
holds for dates after the move is not one.

Alternatives considered and dropped: **move only the kept members** (breaks the paragraph above);
**move only the group's first commitment**, which is all the *grouping* rule strictly needs (leaves
the rest of the group scattered where they were, so the flat reads and every past date disagree with
what the person just did); **a second order over categories** (`grill.md` § *Settled* 1 — it would
overturn ADR-1038 and leave an order entry behind whenever a category emptied).

### Where the block is put, and why the tap is honoured rather than the past date

The block goes immediately before **the first commitment the roster is keeping under the category of
the group that stood at the offset**, or immediately after **the last commitment under the category
of the last group kept under one**, in any state, where the offset is the number of them. The first
is measured over the commitments the roster is keeping; the second is not, and does not need to be.

**This is the reverse of what this section said when the delta was first written, and the reversal is
the point of the second G4.** As written, both branches were measured over every commitment under the
target category in any state, and the argument was the one this design gives for the block travelling
whole one level up: place before the target group's first *kept* commitment while a stopped one under
that same category sits earlier in the order, and today draws the moved group before the target while
a past date draws it after. That argument is sound and nothing has been found wrong with it. What was
missing is its price, and the price is larger than the thing it buys.

Both anchors were measured exhaustively, over every four-entry roster across three categories with
every kept-and-stopped combination:

| anchor | lands where the offset named | today-vs-past-date disagreements it introduces |
|---|---|---|
| the target group's first commitment in any state | **18 of 4788** accepted moves land somewhere else, silently — nothing refused, roster written | none, ever |
| the target group's first **kept** commitment | all **5838** accepted moves land where the offset named | **102**, about 1.75%, every one through the before-the-first branch |

The minimal wrong landing is four entries: `[A-stopped, A-kept, A-kept, B-kept]`, move group `B` to
offset 0. The offset names "before `A`" and the roster is written with `B` after `A`, because the
anchor was a commitment the person cannot see. The minimal disagreement is the same four entries
under the other anchor: today reads `[B, A]`, a date before the stop reads `[A, B]`.

**A wrong landing is wrong on the screen the person is looking at, every time it happens. An ordering
nuance on a past date is visible only when they scroll back to one.** So the offset is counted over
the kept, categorised groups — the ones a person can see — and the block is placed against the target
group's first kept commitment, and the requirement states the past-date consequence rather than
leaving it to be met. **ADR-1044** is amended in place with the same reasoning and the same numbers.

The after-the-last branch is the one place the old anchor survives, and not by inertia: after the
last of a group is after every commitment under it whichever way it is measured, so that branch
landed right and agreed with every past date under both anchors. Measuring it over the kept ones
would only split the target group's own block around the arriving one, for nothing.

Neither lookup can miss, and not for the same reason. The "after the last" branch is only reached
when the offset is the number of groups kept under a category, and that offset is the carve-out
whenever the moved group is itself the last of them — so the group being measured against is never
the one just taken out. The "before the first" branch is only reached for an offset that is neither
the moved group's own nor the one after it, so the group at that offset is never the moved one
either — and it has at least one kept commitment left to anchor against, because being in the count
the offset runs over is exactly what having one means.

### The offset counts the headed groups, and that is why nothing lands after the uncategorised

`grill.md` § *Settled* 3 says there is no move a person can perform that puts a group after the
uncategorised, and it is forced rather than chosen: the reading rule appends that group last wherever
its commitments sit, and it draws no heading at all (`CommitmentsView.swift:101-105`). Two ways to
honour it were available — count the offset over every group and refuse the ones past the
uncategorised, or count over the groups under a category and have no such offset exist. The second
wins, because a refusal a person cannot reach is a rule nobody reads, and because an offset past the
uncategorised is not merely undrawable: it would move the block *behind* the uncategorised entries in
the order the roster holds, changing the flat reads while changing nothing anyone sees. That is
exactly the silently-wrong-thing the roster's other refusals exist to prevent.

The count also excludes a category only a stopped or removed commitment is under. That is the same
line `Roster.move`'s own offset draws — the list a person is looking at when they move something is
the list of what they keep — and it makes `CommitmentsScreen.categoriesInUse` and the roster's own
count the same list, which is what lets the screen pass the offset straight through.

### The two offsets that gather nothing

On the offset a group is at and the one just after it, nothing is taken out of the sequence at all.
For a commitment's move that carve-out exists so a no-op cannot walk a row past a stopped one; here
it exists so a no-op cannot **gather** a scattered group. A group whose commitments are interleaved
with another's comes back contiguous from any real move, and that is unavoidable — but "put it back
where it was" must not be a change, or a person who taps *Move up* and then *Move down* would find
they had rearranged the list by doing nothing.

**The consequence is stated in the requirement rather than hidden:** up-then-down does *not* restore
the roster, because the first of the two gathered the group. It is the block move's own arithmetic.
The alternative — gathering on the no-op offsets too, so that both directions behave alike — makes
every accidental tap a write, and was rejected on that.

### The refused change names a category, and it is the seventh kind

Five of the six existing kinds name a commitment. A group move has no one commitment to name: a
person tapped a heading, and naming the group's first row would point at something they did not
touch. So `movingGroup` carries the category, and the requirement says in as many words that this is
the first kind naming something other than a commitment. The alternative — reusing `moving` with the
group's first commitment — would make the shell draw "could not move Creatine" under a heading the
person moved, which is ADR-1036's *name a cause a person can act on* read backwards.

### What a group move does not touch

It puts nothing under anything: every commitment travels under the category that named the group, so
unlike a commitment's move this act carries no category argument at all and cannot be a second way
one changes. It takes no date, records none, and changes no commitment, no kept-until day and no
state. Nothing is re-keyed, so every record already made stands — the point ADR-1038 bought when it
put the category on the roster rather than on the commitment.

### The shell rides this Story

Under ADR-1019's 2026-09-04 exception, and with no requirement attached to any of it:

- **`sectionActions(content:)` on each categorised section, with `Move up` and `Move down`.**
  `grill.md` § *Settled* 5 measured the alternatives: there is no documented tappable-`Section`-header
  pattern, `EditMode`'s documentation is silent on headers, and a header `Button` would be this app's
  first interactive header with no precedent in `src/`. `sectionActions` is the one documented
  per-section action surface, and Apple's own words name its cost — on iOS the actions are drawn
  *after* the section's content, not on its heading. The decision was to build that, walk it on the
  phone, and try a heading control only if the action rows read badly in the hand. **Either outcome
  moves no requirement and owes no second G4**, because the delta says nothing about headings.
- **Edit mode only** (`grill.md` § *Settled* 6), so both order-changing acts sit behind the
  `EditButton()` already in the toolbar and the resting list stays a list of commitments.
- **Up and down are computed from the section's index in `screen.categoriesInUse`** — up is
  `index - 1`, down is `index + 2`, and the actions are drawn only where the target offset is one the
  screen has. The shell counts no rows and asks where no finger is.
- **The reorder settle lag** (`docs/open-questions.md`, 2026-09-08) is walked in the same pass. The
  un-excluded candidate is `CommitmentsView.swift:79`'s `id: \.offset`, and this Story moves whole
  blocks through that line. No scenario is about how long a list takes to settle, so nothing about it
  enters the delta and nothing about it is promised.

## Risks / Trade-offs

- **A group move reorders commitments the person did not name.** → Inherent to one order and one
  block move; the requirement states exactly what is promised (everything that stays keeps its order
  against everything else that stays) and exactly what is not (where the leftovers sit relative to
  the block). Six MODIFIED requirements exist so no shipped sentence goes on claiming otherwise.
- **Up-then-down is not an undo for a scattered group.** → Stated in the requirement and walked on
  the phone. A group is scattered only where the person interleaved two categories by hand, and the
  first move makes it contiguous for good, so the surprise happens at most once per group.
- **A move can make a past date draw the groups in an order today does not.** → Chosen over the
  alternative at the second G4, not overlooked: it happens only where a stopped or removed commitment
  under the *target* group lies earlier in the order than that group's first kept one, it was
  measured at about 1.75% of accepted moves over the exhaustive four-entry space, and the anchor that
  avoids it lands 18 in 4788 accepted moves at a place the offset never named, silently. The
  requirement states it and a scenario of its own pins it. § *Where the block is put* has the numbers.
- **Six restated MODIFIED requirements are six chances to change a shipped sentence by accident.**
  → Each was extracted verbatim from `openspec/specs/commitment/spec.md` and edited only where the
  Story makes it false; `tasks.md` § 1.1 names the exact edits, and no carried scenario is renamed,
  dropped or reworded. `openspec validate --strict` and `pnpm run checks`' scenario coverage are the
  mechanical check on that.
- **A category only stopped commitments are under cannot be moved, and is still drawn on a past
  date.** → Accepted, and it is the same line every other roster refusal draws. Such a group's place
  is wherever its commitments sit; taking one up again brings it back into a roster whose groups have
  since been reordered, exactly as a stopped commitment already returns to a list that has moved on.
- **The screen passes the offset through, so a shell bug lands as a wrong group order rather than as
  a refusal.** → The screen's own guards (`categoriesInUse` membership and `0...count`) catch every
  value that names nothing; what they cannot catch is a valid offset naming the wrong group, which is
  what the walkthrough is for.

## Open Questions

**Every question `grill.md` § *Left open* carried is answered here, and none is outstanding.** No
residual round was raised: writing the delta turned up no question the grill could not have reached.

1. **The ADR owed on the block move — written, not open, and it is 1044 rather than 1042 or 1043.**
   `grill.md` § *Left open* 1 called it settled and unwritten and named **1042** as the next free
   number, which it was when the grill ran. It has been overtaken twice by chores merging while this
   Story was being written, each time collided on `docs/adr/README.md`'s table alone — outside the
   change folder and outside `openspec/specs/`, so ordinary merge work rather than the rule-5 stop.
   **#177** took 1042 for *the horizontal swipe belongs to the day*, and **#185** took 1043 for *a day
   change pages under the finger*, so this one is **1044**. Numbers are never reused (ADR-1020), gaps
   are normal, and `grill.md` is the conductor's file, so its "1042" is left standing and corrected
   here rather than edited there. **ADR-1044** is in this diff and is amended in place with the
   placement decision § *Where the block is put* records; ADR-1037 is amended in place too: a move is
   still the only thing that changes a roster's order and it now takes a group as well as a
   commitment. **ADR-1038 is untouched**, which `tasks.md` checks rather than assumes.
2. **The Story issue's intent sentence is wrong in one clause — recorded, not repaired.** It says the
   group is moved "by dragging its heading", and `grill.md` § *Settled* 5 replaced the gesture. Rule 4
   settles it: issues carry no requirements, the spec wins, and nothing in this change reads the issue
   body. It is not a blocker for G4 and the Feature's next tracker pass can correct it.
3. **Why a reordered row leaves its old place empty for about a second on the phone is still open**,
   and it stays open after this Story unless the walkthrough happens to answer it.
   `docs/open-questions.md` parks it here and this change walks the one un-excluded candidate, but no
   requirement in this delta is about how long a list takes to settle and none is proposed. If the
   walkthrough finds the cause, it is a shell fix on this branch under ADR-1019 and the entry is
   closed; if it does not, the entry stands as it is. Either way the delta is unchanged, which is why
   this is deferrable rather than a question for the owner.
4. **Nothing else.** The frontier the grill left had two items and both are above; writing the six
   MODIFIED requirements and the two ADDED ones raised no third.
