# 1065. A happening carries an identity from its first form

- Status: accepted — taken while the delta of `add-happening` (#375) was written, on 2026-10-02;
  this record is written by that Story and approved at its G4
- Date: 2026-10-02
- Deciders: Diego Bugmann

## Context

A happening is a name and nothing else (`CONTEXT.md` § *Happening*), and it can be renamed. What it
holds are its occurrences, which `note-occurrence-on-day-screen` (#376) adds after this Story: each
one has to say which happening it is an occurrence of, and has to go on saying so after a rename.

The one-off is the nearest shape on disk, and a one-off is its name and its date: two alike in both
are one one-off, and a rename is a different value. The commitment started that way too, and
ADR-1059 is what it cost to change: a rename that formed a second commitment and carried every
record over, refusing outright if any could not re-form, then a new form of the roster store, a fold
for every roster already on a phone, and four capabilities moved at once.

## Decision

**A happening carries an identity, given once when it is made, never derived from its name, never
changed by a rename and never shown. Two happenings are the same happening exactly when their
identities are the same.** It is in the happening store's first form, so no phone ever holds a
happening without one. A rename is an act on the identity: the happening keeps its place and,
from #376, its occurrences, with nothing carried over.

Whether two happenings may share a name is a separate rule, decided at the Story's grill: they may
not, judged as a roster judges a commitment's name. The identity is what lets that rule be about
names alone, rather than also being what tells two happenings apart.

## Consequences

- **An occurrence can be keyed to the identity** from the first Story that writes one, and a rename
  never touches the record of when a happening came.
- **A copy carries the identity** once #380 puts happenings in one, so a restored happening is the
  same happening with the same occurrences.
- **The store refuses an identity that does not read as one, and two happenings with one**, as it
  refuses two with one name.
- **Nothing a person sees changes.** The identity is never drawn, typed or compared by a person.

## Alternatives considered

- **Equality over the name, as a one-off has.** Simplest today; #376 would then either re-key every
  occurrence on a rename or add the identity in a second form, which is ADR-1059 paid again.
- **The name as the key, with a rename forbidden.** The grill settled that a happening is renamed.
