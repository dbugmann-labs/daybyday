# 1021. A day screen without its record draws the day and refuses every tick

- Status: accepted — the decision was the owner's at the third grooming pass's Feature grill on
  2026-09-03; this record is written by `add-day-screen` (#91), the change that first implements it
- Date: 2026-09-03
- Deciders: Diego Bugmann

## Context

`record` already decided what happens when a store cannot be read: it is **refused rather than
emptied**. `openspec/specs/record/spec.md` says it in as many words — opening throws, nothing at the
place is overwritten, moved or deleted, and not even the readable part is kept, so that whatever is
there survives for a person or a later version of the app to recover. "An honest error on opening is
the failure the product can survive; a record silently replaced by an empty one is the failure it
exists to remove."

That settles the *store*. It does not settle the *screen*. `add-day-screen` (#91) is the first thing
that opens a store from inside the app, and a screen cannot simply propagate a throw: a person who
taps the app icon gets something on the display, and what that something is has to be decided.

The condition is not exotic. `docs/open-questions.md` § *Known gaps* records that
`RecordStore.init` can throw for reasons that have nothing to do with a damaged file — a store
protected by iOS data protection when the app is launched in the background before the device's
first unlock is the clearest, and it clears itself the moment the person unlocks the phone. A store
written by a later version of the app is another, and a person who has restored a backup from a
newer install meets it. Neither means the record is gone.

Three answers were available.

**Refuse to open at all.** The screen shows an error and nothing else. Honest, and it makes the
failure impossible to miss. It also means the app is useless at exactly the moment the failure is
most likely to be transient: the person who launched before first unlock sees an error page instead
of their day, on a record that is intact.

**Draw the day and accept ticks into memory, keeping them when the record can be opened again.**
The friendliest-looking answer. It is also the one that manufactures the failure this product was
built to remove: a tap is one interaction on a phone, and a screen that shows a tick as made is a
promise it was kept. If the store never opens — the file really is damaged — the person has spent a
week ticking a record that was thrown away at every quit, and they find out by having nothing.

**Draw the day and refuse every tick.** The day is a pure function of the commitments and the date;
it needs no record to be worth looking at, and a person can still see what they owe themselves. No
tick is accepted, so nothing is ever shown as kept that is not on the disk.

## Decision

**A day screen opened where the record cannot be read still opens.** It holds the day view of its
day, formed from a history that has taken no tick, and it says separately that it is not keeping a
record. Every tick made on it changes nothing, is kept nowhere, and is not held in memory to be
written later. What is at the place is left byte for byte as it was.

Every way a store can refuse to open is treated in this one way. The screen does not tell them
apart.

**The condition is not permanent.** Showing the app again re-opens the store, so a screen that
opened before first unlock starts keeping a record as soon as the person unlocks the phone and
returns to the app — without a force-quit, which is the recovery step nobody thinks to take.

## Consequences

- **A person always gets their day.** The commitments due, in order, drawn from rules that need no
  record. The app is never a blank error page.
- **No tick is ever shown as kept unless it is on the disk.** The day view a person reads is never
  ahead of the record, which is the same guarantee `record` gives for the store and the reason this
  answer was chosen over accepting ticks in memory.
- **Taps are silently ignored on such a screen.** That is the cost, and it is real: the screen must
  say it is not keeping a record clearly enough that a person does not sit tapping. The seam
  provides the fact; drawing it is the shell's, and `docs/open-questions.md` § *No UI smoke layer*
  means nothing automated proves the shell drew it.
- **Every row says "not kept" when nothing is known.** A day view has two states per row and no
  third, and adding one would modify a requirement signed on 2026-09-02 for a case nothing else in
  the product has asked for. The screen carries the missing information beside the day view instead.
  This is the surprising part, and it is why this record exists: a reader meeting a screen full of
  unticked rows over an unreadable record should find the reason here rather than assume a bug.
- **The reason a record could not be read is not carried, for now.** The screen says only that it
  could not. Adding the reason later takes nothing back — a flag becomes something richer — and it
  would also close `docs/open-questions.md` § *Known gaps*, "`RecordStore.init` can throw outside
  `RecordStoreError`", which this decision leaves open deliberately.
- **Reversal trigger.** If a person is ever observed losing work to a store that would not open
  transiently — ticking into a refusing screen for a whole session — the answer is not to accept
  ticks in memory but to make the refusal harder to miss. Accepting them is the one answer this
  record rules out for good, because it trades a visible failure for a silent one.
