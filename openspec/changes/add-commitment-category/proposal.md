## Why

A person keeps a dozen things and reads them as one undifferentiated column, twice a day. The
day-one week is four supplements, three habits, a monthly money task and a pair of contact lenses,
and nothing on either screen says which is which — so the eye that wants "did I take everything
this morning" has to walk the whole list and remember what belongs to that question.

**B-029** is the want — *"put my commitments into categories"* — **B-030** is the one the grill
absorbed — *"see my commitments grouped by category"* — `FEAT: commitment` (#26) is the Feature
this Story hangs off, and #146 (`add-roster-order`) is the blocker that closed first, because the
order this change draws groups against is the one that Story made a person's.

**A category is the owner's own word, and it is the roster's rather than the commitment's.** No
fixed menu holds the day-one week, so the app names none: a category is typed the way a name is
typed, and the screen offers the words already in use so that a phone's autocapitalisation cannot
quietly make *Supplements* and *supplements* two groups. And it is held by the roster, against each
commitment, exactly as the day a commitment was kept until is — because a tick embeds the whole
commitment by value, so a fifth part a person is expected to change would re-key every tick already
recorded the moment they changed it. **ADR-1038** records that, because ADR-1030 let the *kind* be a
fourth part on the commitment and a reader who meets it should be sent to the difference rather than
left to infer one.

## What Changes

- **A roster holds a category against each commitment, or none**, and **puts a commitment under
  one** — a fifth act beside taking one on, stopping keeping one, removing one and moving one. It is
  offered only on a commitment the roster is keeping; on a stopped or a removed one it is refused
  and reported, exactly as a move is. A category made only of blank space **is** no category and is
  not refused, which is how one is taken off.
- **A roster reads its commitments back in groups**, one per category, and this is where the one
  grouping rule in the product lives. A group sits where its first commitment sits in the order the
  person set, the commitments under no category come last as a group with no category, and within a
  group the commitments are in the roster's own order. It answers the same way about a date.
- **Both screens draw those groups and neither invents one.** *A day view is in the order it was
  handed its commitments* is therefore untouched, which is the load-bearing claim of the whole
  design: the grouping is handed in, so the day view goes on ordering nothing of its own. A group
  with nothing due on the date is not drawn at all — that rule is the day view's, because it is
  about what a date asks of you.
- **A commitments screen gives a commitment a category and takes one off**, on the form that
  defines one and on the kept list afterwards, and **offers the categories already in use** rather
  than asking for the word twice. A category change it could not keep is the **sixth** kind of
  refused change.
- **Its kept list is drawn in groups; its stopped list is not.** The stopped list is one flat list,
  as today, because it is not what a person reads daily and grouping would double the structure of
  the list that needs it least.
- **The drag now means two things.** A row dropped into another group's block is moved to where it
  was dropped **and** put under that group's category; a row dropped among the commitments under no
  category is moved and has its category taken off. One gesture doing what it looks like it does. So
  a commitments screen's offset is counted over **what it draws** — the grouped list — and the
  screen turns that into the roster's own offset and the category, which is the one conversion this
  change adds and it is behind the seam.
- **While a drag is live, the screen answers which group the row would land under**, and nothing is
  drawn for that answer today: a live drag publishes no destination the app shell could read, so the
  group a drop would join is known and not yet shown. It is the same arithmetic the drop itself
  uses, read instead of acted, so the answer can never promise something the drop then does not do.
  It exists because a drop on the seam between two groups joins the one below, which is a rule that
  had to pick a side and which a person cannot see until they have let go.
- **The form's category wins when a commitment is defined again.** Taking a stopped or a removed
  commitment up again *through the form* takes the category typed on the form, including none;
  taking one up again from the stopped list in one tap asks for nothing and so keeps the category it
  had.
- **The roster file moves to form 4**, with a `category` on every entry — `null` where there is
  none — and a roster written at any of the three earlier forms reads back with every commitment
  under no category, in the way one written before a commitment carried a kind reads back as a tick.
  That is a **fourth form**, which is the reversal trigger ADR-1031 named for itself, so **ADR-1031
  is amended in place** rather than quietly stretched.
- **The shell rides this Story**, in its own `tasks.md` section, under ADR-1019's 2026-09-04
  exception: a category nobody can type and a group nobody can see would not meet the Story's
  stated intent.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `commitment`: the roster holds a category against each commitment, puts a commitment under one,
  and reads its commitments back in groups; the roster store keeps the category at a fourth form
  and reads all three earlier forms; the commitments screen draws its kept list in groups, offers
  the categories in use, gives and takes off a category, counts a move's offset over what it draws,
  says which group a drop at an offset would join, and holds a refused category change as its sixth
  kind. Three requirements are added and twelve are modified.
- `day-screen`: a day view is handed its commitments in groups, draws them in the order it was
  handed them, and draws no group with nothing due on the date; a day screen hands over the groups
  its roster answers with. One requirement is added and two are modified.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/` — `Roster` (a category on its entry, `put`, `groups`,
  and a category on `move`), `RosterDocument` (form 4, a `category` field), `RosterStore`,
  `CommitmentsScreen` (which also answers where a drop would land), `DayView`, `DayScreen`. Three
  new nested types — `Roster.Group`, `DayView.Group` and `CommitmentsScreen.Landing`. No new file.
- `src/DayByDay/DayByDay/CommitmentsView.swift` and `ContentView.swift` — the category field, the
  categories offered, and both grouped lists, under ADR-1019's exception. **The drag mark is the one
  shell task that may end in a report rather than a line**: SwiftUI publishes no in-flight
  destination for a `List` reorder — measured — so `tasks.md` § 9.6 finds out and stops rather than
  moving the drop arithmetic into the shell to get there.
- `docs/adr/` — **ADR-1038** written, and **ADR-1031 amended in place** on the trigger it named
  itself. **Not** amended: ADR-1030 (the kind is still the commitment's fourth part and still never
  changes; ADR-1038 says why a category is not a fifth), ADR-1037 (a move still changes the order
  and nothing else does), ADR-1027 (a roster with categories is still not an empty one).
- `CONTEXT.md` — **§ *Day view*'s 2026-09-08 amendment is corrected**: the grouping is handed to a
  day view rather than made by it. Everything else the grill landed stands.
- **Not touched:** the `record` and `schedule` capabilities, `Commitment` itself, `CommitmentRecord`,
  `History`, `Tick`, `RecordStore`, `RecordDocument`, and every tick already recorded. That a
  commitment stays four things is the finding this change rests on, not an omission.
