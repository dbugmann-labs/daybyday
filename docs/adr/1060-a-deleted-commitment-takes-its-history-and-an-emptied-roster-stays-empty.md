# 1060. A deleted commitment takes its history with it, and an emptied roster stays empty

- Status: accepted
- Date: 2026-09-23
- Deciders: Diego Bugmann

## Context

ADR-1035 made removal a third state: the roster kept the commitment and every record against it
stood, so no past day lost a row and a roster emptied by removal never read as a first launch.
B-057 — delete a commitment for good, with everything it ever recorded — is the owner reversing
that, decided at the G1 of 2026-09-21 that reopened `FEAT: commitment` (#26) and grilled on
2026-09-23 for `delete-a-commitment-for-good` (#304). A commitment now carries an identity
(ADR-1059), so "everything recorded against it" is something the app can name.

## Decision

**Delete takes remove's place, and the removed state is retired.**

- **A deletion takes every era, the roster place and category, and every tick, number, note and
  addition against any era.** No list, no past day and no look-back holds it afterwards, and there
  is no way back on the phone. It is confirmed by the name typed back, the rule removal used.
- **The record place is written first**, as ADR-1049 orders every two-place change, and a roster
  place that then refuses has the record place put back from what the screen read. A process killed
  between the two writes leaves the commitment listed with no records, never records without a
  commitment, so nothing is left for the orphan carry-back to attach to a look-alike.
- **An emptied roster is marked.** A roster that deletion leaves holding nothing is *emptied*, which
  is not equal to a roster given nothing, and the roster's form carries it. Day one's rule
  (ADR-1027) is unchanged in its letter — it is written only into a roster holding nothing at all —
  and an emptied roster is not one. The mark travels in a copy because a copy nests the roster's own
  form, so a restore gives back an emptied roster exactly.
- **What the state still holds on a phone is erased at the upgrade**, with its records, silently:
  each was confirmed by its name typed back. A roster that leaves holding nothing is emptied. An old
  copy is read the same way.

## Consequences

- The record is no longer untouchable. This is the one act in the product that loses a history, and
  it is the person's act, made against a typed name. *Restore, not sync* is not failed by it.
- Copies made on request before a deletion still hold the commitment; the sheet promises only that
  the copy in Files follows.
- The roster's file reaches a sixth form: `removed` leaves the entry and `emptied` joins the
  document. ADR-1031 governs reading the forms before it.

## Alternatives considered

- **Keep removal and add delete beside it.** Two verbs for one want, and a state nobody asked to keep.
- **Tell an emptied roster by the file's absence rather than a mark.** No form change, but it
  reverses every rule that reads "a roster holding nothing at all" and makes day one hang on a file
  operation rather than on the roster's value.
- **Erase the records after the roster.** A refusal between the two would leave records under no
  commitment, which the orphan carry-back would move onto any commitment alike to it.
