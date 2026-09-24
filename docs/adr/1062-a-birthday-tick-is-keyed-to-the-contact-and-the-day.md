# 1062. A birthday tick is keyed to the contact and the day

- Status: accepted — decided by the owner at the grill of `add-birthday` (#326) on 2026-09-24, on
  the recommendation; this record is written by that Story and approved at its G4
- Date: 2026-09-24
- Deciders: Diego Bugmann

## Context

A birthday is the calendar's and its tick is the app's (`CONTEXT.md` § *Birthday*). The app keeps
the tick in a store of its own and has to find it again the next time the calendar hands the same
birthday over — on the next opening, after the contact is renamed, after the contact is deleted and
put back, and after a copy is restored on a new phone.

What the calendar hands with each occurrence is its title, which carries the name and the age in
the phone's language, the day it falls on, and the identifier of the contact it was made from. The
owner decided at the Feature grill (B-059) that a tick follows the contact: a renamed contact renames
the row and keeps its tick, and a deleted contact takes the ticked row with it. Apple documents the
contact identifier as unique **on the current device** only, and the calendar's own external
identifier for a birthday is built from it, so it inherits the same limit. Whether an identifier
survives a new phone is unmeasured and cannot be measured from one machine.

## Decision

**A birthday tick is held against the contact's identifier and the day the birthday falls on, and
nothing else.** The words are no part of it; the day carries the year, so each year's birthday takes
a tick of its own.

**A tick is held until it is taken back.** A tick whose birthday the calendar no longer hands is kept
unseen, and ticks that birthday again if the calendar hands it again under the same contact and day.
Nothing asks the calendar what the store should hold.

**There is one key and no second.** A copy restored on a new phone may therefore hold ticks whose
identifiers match nothing there; those ticks draw nothing, and the spec and this record say so
rather than paper over it.

## Consequences

- **A rename keeps its tick**, and a birthday is still a value equal over its words, so a renamed one
  is a new value carrying an old tick.
- **A deleted contact's ticks stay on the phone** and in every copy, unseen. A contact put back under
  the same identifier brings its ticked rows back. No record here goes without a deliberate act.
- **A new phone may show past birthdays unticked** where the identifiers did not survive. That is
  the whole of the loss: the birthdays themselves are the calendar's, and arrive with it.
- **The store is an identifier and a date per tick**, with no words and no switch, so no name is
  written to it.
- **Reversing it costs a new form of the store**, a tick requirement and its scenarios, and a
  migration for every tick already kept.

## Alternatives considered

**A second key beside the identifier** — the words, or a name parsed out of them — matched when the
identifier finds nothing. Rejected: the words are in the phone's language and change on a rename, so
the fallback would be wrong exactly when it was needed, and two keys can disagree.

**The words and the day as the key.** Survives a new phone wherever the name did. Rejected: a renamed
contact loses its tick, against the owner's call that the tick follows the contact.

**Pruning ticks to what the calendar hands.** Keeps the store to live birthdays. Rejected: a contact
deleted by mistake and put back would lose its history, and the store would have to ask the calendar
what to hold.
