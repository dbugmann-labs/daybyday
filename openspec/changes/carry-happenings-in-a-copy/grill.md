# Grill — carry-happenings-in-a-copy

*11 questions over 4 rounds, the last the layout round, 2026-10-04; one fact agent.*

## Settled

1. **What a restore says about happenings.** It counts the happenings and the stopped ones, for
   the copy and for the phone, the way commitments are counted; occurrences are not counted.
   *Happenings are a list the person made, so a count of them reads; occurrences pile up into
   dozens and a count of them says little. Birthday ticks count none, and that precedent was
   declined here.*
2. **A copy asked for where the happening place cannot be read.** The copy is refused whole,
   naming the happenings, whether the place is damaged or was written by a later version. *A copy
   without happenings would erase them without a word when it was restored. This matches the
   other four stores.*
3. **Restoring a copy made before copies held happenings.** It reads as holding none, and the
   restore leaves the phone holding none. *A restore makes the phone match the copy and keeps
   nothing of what was there; the counts in 1 show the copy's zero against the phone's count
   before it is confirmed.*
4. **A copy whose happenings do not fit together** — an occurrence of a happening the copy does
   not hold, two happenings with one name — is refused as a damaged copy. *The app never writes
   one, so a file like that has been tampered with or corrupted; restoring part of it would
   silently restore less than the file holds.*
5. **Happening changes write a copy at the copy place, in this Story.** All eight do: making,
   renaming, stopping, resuming or deleting a happening, and noting, changing or taking back an
   occurrence. The "writes no copy" lines in the happening and day-screen specs go. *Otherwise the
   copy place holds stale happenings until the next commitment change.*
6. **The day screen says a copy can be restored when it cannot read its happenings**, as it does
   for the other four, and with the same exception: not where the only store it is not keeping was
   written by a later version. *Now that a copy holds happenings, a restore is a real way out, and
   the screen should say so.*
7. **The take-out carries the happening place, in this Story.** A happening place that cannot be
   read, or was written by a later version, offers a take-out, and every take-out includes its
   file. *Otherwise a damaged happening store is the one with no rescue, and 2 makes it block
   every copy.*
8. **The walk shows four screens**: the restore sheet with happening counts on both sides, the two
   sides different; the commitments screen's happening list right after a restore is confirmed,
   holding the copy's happenings and not the phone's; the day screen over a happening place it
   cannot read, saying a copy can be restored; and Settings offering a take-out because the
   happenings cannot be read. The last two need a damaged happening file planted before the step.
9. **No `phone:` line.** *No step here is a gesture or a feel; the simulator pictures show all
   four screens and the seam tests prove what the copy holds.*

Facts the fact agent found, which these answers rest on. A restore in progress records only the
four places and a save in progress, so it does not undo the happening place today. A restore
already overwrites a store written by a later version, and this Story keeps that. The happening
store is at form 3 and the copy at form 2.

## Terms landed in CONTEXT.md

None new. **Happening store** has a dated amendment: "in no copy until #380" no longer holds.

## Layout

Option A, "One more line", chosen from three at https://claude.ai/artifact/LPikZVcC8Z6SePh7XQdVF4.
*It keeps the restore sheet as shipped and adds one caption line under each side, where the
birthday-tick line already sits; nothing new to build.* The count reads **"3 happening(s), has
stopped 1"**, chosen over "3 happenings, 1 stopped" and "Happenings: keeps 3, stopped 1". Like
"Keeps N, has stopped M", the stopped happenings are not part of the first number. Where the
phone's happenings cannot be read, **"Your happenings could not be read."** replaces the count, in
the form of the other four stores. That wording was the designer's assumption and was not asked.
The other three walk screens need no drawing: the day screen adds the shipped restore line under
"The happenings could not be read.", Settings adds one line to the take-out's list, and the
happening list is unchanged. The wireframe follows, verbatim from the designer.

```
A · One more line
┌──────────────────────────────┐
│ (Cancel)          (Restore)  │
│ Restore this copy?           │
│ Made                         │
│ ┌──────────────────────────┐ │
│ │ 4 Oct 2026 at 9:07 AM    │ │
│ └──────────────────────────┘ │
│ The copy                     │
│ ┌──────────────────────────┐ │
│ │ Keeps 5, has stopped 1   │ │
│ │ 2 one-off(s)             │ │
│ │ <happening count>        │ │
│ └──────────────────────────┘ │
│ Your phone                   │
│ ┌──────────────────────────┐ │
│ │ Keeps 2, has stopped 0   │ │
│ │ 0 one-off(s)             │ │
│ │ <happening count>  or    │ │
│ │ Your happenings could    │ │
│ │ not be read.             │ │
│ └──────────────────────────┘ │
└──────────────────────────────┘
(In A, the count lines are caption size, as shipped. Where a store
can't be read, its line replaces the count, as now.)
```

## Left open

None. Every question the frontier raised was answered, the layout round included.
