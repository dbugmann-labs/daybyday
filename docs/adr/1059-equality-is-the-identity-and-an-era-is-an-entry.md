# 1059. Equality is the identity, and an era is an entry

- Status: accepted
- Date: 2026-09-22
- Deciders: Diego Bugmann

## Context

ADR-1023 gave `Commitment` three parts and refused a fourth, because `Tick` embeds the whole value
and `History` answers by set membership: a part that could change would re-key every record the
moment it changed, orphaning a history on the day a person changed anything about what they were
keeping. Every Story since has built on that refusal rather than around it — ADR-1030 put the kind
on the commitment only after showing it never changes once set; ADR-1035 kept *removed* off the
commitment for the same reason it kept *kept until* off; ADR-1055 chose to infer a rhythm change's
chain by resemblance because recording a link was a change to `Roster`, to `RosterDocument` and to
the store's form that a superseded commitment already on a phone would still need inferring for.

B-058 — *"change a commitment and still have one commitment, with one day it is kept from"* — is
the want that finally named the cost directly, at the tenth grooming pass's grill of
`FEAT: commitment` (#26) on 2026-09-21. A rename forms a second commitment and carries every record
over to it, one an all-or-nothing act that refuses outright if any record could not re-form; a
rhythm, a range or a target change supersedes, holding the old commitment removed and taking on a
new one in its place. Four symptoms trace to the same root: a rename's *Kept from* reads as the
rename's own day rather than the day the person first started; a look-back's chain has to be
inferred rather than read; two commitments formed separately but alike in every part are one
commitment to `Hashable`, which the roster's duplicate refusal already has to work around; and nothing
on the roster or in the record can answer *is this the same thing the person has always been
keeping* without walking the inference again. Value equality was never wrong for what it answered
in `add-commitment-roster` (#101) — whether two commitments are indistinguishable — but the product
has since started asking a different question, *is this the one the person has been keeping*, and a
value cannot answer that once a value it can be recorded against is asked to change.

## Decision

**A commitment carries an identity, given once when it is first formed and never derived from, never
changed by, and never shown alongside anything else about it. Two commitments are the same
commitment exactly when their identities are the same, however alike or unalike their names,
schedules, days kept from and kinds; two formed separately are two, however alike every other part
is.** `Commitment.Hashable` compares the identity alone, so `Tick`, `RecordedDay`, `Roster`'s own
`firstIndex(where:)` and the day screen's rows all key on it with no change of their own — which is
why `record` and `day-screen` move so little for a change this size.

**An era is an entry, not a fourth part and not a list a commitment owns.** The roster already
holds one entry per era, newest first; what makes an entry an earlier era of a commitment is
another entry carrying the same identity ahead of it in that same list. Renaming writes the new
name across every entry that carries the identity; changing the rhythm, the range or the target
puts a new entry on, carrying the day the one it replaces was kept until; moving the day a
commitment is kept from moves the earliest entry's own day, dropping any era it would leave holding
no day. Every one of those is an act on the identity, not a second commitment taking the first's
place, so nothing is carried over and nothing is refused for a record that would land on an
identity the roster no longer holds.

**A look-back reads the chain rather than inferring it.** Every entry carrying an identity is that
commitment's own era, in the order the roster already holds them, so ADR-1055's resemblance walk —
same name, the same kind's sort, kept until the day before the era in front — is retired along with
the two readings it named as wrong in ways a person could not see: a same-day remove-and-redefine
reading as one chain, and a corrected kept-from day breaking one. Neither can happen once the chain
is read off a link the roster actually holds.

**The identity is never shown.** It answers *is this the same thing*, a question nothing on either
screen asks in words; a name is still how a person tells one commitment from another, and the
roster's duplicate refusal is now a refusal on the name alone, against a commitment it keeps or has
stopped keeping, rather than on a value.

## Consequences

- **`Tick`, `RecordedDay` and every lookup already written against a commitment move for free.**
  Each already compared or hashed a `Commitment`; none reads a fourth part or an era list, so
  giving `Hashable` a narrower answer is the whole of what they need.
- **A rename and a rhythm change stop costing a second history.** One commitment, one identity,
  one chain a look-back reads whole — the four symptoms above are answered directly rather than
  worked around.
- **ADR-1023, ADR-1030, ADR-1035 and ADR-1055 are amended in place, one dated line each, rather
  than rewritten.** Each recorded a real decision for the value-equality world it was written in,
  and each remains the reason something built on top of it is still true — ADR-1030's kind still
  never changes once formed, ADR-1035's *removed* still lives on the entry rather than the
  commitment, for the reason each gives. A reader of any of the four must reach the amendment to
  learn that the ground moved; `give-a-commitment-an-identity` (#303) is where it did.
- **A roster kept on a phone before this predates identities and is folded once**, at the first
  open after the upgrade: an entry this document keeps or has stopped keeping becomes a commitment
  of its own, and a removed entry adjacent to one by name, kind-sort and day becomes an earlier era
  of it rather than staying a value nothing links to. The fold is silent and, where a removed entry
  resembles nothing live, erases it with every record against it — the owner's own call, against
  the recommendation to hold it stopped instead, taken knowing what it erases.
- **The way back from *removed* narrows.** ADR-1035 said the way back was defining the identical
  commitment again — the same name, rhythm, day kept from and kind, exactly. Under an identity that
  no longer reaches it: only the same identity is the same commitment, and a name matching a
  removed one now takes on a new commitment rather than restoring the old. A commitment removed
  after this lands is unreachable until `delete-a-commitment-for-good` (#304) turns *removed* into
  a deletion, which is the gap this record accepts rather than the one it closes.
- **A fifth part is still one compile error away from silently changing nothing about equality.**
  `Commitment` is not `Codable` in a way that derives `Hashable`; `identity` is declared first and
  compared alone, so a reader adding a field cannot make it load-bearing for equality by accident
  the way a synthesised conformance would let them.

## Alternatives considered

**A commitment owns its eras as a list.** The other shape a chain could take: `Commitment` grows an
`eras: [Era]` and the roster holds one entry per identity rather than one per era. Rejected because
it moves the range and the rhythm of a past day behind a lookup by date — every caller of `isDue`,
every number entry's range, the day screen's rows and the tests behind all of them would have to
ask *which era, as of when* for a model the person never sees. The roster already orders entries
and already reads them one at a time; a second, parallel ordering inside the commitment answers the
same question twice.

**Exclude the new field from equality, keeping the other four and adding an identity as a fifth.**
Considered and rejected on the same ground ADR-1023 rejected a fourth part that changed: a value
whose declared parts disagree with what `Hashable` actually compares is a value that lies about
what it is, and the next reader to add a `switch` over every stored field would be right to expect
equality to follow.

**Derive the identity from the other four parts, so two commitments alike in everything are the
same commitment.** The cheapest-looking shape, and the one a hash of the name, schedule, kept-from
day and kind would give for nothing. Rejected because it answers the wrong question at the one
moment it matters: two commitments a person forms separately, alike in every part by coincidence or
by two rows of "Nails" days one and eight apart, must be two, and a derived identity could never
tell them apart from one renamed, rescheduled and moved back to where it started.
