# Grill — add-category-order

*12 questions over 5 rounds, 2026-09-08. Two facts dispatched to agents; none asked of the owner.*

## Settled

1. **Moving a group relocates its commitments as a block inside the roster's one order.** A group
   goes on being a *reading* of that order, nothing is stored for a group, and ADR-1038's rule —
   "a group sits where its first commitment sits in the order the person set" — is untouched.
   *The alternative was a second, explicit order over categories, which would have overturned a
   requirement shipped eight days earlier and left an order entry behind whenever a category's
   last commitment let it go. The price accepted instead is that a group's position stays derived:
   stopping, removing or re-filing a group's* first *commitment can shift the whole group without
   anyone having dragged it. Rare, and always the consequence of an act just performed on that
   very row.*

2. **Everything under the category travels with the group — kept, stopped and removed alike,
   keeping their relative order.** *The single-commitment move passes* over *an intervening
   stopped entry rather than pushing it, so this is deliberately not that rule. It is observable:
   the dated group read draws stopped and removed commitments under their category, so members
   left behind would let a day in January draw the groups in an order the person never set. The
   order the person set is the order every date reads in.*

3. **The move is offered on a group the roster is keeping, and there is no move a person can
   perform that puts a group after the uncategorised.** *Forced by two shipped rules meeting: the
   uncategorised group is appended last by the reading rule wherever its entries sit, and it draws
   no heading at all (§ Settled 11 of #147, confirmed at `CommitmentsView.swift:101-105` — the
   `nil`-category group's header closure produces no view). So it is a real, addressable group in
   the model with no affordance in the shell, and it needs none.*

4. **What a person taps is two actions, `Move up` and `Move down`, stepping the group past one
   neighbour at a time.** *Against a picker naming a destination. Three or four groups is the
   realistic count and stepping reads the same at two groups or seven, with no new sheet to build
   or walk. The requirement takes a* place *either way — up and down are derivable from an offset
   and not the reverse — so this decides the shell and not the delta.*

5. **The actions are drawn with `sectionActions(content:)`, and a control in the heading is a walk
   item rather than a requirement.** *The issue's intent sentence says "dragging its heading"; the
   grill narrowed it twice, on measured facts. There is no documented tappable-heading pattern:
   `Section`'s header parameter is "a view to use as the section's header" with no constraint, so
   a `Button` compiles, but Apple documents nothing about whether it stays hit-testable — and
   `EditMode`'s page is silent on headers, which matters because `EditButton()` is load-bearing
   for the existing row `.onMove`. It would be this app's first interactive header; there is no
   precedent in `src/`. `sectionActions(content:)` is the one documented per-section action
   surface, iOS 18+ and present in the SDK this project builds against (target 26.0, SDK 26.5),
   with the cost stated in Apple's own words: "on iOS, the actions are displayed as items after
   the content of the section" — below the group, not on its heading. Chosen against both a
   heading-only gamble and a documented-only ship:* **build `sectionActions`, walk it, and try a
   heading control on the phone only if the action rows read badly in the hand.** *Whichever wins,
   no requirement moves and no second G4 is owed — the delta says nothing about headings.*

6. **The actions appear in Edit mode only.** *Both order-changing acts then sit behind one visible
   button, and the resting list stays a list of commitments. Discoverability is what this Story is
   for, which is the counter — but* Edit *is a visible control, which the two-step re-labelling
   route it replaces never was.*

7. **The drag is not the gesture, and the drag that #147 gave up does not come back here.**
   *§ Settled 27 of `add-commitment-category` parked the cross-group row drag on this Story
   because this Story "has to build a drag layer for group headings anyway". Settled answer 5
   removed that premise, so the want was captured instead as* **B-041 — put a commitment in
   another group by dragging it there** *(`chore/backlog`, commit `e4d0b28`, PR #178), carrying
   #147's two measurements so a future attempt starts from them. It fails* five percent of seven
   things *on its own entry: the row's* Category *action already refiles across groups in one tap.*

8. **The ~1s reorder settle lag is taken here, as a shell change with no requirement.**
   *`docs/open-questions.md` parks it on this Story and the un-excluded candidate is
   `CommitmentsView.swift:79`, where the kept list's per-group `ForEach` reads `id: \.offset`;
   #147's G7 found that keying was introduced inside its own diff, the flat list before it having
   been keyed on the commitment's own value. This Story moves whole blocks through that line. No
   scenario is about how long a list takes to settle, so nothing enters the delta — it is walked
   on the phone in the same pass as the group move.*

## Terms landed in CONTEXT.md

- **Move**, amended — a move now takes either a commitment or a group. It remains the only thing
  that ever changes a roster's order; moving a group relocates every entry under that category,
  kept, stopped and removed alike, as one block. The 2026-09-08 note under **Move** saying "one
  thing no move can do … it cannot lift a whole group above another … moving a group as one act
  is a Story of its own" is what this Story answers, and is rewritten rather than left standing.
- **Commitments screen**, amended — it also moves a group among the groups it draws, in Edit
  mode, one place at a time; a move it will not make is a **refused change** like every other.
- **Group** — no new entry. It is already named under **Move** and **Day view** from #147, and
  this Story adds no property to it: a group is still worked out on every read.

*Listed here and landed by `spec-author`: the conductor writes one file, and `CONTEXT.md` is in
`spec-author`'s write set. Same division as `add-commitment-category`'s grill.*

## Left open

1. **An ADR is owed and is `spec-author`'s**, on settled answer 2: why a group move carries the
   stopped and removed entries under that category when a single-commitment move steps over them.
   It is not open in the sense of being undecided — it is settled, and only unwritten. It meets
   all three tests: expensive to reverse once orders are on disk, surprising to a reader who has
   just read `Roster.move`, and a real trade-off against the consistency argument. Next free
   number is 1042. ADR-1037 (*a roster's order is the person's*) is the record a group move
   extends and is amended rather than superseded; **ADR-1038 is untouched** — its "a group sits
   where its first commitment sits" survives the block move intact, which is why settled answer 1
   chose the block move.
2. **The issue's intent sentence is now wrong in one clause** — it says the group is moved "by
   dragging its heading", and settled answer 5 replaced the gesture. Rule 4 means the spec wins
   and nothing depends on the issue's wording, so this is recorded rather than repaired; the
   Feature's next tracker pass can correct it if anyone cares. It is not a blocker for G4.
3. **Nothing else.** Every question the frontier raised was answered, and the two questions that
   turned on facts — what SwiftUI can reorder, and what a `Section` header can carry — went to
   dispatched agents and came back before the round that needed them, so no fact reached the owner.
