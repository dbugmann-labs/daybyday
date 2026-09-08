# Grill — add-commitment-category

*23 questions over 6 rounds, 2026-09-08 — two of them asked after `spec-author`'s residual round,
because the owner's reply to it opened a frontier node the grill had not reached.*

## Settled

1. **A category is the person's own word, not one the app names.** Typed the way a
   commitment name is typed. *No fixed menu holds the day-one week — creatine, magnesium,
   nails, public pool, yuno, finances, contact lenses — and `CONTEXT.md` § Commitment name
   already says the words are "the owner's own words rather than the system's".*
2. **At most one category per commitment: none, or one.** *Four lines of the day-one week are
   neither supplement nor habit, so being in no category is a normal state and not a gap;
   several would leave a grouped screen asking which group a row belongs to.*
3. **A category is set on the form that defines a commitment, and changed afterwards.** *B-029's
   trigger says "once, when a commitment is defined; and again whenever a list of them is read",
   and the Story's intent says changeable. The thinner only-afterwards slice was offered and
   declined.*
4. **The category is held by the roster, against each commitment, and never by the commitment.**
   *Not a question at this grill — the fifth grooming pass settled it on ADR-1023's argument: a
   tick embeds the whole commitment by value, so a fifth part a person can change would re-key
   every tick already recorded. ADR-1030 let the kind be a fourth part only because a kind never
   changes; a category does. An ADR is owed for this and is `spec-author`'s to write.*
5. **The form offers the categories already in use.** A person picks one of them or types a new
   one. *Asked because iOS autocapitalises: "Supplements" typed once and "supplements" the next
   time would silently become two groups. Offering what is in use removes the problem rather than
   having the app judge the owner's words — folding case would make the app choose which spelling
   a heading shows.*
6. **A category of nothing but blank space means no category, and is not refused.** *Unlike a
   name, a category is optional, so emptying the field is how a category is taken off. One fewer
   refusal for the screen to hold and say.*
7. **A category with no commitment carrying it stops existing.** The categories in use are exactly
   the words on the roster's commitments. *There is no second list of categories to hold, store,
   or delete a word from.*
8. **There is no rename-everywhere act.** Changing a word across five commitments means retyping
   it on each. *Offered and declined: a rename is a roster act of its own, with its own refusals,
   and it is a want if it turns out to bite.*
9. **The commitments screen groups its kept list by category.** *Recommended against — #146 had
   just made that list's order the person's own — and chosen anyway. It is what B-030 asked for,
   one screen earlier than B-030 asked for it.*
10. **The day screen groups its rows the same way.** *Recommended against as scope, and chosen:
    this Story now spans `commitment` and `day-screen` and answers B-030 outright. See
    § Left open.*
11. **Both screens place groups the same way: a group sits where its first commitment sits in the
    order the person set, and the commitments in no category come last, with no heading.**
    *Ordering the groups alphabetically would be a rule about the owner's own words, which is the
    argument #146 used against sorting the roster at all. Uncategorised-first was recommended, so
    that a screen with no categories yet looks exactly as it does today, and declined.*
12. **A group with nothing due today does not appear on the day screen.** *A day view already draws
    only what is due, so an empty group would be a claim about the day rather than about what a
    person keeps.*
13. **The stopped list is not grouped.** One flat list, as today. *It is not scanned daily, and
    grouping doubles the screen's structure for the list that needs it least.*
14. **Dropping a row under another group's heading gives it that category, and lands it where it
    was dropped.** *Recommended against — it makes a drag mean two things — and chosen: one
    gesture doing what it looks like it does. So a drop is a move and a category change together,
    and the category field is no longer the only way a category changes.*
15. **Dragging a row into the uncategorised rows at the end clears its category.** *Symmetric with
    the drop into a group, and the only drag that undoes a drag.*
16. **The drag is the commitments screen's alone.** The day screen draws groups and changes
    nothing. *#146 put the drag where a person manages what they keep; the day screen is what a
    day asks of you, which "entered where you stand" protects.*
17. **Giving a commitment a category moves it on screen but not in the roster.** A row seventh in
    the order, given a category whose first member sits second, is drawn in that group's block —
    and clearing the category returns it to seventh, where it never stopped being. *Nothing but a
    drag ever changes the roster's order.*
18. **A category may be changed only on a commitment the roster is keeping.** On a stopped or a
    removed one it is refused and said, exactly as moving one the roster is not keeping is. *A
    stopped commitment keeps the category it had.*
19. **Taking a stopped commitment up again with a different category typed on the form takes the
    typed one.** *The person is looking at the form now. Its place and its history are restored as
    they already are; the category is the roster's, so nothing recorded is re-keyed either way.*
20. **Two things were not asked, because the shipped spec already answers them.** A roster keeping
    a commitment still refuses that same commitment offered again, category or no category — the
    category is on the entry, not on the commitment, so it is not part of what makes two
    commitments the same one, and the screen has a control for changing a category. And a category
    is judged for saying something and for nothing else — no length limit, no restricted script,
    no reserved word — because that is what `CONTEXT.md` § Commitment name already says about the
    owner's own words.

21. **While a drag is live, the commitments screen marks the group the row would land under.**
    *The owner's remark at the residual round. It is the screen's answer and not the shell's —
    `CONTEXT.md` § App shell decides nothing — so the screen owes "the category a drop at this
    offset would join". Marking the heading was chosen over saying the word on the dragged row:
    text under a moving thumb is the hardest thing on a phone to read. It exists because the seam
    rule at § Residual 1 is ambiguous by construction, and this is what makes it legible.*
22. **A drag alone can never lift one group above another, and that is accepted for this Story.**
    *Found by reading the delta after the owner asked whether group ordering was possible at all:
    a row dropped at the top joins the first group, so dragging Sport's rows above Supplements
    dissolves Sport rather than lifting it. What works is two steps — drag the row into place,
    then set its category back with the field, which changes no order — so a group's position is
    set by re-labelling. Possible, and not discoverable.*
23. **A draggable group heading is wanted, and is a Story of its own taken immediately after this
    one.** *Recommended as its own Story and agreed. Groups gather: the delta's own
    `a commitments screen draws what it keeps in groups` draws Magnesium beside Creatine over
    Gym, so a group's members need not be adjacent in the order underneath, and moving a group
    means gathering its commitments and relocating them as a block — the first act here that
    moves more than one commitment at once. That needs a grill round of its own (what becomes of
    a group's internal order, what a drop onto the uncategorised block means, what a stopped
    commitment lying between two members does), which is exactly what folding it into a
    205-scenario delta would have skipped.*

24. **The seam answer is reversed: a drop carries the group it landed *in*, not the group below.**
    *Overturned 2026-09-08 at the §9.5 walkthrough, on the phone, by the owner. § Residual 1 chose
    "the group below" on my recommendation, and its stated cost — "one unreachable slot" — was
    under-priced: the offset it makes unreachable is the end of a group, so a person cannot append
    a row to a group at all. The alternative `spec-author` had already priced is taken instead:
    `CommitmentsScreen.move` gains a category argument, the four boundary scenarios are rewritten,
    and the shell draws a `Section` per group. Costs a third G4, taken deliberately.*
25. **Two drawing defects found on the phone and fixed, neither of them a requirement.** The
    category heading was drawn inside the row cell, so it dragged with the row; and the group of
    commitments under no category, having no heading by § Settled 11, ran on continuously from the
    last group so that neither screen showed where a category ended. *A divider is not a word the
    app invented, so § Settled 11 stands — what was missing was a boundary, not a name.*

26. **The cross-group drag is kept, at the price of a hand-written gesture.** *Asked at the second
    residual round, because a `Section` per group — what makes the end of a group reachable —
    probably costs it: `.onMove` names one collection and no overload names two. Recommended
    taking the loss, since refiling keeps a one-tap route on the row while appending to a group had
    none, and § Settled 23's Story would do the custom gesture once for headings and rows together.
    Declined: the drop into another group is the gesture § Settled 14 was chosen for, against
    recommendation, and the owner has not changed their mind about it. So the shell gets a
    `draggable`/`dropDestination` of its own in this Story. Whether that breaches ADR-1019 is a
    measurement rather than a foregone conclusion — a drop target that hands back a group's
    identity and an index it was given is not the shell computing anything — and it is
    `spec-author`'s to make.*

27. **The cross-group drag is given up, after being built twice and walked twice.** *§ Settled 26
    kept it deliberately, against `spec-author`'s recommendation to lose it; it does not work and
    this repository cannot test it. Two facts were measured rather than guessed, and they are the
    inheritance for § Settled 23's Story: **`.onMove` and `.dropDestination(for:)` cannot share a
    `ForEach`** — instrumenting both closures showed `.onMove` winning every long press and
    dropping a drag that leaves its section on the floor, while `.dropDestination` never fired at
    all — and **an abstract `UTType` was not what was missing**: the payload was moved from
    `public.content` to an exported type of the app's own, per Apple's own `Transferable`
    reordering example, and the drag still snapped back. What ships instead is `.onMove`, which
    reorders inside a group through Edit mode, and the **Category** action on the row, which
    refiles across groups and works. `docs/backlog.md` is where the drag goes if it is still
    wanted; #168 is where it is cheapest, because that Story has to build a drag layer for group
    headings anyway.*
28. **Nothing on this machine can drive a drag, and that is the reason this cost two evenings.**
    *The Simulator has no GUI here — `System Events` reports zero windows — and XCUITest's
    synthetic touch never triggered `.dropDestination` in any configuration, with `.onMove`
    present or absent. So every attempt at a gesture is a round trip through the owner's phone.
    Recorded as a fact about the environment rather than about this Story: a want that turns on a
    gesture should be priced with that in it, and `tasks.md` § 9.5 is the only thing that ever
    tests one.*

## The residual round

`spec-author` returned two questions that writing the delta made visible. Both answered
2026-09-08, both on the recommendation, and both folded into `design.md`:

1. **A drop on the seam between two groups joins the group *below*** — a row takes the category
   of the entry it comes to stand before, and of the last entry drawn when it goes to the end.
   *Keeps the seam the one offset `add-roster-order` fixed, with no conversion in the shell. The
   cost is one unreachable slot, reached in two drops instead.*
2. **The form offers the categories the roster is *keeping* commitments under**, not ones only a
   stopped commitment carries. *The stopped list draws no headings, and a stopped commitment
   brings its own category back when it is taken up again in one tap.*

**The second is a finding about this grill.** Settled answer 7 says "the words on the roster's
commitments" at a point where a roster holds commitments in three states, and the ambiguity is
visible in the answer's own words. The first genuinely could not have been asked here: it only
appears once a grouped drag is expressed as a single offset.

## Terms landed in CONTEXT.md

- **Category** — the word a person put a commitment under, held by the roster against that
  commitment and never by the commitment itself; at most one, and a commitment may have none.
- **Roster**, amended — a roster also holds, for each commitment, the category it is under.
- **Roster store**, amended — it keeps that category, and a roster written before categories
  existed reads back with none.
- **Commitments screen**, amended — its kept list is grouped by category, it offers the
  categories in use, and its drag now sets one.
- **Day view**, amended — its rows are grouped by category, and a group with nothing due does
  not appear.
- **Move**, amended — a move made by dropping a row into another group also sets that row's
  category.

## Left open

1. **B-030 is answered by this Story and is still a want in `docs/backlog.md`.** The fifth
   grooming pass parked it behind B-029 and expected it to be its own Story; the day-screen
   answer at Q9 absorbed it instead. Moving it to *Decided* against this Story is the next
   grooming pass's, not this Story's — nothing in the delta depends on it. Recorded here so the
   pass does not have to reconstruct why.
2. **An ADR is owed and is `spec-author`'s**, amending or citing ADR-1023 and ADR-1030: why a
   category is the roster's when the kind is the commitment's. It is not left open in the sense
   of being undecided — the decision is settled at § Settled 4 — only unwritten.

3. **The draggable group heading is a Story of its own** — § Settled 23 — to be written after this
   Story's G4 and taken before #148 `add-commitment-editing`. Nothing in this delta depends on it,
   and this delta's grouping rule is what it will be grilled against.

4. **§ Settled 14 and § Residual 1 are superseded by § Settled 24.** They are left standing rather
   than edited, because what they record is a decision that was made, tested in the hand and
   reversed — and the reversal is only legible next to them.

5. **The reorder lag is unexplained and stays open.** On the phone, a moved row leaves its old
   place empty for about a second before the list settles. The obvious cause is dead: `RosterStore.write`
   measured 13ms and the whole `CommitmentsScreen.move` 16ms, and a recorded simulator reorder
   settles in 0.2–0.4s. It was never judged again, because the gesture stopped working before it
   could be. It belongs to whoever next holds a drag on a real device — § Settled 23's Story — and
   the remaining candidate nobody has excluded is that the rows are keyed by position.

Everything the frontier raised was answered.
