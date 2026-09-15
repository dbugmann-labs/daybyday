# 1055. A look-back reads a commitment's earlier eras by resemblance, not by a recorded link

- Status: accepted — the owner's decision at the Story grill of `look-back-at-a-tick` (#272) on
  2026-09-15, against the recommendation to accept the era boundary and capture chaining as a want
- Date: 2026-09-15
- Deciders: Diego Bugmann

## Context

Changing a commitment's rhythm, its range or its target **supersedes**: the old commitment is held
removed with the day it was kept until, and the new one is taken on in its place, kept from the next
day. Restarting an every-N-days count does the same. Each of those spans is an **era**, and to a
person they are one commitment — `CONTEXT.md` § *Restarting* says so in as many words, and leaves
"how the two grids read as one run, when anything looks back" to B-007.

**The roster holds no link between them.** That is ADR-1023's consequence reaching supersession: a
record embeds the whole commitment by value, so a part a person can change would orphan everything
recorded against it. The superseded commitment is held exactly as one the person removed — no
identifier, no back-reference — and `openspec/specs/commitment/spec.md` § *A roster supersedes a
commitment it is keeping with another, from a day* guarantees adjacency only at the moment of the
act.

So a look-back over "everything since the day it was kept from" either stops at the boundary, or
works out what stands behind the commitment it was handed. The owner was offered the first, with
chaining captured as a want, and chose the second.

## Decision

**A look-back infers the chain, and nothing is recorded.** Behind a commitment stands the removed
commitment of the same name and the same kind whose day kept until is the day before that
commitment's day kept from; behind that one stands the same again, until none answers. Where more
than one removed commitment answers, the nearest one in the roster's own order wins, which is the
order supersession itself creates. A commitment the roster has not removed ends a chain, so an era
taken up again is where the walk stops.

**The alternative was a recorded link, and it costs a capability.** A fifth thing the roster holds
against each commitment is a change to `Roster`, to `RosterDocument` and to the roster store's form,
with a migration for every phone and a `commitment` delta serialising this Story behind #261 and
#262. It also buys less than it looks: every commitment already superseded on a phone today has no
link to record, so the inference would still have to exist to read them. The inference is the whole
answer or it is not needed.

**The specs already carry one resemblance test**, the orphaned record carried back to its one
possible source, so this is a shape the capability has rather than a new idea.

**The price is named, not hidden.** Two readings are wrong in ways the person cannot see. A
commitment removed and defined again the same day under the same name and kind reads as one chain,
though the person meant two. And a later correction of a kept-from day breaks a chain, because the
adjacency the inference turns on is gone. Both were put to the owner and accepted with the decision.

**Buying it back stays possible and stays expensive.** A recorded link added later would have to be
reconstructed for existing rosters by exactly this inference, so the rule written down here would
outlive the decision to record one. That is why it is a record and not a comment.

## Consequences

- The chain lives in `look-back` and touches no other capability: `Roster.Entry` already carries the
  day kept until and whether a commitment is removed, and reading them needs no new public member.
- A look-back's head says the newest era's rhythm and the earliest era's day kept from, and its list
  says a line in words wherever one era gives way to the next — otherwise a reader would see the due
  counts shift with no word for it.
- Nothing else reads a chain. If a second surface ever wants one, that is the moment to ask again
  whether the link should be recorded, with two readers to pay for it instead of one.
