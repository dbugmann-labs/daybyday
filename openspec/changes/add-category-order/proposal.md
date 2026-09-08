## Why

A person who has just put their commitments into categories can order the rows inside each group and
cannot order the groups. The heading a thumb reaches first is decided by wherever that category's
first commitment happens to sit, which is an accident of when it was taken on — so *Supplements*
sits under *Money* on the morning screen because a bill was added in March, and the only way to fix
it is to move rows one at a time until the accident comes out right.

**This Story is not promoted from a want.** It was cut by `add-commitment-category`'s own grill,
which named the gap in the sentence `CONTEXT.md` § *Move* still carries — *"it cannot lift a whole
**group** above another … moving a group as one act is a Story of its own"* — and it is what that
sentence is answered by. `FEAT: commitment` (#26) is the Feature it hangs off, and #147
(`add-commitment-category`) is the blocker that closed first, because the groups this change moves
are the ones that Story made.

The grill settled the shape in one sentence: **moving a group relocates its commitments as a block
inside the roster's one order.** Nothing is stored for a group, ADR-1038's rule that *a group sits
where its first commitment sits* is untouched, and the second, explicit order over categories — the
obvious alternative — is refused, because it would have overturned a requirement shipped eight days
earlier and left an order entry behind whenever a category's last commitment let it go.

## What Changes

- **A roster moves a group**, on being given the category naming it and an **offset** counted over
  the groups it is keeping that are under a category. That is a second thing a move takes: a move
  now takes either a commitment or a group, and between them they remain the only thing that ever
  changes a roster's order.
- **Everything under the category travels as one block — kept, stopped and removed alike**, keeping
  its relative order. This is deliberately *not* the single-commitment rule, which passes over an
  intervening stopped entry rather than pushing it, and the difference is observable: the dated group
  read draws stopped and removed commitments under their category, so a member left behind would let
  a day in January draw the groups in an order the person never set. **ADR-1043** records it.
- **A group's commitments are gathered.** A category whose entries are scattered through the order
  comes back contiguous, so a group move can reorder other commitments against the moved group's own
  — everything that stays keeps its order against everything else that stays, and nothing more is
  promised. That is the price of one order over one roster, and it is stated rather than hidden.
- **The group of the commitments under no category is not a group a move can name**, and no offset
  puts a group after it. Two shipped rules force it: the uncategorised group is appended last by the
  reading rule wherever its entries sit, and it draws no heading at all. Counting the offset over the
  groups *under a category* is what makes that true by arithmetic rather than by a refusal a person
  could hit.
- **A roster refuses exactly two group moves and reports each** — a category no commitment it is
  keeping is under (including no category at all), and an offset outside the groups it is keeping
  that are under one. Not clamped, for the reason every other roster refusal is not.
- **A commitments screen moves a group among the groups it draws**, and keeps it at the roster place
  before the list says so. A group it draws none of, and an offset those groups do not have, each ask
  for no change: it does nothing and says nothing, exactly as it already answers a move of a
  commitment it does not keep. A group move it could not keep is the **seventh** kind of refused
  change, and it names the **category** rather than a commitment, because the category is what a
  person tapped and what they can act on.
- **What a person taps is `Move up` and `Move down`** — two actions stepping the group past one
  neighbour, in Edit mode, drawn with `sectionActions(content:)`. That is the shell and not the
  delta: up and down are derivable from an offset and not the reverse, so the requirement takes a
  place and the shell decides the gesture. **No requirement moves if the control ends up on the
  heading instead**, which is why the Story's intent sentence — "by dragging its heading" — is
  recorded as wrong in one clause rather than repaired (`grill.md` § *Left open* 2, rule 4).
- **The drag that #147 gave up does not come back here.** That Story parked its cross-group row drag
  on this one, on the premise that this one had to build a drag layer anyway; the premise is gone, so
  the want was captured as **B-041** instead.
- **The ~1s reorder settle lag is taken here as a shell change with no requirement.**
  `docs/open-questions.md` parks it on this Story, the un-excluded candidate is
  `CommitmentsView.swift:79`'s `id: \.offset`, and this Story moves whole blocks through that line.
  No scenario is about how long a list takes to settle, so nothing enters the delta.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `commitment`: a roster moves a group among the groups it is keeping, and a commitments screen
  moves one among the groups it draws; a roster store keeps a group move at its place and passes its
  two refusals through; a commitments screen holds a refused group move as its seventh kind. Two
  requirements are added and six are modified — the four that say in so many words that moving a
  *commitment* is the only thing that changes the order or that there are six changes a person can
  ask for, plus the roster store and the screen's own move.

### Not modified

- `day-screen`: a day screen hands on the groups its roster answers with and a day view draws them
  in the order it was handed them. A group move changes what the roster answers and nothing about
  either rule, so not one `day-screen` requirement becomes false. That is the same load-bearing
  claim #147 made and it is checked, not assumed.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/` — `Roster`, `RosterStore` and `CommitmentsScreen` each gain
  one member. No new type, no new file, and `Roster.Entry`, `Roster.Group`, `RosterDocument` and the
  form on disk are all untouched: a group move rearranges entries that already carry everything it
  needs, so **the roster file stays at form 4** and no store reads a new shape.
- `src/DayByDay/DayByDay/CommitmentsView.swift` — `sectionActions` on each categorised section, under
  ADR-1019's 2026-09-04 exception, plus the `id: \.offset` keying the reorder lag is parked on. The
  shell passes the section's own category and an offset derived from its index; it counts no rows and
  computes nothing else.
- `docs/adr/` — **ADR-1043** written. **ADR-1037** amended in place: a move is still the only thing
  that changes a roster's order, and it now takes a group as well as a commitment. **ADR-1038 is
  untouched** — "a group sits where its first commitment sits" survives the block move intact, which
  is the whole reason the block move was chosen.
- `CONTEXT.md` — **Move** amended (a move takes a commitment or a group, and the 2026-09-08 clause
  saying a group move "is a Story of its own" is rewritten rather than left standing), **Commitments
  screen** amended. **Group** gains no entry: it is already named, and this Story adds no property to
  it.
- **Not touched:** the `record` and `schedule` capabilities, `Commitment` itself, every record already
  made, and the grouping rule. A group move changes an order and nothing else.
