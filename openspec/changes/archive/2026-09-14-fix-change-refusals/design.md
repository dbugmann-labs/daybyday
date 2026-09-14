## Context

See `proposal.md` § *Why* and `grill.md`, whose six settled answers this delta is written on.
These facts, read off this worktree, decide the shape.

- **`Rhythm` carries no interval start.** `Rhythm(_:)` drops it, and `Rhythm.schedule(keptFrom:)`
  builds an interval from the day kept from. `CommitmentsScreen.change` builds the changed
  commitment's schedule that way on the same-rhythm path. It builds the commitment it carries
  records over to that way too, before it supersedes.
- **So an interval whose start differs from its day kept from never equals its own rebuild.** A
  save with nothing changed therefore reaches the carry-over rather than the no-op. So do a rename
  and a category change.
- **`History.carryOver` answers `Bool`** and refuses for either cause. It checks "the target already
  holds records" before it checks due dates. The screen maps every `false` to
  `.wouldLeaveARecordedDayNotDue`.
- **`History.carryOver` does not refuse where the source holds no record**, even if the target holds
  some. So the screen cannot learn from it that such records exist.
- **Nothing on a commitments screen can create an interval whose start differs from its day kept
  from.** `define` sets both to one day. Such commitments exist only where a roster was written
  another way, such as the seeded Nails.
- **No shipped scenario and no test expects the not-due refusal for a target that holds records.**
  The three tests asserting `.wouldLeaveARecordedDayNotDue` fixture a record place with no stray
  records.

## Goals / Non-Goals

**Goals:**

- The screen gives the true cause for both kinds of refusal, at the existing seam, without changing
  what a history or a store answers.

**Non-Goals:**

- **No repair of records that sit under no commitment** (`grill.md` item 3; `save-change-whole`,
  #249).
- **No naming of the blocking day** (B-050), and no change to any refusal already specified.
- **No change to `record`.** `History.carryOver` and `RecordStore.carryOver` keep their contract and
  their tests.

## Decisions

### The seam

`CommitmentsScreen.change(_:toName:on:keptFrom:under:)` is unchanged in signature, and every scenario
is driven through it. Two package-internal reads are not seams; they are listed so the diff is
expected.

- `case recordsAlreadyExist` — added to `CommitmentsScreen.Refusal`
- `func holdsRecords(of commitment: Commitment) -> Bool` — internal, on `History`
- `func datesRecorded(for commitment: Commitment) -> Set<CalendarDate>` — internal, on `History`

### An unchanged day kept from keeps the schedule it has

On an interval rhythm, where `keptFrom == commitment.keptFrom`, the changed commitment takes
`commitment.schedule` as it is. Only a different day rebuilds the interval from that day. The
commitment carried to before a supersession follows the same rule. `grill.md` item 1 names only
"leaves the rhythm alone". But item 5 says "only an unchanged kept-from day keeps a grid's own start",
and it is general. Without it, a rename plus a new rhythm on Nails would still be refused.
Rejected: giving `Rhythm` a start date. That widens a public value no sheet can fill, because the
form has no such field.

### The not-due cause is judged first, then the records already kept

The screen reads the dates the source holds records on. It asks the carry target whether each is
due, and refuses as not due if any is not. Only then does it refuse `recordsAlreadyExist`, if the
record place holds any record of the target. Then it carries over as today. Not-due goes first
because the shipped refusal requirement already says a change "SHALL be refused" as not due wherever
a recorded day would be left not due. `grill.md` item 4 keeps that as it is, and this order leaves
that requirement untouched. Rejected: records-already-kept first. It is one check simpler, but it
needs a MODIFIED to a refusal that was settled to stand.

### Refused whether or not the source holds records

A commitment with no records, renamed onto a name the record place holds records of, would otherwise
take those records over silently. That is an in-app repair of records a torn save left behind, which
`grill.md` item 3 rules out. So the screen checks the target on every change that names a new name or
day, not only where `History.carryOver` fails. Rejected: refusing only where the source holds
records. It matches the `record` rule, but it lets a rename adopt records that belong to no
commitment.

### A widened carry-over was rejected

`grill.md` § *Left open* leaves the choice between a widened `History.carryOver` and a check the
screen makes first. The check wins. A three-way answer would change `RecordStore.carryOver`, its
`record` requirement and every test that asserts its `Bool`, just to serve one caller. It also could
not report the case in the previous decision, where the history does not refuse.

### Two requirements are ADDED, and the long ones are left alone

*A commitments screen works out which act a change on either of its lists needs* and *…refuses a
change it cannot make* are both past the ADR-1047 word budget. Neither holds a sentence this change
falsifies, so both gain a sibling rather than more words. The floor requirement is MODIFIED in one
clause. `grill.md` item 5 reads "MUST NOT shift the schedule's own start date" as contradicting a
change that moves it. My reading is that the sentence speaks of the floor alone. The settled answer
wins, so the clause now says the floor itself shifts nothing, and a change naming a different day
does.

### The shell's words, and no ADR

`CommitmentsView.swift`'s `refusalText` gains `case .recordsAlreadyExist: Text("Records already
exist under that.")`, in the words of `grill.md` item 6. No ADR: every rule here is a spec sentence,
and none reverses a recorded decision.

### Migration

None. No persisted type and no encoding changes, and records on a phone read as before.

## Risks / Trade-offs

- **An implementer fixes only the same-rhythm path.** → The superseding scenario on Nails fails
  unless the carry target keeps its start too.
- **An implementer checks for records already kept only where `carryOver` fails.** → The rename
  scenario with no records of its own fails.
- **An implementer reuses `carryOver`'s internal order**, which refuses as records already kept
  first. → The last scenario asserts the not-due refusal where both causes hold.
- **The owner's phone file still holds stray records** until the one-off repair (`grill.md` item 3),
  so the new refusal is what that phone will show until then.

## Open Questions

None. `grill.md` § *Left open* is "None.", and the one design choice it deferred is decided above.
Writing the delta turned up two edges: the order of the two causes, and a commitment with no records
renamed onto a name that has some. Settled answers 3 and 4 already decide both, so neither needed
the owner, and no `## Questions for you` round is outstanding.
