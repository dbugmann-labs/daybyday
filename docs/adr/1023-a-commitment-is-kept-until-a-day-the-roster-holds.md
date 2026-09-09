# 1023. A commitment is kept until a day, and the roster holds that day

- Status: accepted
- Date: 2026-09-03
- Deciders: Diego Bugmann
- Amended: 2026-09-09 — changing a commitment is answered without a mutable part: a rename and a
  corrected kept-from day carry the records over to a second commitment, a rhythm change supersedes
- Amended: 2026-09-07 — a commitments screen hands the day *before* the one it was handed, for a
  stop and for a removal alike; the kept-until day itself is unchanged

## Context

ADR-1013 gave every commitment a day it is **kept from** and put that day on the commitment itself,
because it is a fact about the commitment rather than about its schedule. It closed by ruling the
other end of the window explicitly out of its own scope:

> **An end date is not implied and is not decided here.** A floor is not a window. Nothing has asked
> for the other side of one, and a commitment that has been stopped is a different idea from one
> that has not started.

Something has now asked. B-013 — *"stop keeping a commitment"* — is one of the three wants
`FEAT: commitment` (#26) took forward at G1, and `add-roster-retirement` (#102) is the Story that
builds it. The obvious shape is the symmetric one: a fourth part on `Commitment`, `keptUntil`,
beside the three it already has.

**That shape destroys the record.** `Tick` embeds the whole `Commitment` value rather than a
reference to one, and `History.isKept(_:on:)` answers by re-forming a tick and testing set
membership — so two commitments are the same commitment to a history exactly when they are equal,
and `Commitment`'s `Hashable` is synthesised over all of its parts. Adding a fourth part means that
the moment a commitment is stopped, it stops being equal to the value every tick already recorded
against it embeds. Every one of those ticks becomes unreachable and the history reads empty for that
commitment, on every day it was ever kept. In a product whose single promise is that what you
actually did survives, stopping the gym would erase two years of going to it.

The reasoning was first written down on #26 at G1, on 2026-09-03, as the decision that Feature turns
on. It is recorded here because it is the kind of thing a later reader will try to "fix": the
asymmetry between the two ends of a commitment's life is visible in the type and its reason is not.

## Decision

**A commitment is kept until a calendar date, and the roster that holds the commitment holds that
date. `Commitment` does not change.**

Four things are part of the decision rather than incidental to it:

- **The commitment stays three things** — a name, a schedule and the day it is kept from — so its
  identity never moves, and every tick recorded against it stays reachable whatever the roster later
  does. A stopped commitment goes on answering `isDue(on:)` exactly as it did.
- **The kept-until day is the last day the commitment was kept**, inclusive: a commitment kept from
  A and kept until B was kept on every date from A through B and on none after B. The alternative
  reading — the first day it is *not* kept — would make the day a roster holds mean something other
  than what its name says, in the one place a person can be shown it.
- **A commitments screen hands the day before the one it was handed** — amended 2026-09-07, at the
  grill of `add-roster-removal` (#145), and reaffirmed by the owner after its cost was stated. Which
  day a screen *hands* is a separate question from what the day *means*, and only the first of the
  two moved. It shipped as the day the screen was handed, so a commitment stopped this afternoon
  kept its row on this afternoon's day screen, which reads as a stop that failed on the one screen
  whose purpose is to make the change. The price, taken knowingly: a tick made this morning on a
  commitment stopped this afternoon is not drawn today, though the record of it stands untouched and
  the row returns on that day if the commitment is ever taken up again. A commitment defined and
  stopped on the same day becomes one kept on no day at all, which the roster already accepts as
  what changing your mind before starting looks like. On the first date the calendar supports there
  is no day before, and the screen hands that day itself rather than refusing — a floor is not
  something a person can act on, and no device presents that date. Removing a kept commitment hands
  the same day for the same reason; removing one already stopped moves nothing, because the day it
  was kept until was visible on a list and a removal is not an occasion to change it.
- **Only the roster judges it.** Asked what it was keeping on a date, a roster subtracts the
  commitments whose kept-until day falls before that date and applies nothing else — not a
  commitment's own kept-from day and not its schedule, which stay ADR-1013's and `schedule`'s. One
  rule lives in one place, which is the property ADR-1013's own *Alternatives considered* refused to
  give up.
- **A day once given does not move while the commitment stays stopped.** A roster refuses to stop a
  commitment it has already stopped, and reports the refusal, so no second stop can slide a boundary
  a person cannot see — the same promise ADR-1013 makes about a past day's answer. One thing clears
  a kept-until day, and it is the person taking the commitment up again, below.

## Consequences

- **Stopping costs the record nothing.** Every day before the kept-until day answers exactly as it
  did, every tick stands, and a day view of a date inside the kept span still draws the row. This is
  the whole point.
- **The two ends of a commitment's life live in different places**, and that is the price. A reader
  meeting `Commitment` finds `keptFrom` and no `keptUntil`, and has to come here to learn why. The
  compensation is that the asymmetry is real rather than arbitrary: the day you started is a fact
  about the commitment, and the day you stopped keeping it is a fact about your keeping of it.
- **Retiring needs something that holds commitments**, which is why `add-commitment-roster` (#101)
  had to land first, and why a roster must refuse a commitment it already holds: two commitments a
  person would call identical could not be told apart to stop one of them.
- **Taking something up again is the same commitment**, offered to the roster exactly as it was. The
  roster drops the kept-until day, the commitment returns in the place it was taken on in, and its
  history is the one it always had. There is no separate un-stop: offering it is the act, and the
  roster reports that it now keeps it. The price is that the dates between the stop and the
  taking-up go back to answering that the commitment was being kept, because a roster holds one
  kept-until day per commitment and no span of them — a model nothing has asked for. Weighed against
  the alternative, where a mis-tapped stop has no way back and starting again means a different
  commitment with a fresh history at the end of the order, the owner chose this on 2026-09-03 at the
  grill of #102. Nothing here touches the record: every tick stands, so what was actually done on
  those days is unchanged and a gap still shows as days that were never ticked.
- **Storage has one more thing to keep.** `add-roster-store` (#103) persists the kept-until day
  beside the commitment. It is one optional date per commitment and needs no change to what a tick
  is.
- **A third state joined the two.** `add-roster-removal` (#145) added **removed** beside kept and
  stopped, and it rests entirely on this record: a removed commitment carries a kept-until day and
  is answered about a date exactly as a stopped one is, and it stays off `Commitment` for the reason
  this ADR gives about `Tick`. ADR-1035.
- **ADR-1013 does not move.** It said the end date was not its to decide, so nothing in it becomes
  wrong; this record is the answer to the half it left open, and the two are read together.
- **Changing a commitment is answered on this record rather than against it.** `add-commitment-editing`
  (#148) took B-014 — the want ADR-1030 named as this record's revisit trigger — and the answer is
  *not* that a commitment gained an identity of its own. It still has none, no part of one is mutable,
  and the argument above stands exactly as written. What a person calls "changing a commitment" is two
  acts, and each meets the mechanism above rather than working around it:

  - **A different name, or a different day kept from.** A second commitment is formed, every record of
    the first is **carried over** to it — `record`'s own requirement, all of them or none — and the
    roster then puts the second where the first was. Nothing is orphaned, because after the carry-over
    every record embeds a commitment the roster still holds. The carry-over refuses outright where any
    record could not be a record of the second commitment, which is what stops the kept-from day being
    moved forward over a day someone recorded against.
  - **A different rhythm.** Nothing is carried over at all. The roster **supersedes**: the old
    commitment is kept until the day before, held **removed**, and the new one is taken on in the place
    it held. Every past day answers against the value it was written against, because that value is
    still in the roster. This is the same shape a stop already has and it needs no new state.

  Two prices are taken knowingly. The roster holds **no link** between a superseded commitment and the
  one that replaced it, so one commitment's record across a rhythm change cannot be read as a single
  run, and once records exist against both values the link cannot be reconstructed. And **removed** now
  covers a commitment the roster superseded as well as one a person got rid of, which widens a word
  that describes an act the person did not perform.

## Alternatives considered

**A fourth part on `Commitment`, `keptUntil`.** The symmetric, obvious shape, and the one a reader
will propose again. Rejected on the mechanism above: `Tick` embeds the commitment by value, so the
fourth part changes the identity of every commitment the moment it is set and orphans every tick
already recorded. **This is not softened by a history now being able to carry its records over**
(2026-09-09, above): a carry-over is a deliberate act with a refusal of its own, asked for by a person
who is changing something and answered before the roster is written. A part that changed on its own
would fire it implicitly, from wherever the part was set, with nothing to refuse into. Making it work would mean either giving `Commitment` an identifier — which
`openspec/specs/commitment/spec.md` forbids in as many words, and which `add-commitment-roster`'s
duplicate refusal is built on the absence of — or excluding the new part from equality, which is a
value that lies about what it is.

**Forget a stopped commitment entirely: the roster drops it.** The cheapest thing to build, and it
satisfies "no longer due and no longer listed". Rejected because it fails the other half of the same
sentence: every past day would lose that commitment's rows, so the record of what you kept for two
years would disappear on the day you stopped keeping it.

**Keep the day on the commitment but key ticks by something narrower.** Re-keying `Tick` to a
commitment's name and schedule, say, would let a fourth part change without orphaning anything.
Rejected as a much larger change to a signed capability (`record`), made for the benefit of a
symmetry — and it would reintroduce, inside `record`, exactly the ambiguity between two
identical-looking commitments that the roster exists to prevent.
