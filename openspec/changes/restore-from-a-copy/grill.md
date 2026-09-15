# Grill — restore-from-a-copy

*16 questions over 3 rounds, 1 fact agent, 2026-09-15. Every answer was the recommendation except 13.*

## Settled

1. **What is said first.** The copy's moment, and counts of what the phone holds against what the
   copy holds. *A stale copy is told from the right one without opening anything.*
2. **Confirming.** One destructive tap beside cancel, no typing back. *Picking the file is already
   the deliberate first step.*
3. **A copy in earlier forms.** Restored, and the three stores are written in the forms the app
   writes now. Only a copy from a later version is refused. *A months-old copy stays usable after an
   update.*
4. **A restore that fails partway.** All or nothing: the three stores are exactly what they were,
   and it says why. *A half-restored phone is worse than no restore.*
5. **A store here that cannot be read.** Restore is still offered. The notice says what is there
   cannot be read and goes whole, in place of its counts. *Restore is the answer to that store.*
6. **How a refused restore is shown.** The commitments screen's existing refused change, naming the
   reason; the phone left as it was. *One way the screen says no.*
7. **A copy of what goes.** None is made. *The notice is the safeguard, the copy row sits above, and
   "never yesterday" was settled at the Feature grill.*
8. **A copy of nothing.** Restored; it empties the phone and the notice says everything goes and
   nothing comes. *#266 made a copy of nothing a copy.*
9. **§7 order.** #267 goes now and merges after #261 (past G4, same screen and `commitment` spec),
   rebased; #262 serialises behind #267 rather than ahead. *#261 only ADDs and leaves the refused
   change alone; a spec conflict on rebase is still a rule-5 stop.*
10. **The day screen after a restore.** Returning to it shows exactly what the copy holds at once —
    all three stores re-read — and drops what it was saying about the phone as it was. *Old
    one-offs over a restored roster is a mixed phone, which 4 rules out.*
11. **The commitments screen after a restore.** The restored lists; what it was awaiting (removal,
    confirmation, the name typed back, a refused change) dropped; and one line naming the copy put
    back by its moment, lasting as long as a refused change does. *The lists cannot say it worked
    when the copy matches what was there.*
12. **The counts.** Kept and stopped apart, beside one-offs, on both sides — e.g. *3 kept, 1
    stopped, 2 one-offs → 4 kept, 0 stopped, 1 one-off*. *Stopped is still history that goes.*
13. **A damaged `.daybyday`.** A reason of its own, told apart from a file that is not a copy — the
    owner's call against the recommendation to fold both into "not a copy". Four reasons in all:
    not a copy, damaged copy, from a later version, a store that could not be written.
14. **Not a copy against damaged.** The envelope decides: a file that does not read as a copy's own
    form and moment is not a copy; one that does, with anything inside it unreadable, is damaged.
    The extension plays no part. A copy whose own form, or any store's form within it, is later
    than the app reads is *from a later version* — stated at round 2 and not contested.
15. **The walk.** Five simulator shots: the copy section with the restore row; the notice with the
    moment and kept/stopped/one-off counts both sides; the commitments screen after a restore with
    its line; the day screen returned to, showing the copy's contents; the refusal of a damaged
    copy. Whether the shots begin past the system file picker, if XCUITest cannot drive it, is
    `spec-author`'s to settle.
16. **The phone.** One `phone:` line: make a copy and save it to Files, change something, pick that
    copy through the file picker, check the counts, restore, and see both screens come back as
    they were.

Not asked, taken as the only reading: cancelling the picker or the notice changes nothing and
leaves no trace; the picker offers only `.daybyday` files (#266 settled 10); the restore row sits
in the copy section #266 put at the foot of the commitments screen (#266 settled 5). The day
screen's line that a copy can be restored is #270's by its intent, not this Story's.

## Facts found, carried to spec-author

- **Nothing makes three stores all-or-nothing today.** Each store writes its file `.atomic` on its
  own (`RecordStore.swift:312`, `RosterStore.swift:101`, `OneOffStore.swift:144`). `SaveInProgress`
  spans record and roster only, records a carry between two commitments rather than a snapshot,
  and cannot undo a restore. Only `RosterStore.replace(with:)` (`:242`) replaces a whole value;
  record and one-off stores have none. Settled 4 needs a mechanism.
- **The copy decoder is partial.** `CopyDocument` (`currentVersion = 1`) is `Codable` and
  `formCopy()` rebuilds a `Copy`, used only in `CopyTests.swift`. It has no later-form check and
  decodes nested store documents without the stores' per-form shape guards. The stores read every
  form 1…current and throw `laterForm` / `notAStore` (record 5, roster 4, one-offs 1).
- **`.daybyday`** is declared in `src/DayByDay/Info.plist` as `UTExportedTypeDeclarations`,
  `com.dbugmann.daybyday.copy`, conforming to `public.json`. No `fileImporter`, document picker or
  security-scoped access exists anywhere in `src/`.
- **Screens.** The commitments screen is pushed from the day screen's toolbar inside a
  `NavigationStack` and re-created on each tap. `DayScreen.returnedTo()` re-reads the roster and,
  only if kept, the record — not one-offs — and does not clear `notice` or `nameRefusal`
  (settled 10 changes that). `CommitmentsScreen.shown` clears `refusedChange`, `awaitingRemoval`
  and `nameTypedBack` but not `awaitingConfirmation`. `RefusedChange` has 9 cases including
  `makingACopy(Copy.Store?, Refusal)`.
- **§7.** #261 holds a G4 marker and draft PR #281, no implementation yet; its delta ADDs to
  `commitment` only and leaves the refused-change requirements (`commitment/spec.md:2268`, `:4962`)
  unchanged. #262 has no change folder. #266 MODIFIED both refused-change requirements; if this
  delta does too, `design.md` should say it merges after #261 and that #262 follows this Story.

## Terms landed in CONTEXT.md

No new entry. One amendment, dated 2026-09-15 at this grill:

- **Restore** — what is said first, one tap, offered whatever the stores hold, earlier forms put
  back in today's, whole or nothing with no copy of what goes, the four refusal reasons with
  **not a copy** and **damaged copy** told apart by the envelope, and both screens showing the copy
  at once with the commitments screen naming which copy was put back.

## Left open

None. Every question the frontier raised was answered. How settled 4 is made atomic across three
files, and whether the walk can drive the system file picker, are facts and design for
`spec-author`, not preferences of the owner's. No ADR was written at the grill; the all-or-nothing
mechanism is the likely candidate, and `spec-author` judges it at the delta.
