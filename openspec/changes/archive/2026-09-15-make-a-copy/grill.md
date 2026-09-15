# Grill — make-a-copy

*11 questions over 2 rounds, 1 fact agent, 2026-09-15. Every answer was the recommendation.*

## Settled

1. **A store that cannot be read.** The copy is refused whole; the ask stays on the screen and
   the refusal names which store. *A copy is the whole of a history and never part of one; the
   way an unreadable file leaves the phone is #270's take-out, not a partial copy.*
2. **Nothing kept yet.** A copy is always offered, and a copy of three empty stores is a copy.
   *Putting it back empties the phone, which is what it says; no special case in the delta.*
3. **What a copy holds.** The values the app reads from the three stores, written in the current
   form of each — not the files' bytes. It goes through the same read the app does, so a torn save
   is undone first and an earlier-form store yields a current-form copy. *#270's take-out is bytes
   as they lie; this is deliberately not.*
4. **The file's name carries when it was made.** *Two copies saved to one folder stay two files,
   and the newer one can be told without opening it.*
5. **Where the ask lives.** A section of its own at the foot of the commitments screen, below
   what they have stopped, holding one row that makes a copy. *#267 adds restore to it and #268 the
   last-copy line, so the three things about carrying a history sit together; a toolbar menu would
   leave #268's line nowhere natural.*
6. **After the share sheet.** No trace: nothing shown, nothing written. *The app cannot tell a
   copy saved from one cancelled, and the stores are date-only; #268 decides what its last-copy
   line counts.*
7. **A copy that cannot be made** — a store refuses to read, or the file cannot be written before
   the sheet takes it. Said as the screen's existing refused change: replaces the one held, names
   the store, lasts until the app is shown again or a change is kept. *One notice on the screen,
   not two.*
8. **The walk.** Three simulator shots: the commitments screen with the copy section; the share
   sheet up with the file's name visible; the refusal notice with a record that cannot be read.
   One phone line: save the copy to Files and open it there. *No fresh-install shot — 2 is a seam
   test's to show.*
9. **The moment inside the file.** Yes: beside its own form number and the three stores, a copy
   carries the moment it was made. *A name is whoever holds the file's to change; #267 can say
   which copy it is putting back. The first timestamp in the model, in a copy and never in a
   store, read at the edge like `today()` (ADR-1004).*
10. **The file's kind.** Its own, `.daybyday`, declared by the app target. *Files shows it as
    DayByDay's and #267's picker can offer only copies, so "not a copy" is rarely hit. Plain
    `.json` would make the picker offer every JSON on the phone.*
11. **Name precision.** Date and time to the minute, e.g. `DayByDay 2026-09-15 14.32`. *Two
    copies in one day stay two files.*

## Facts found, carried to spec-author

- The commitments screen holds the roster place and the record place and **no one-off place**;
  every place is a static on `DayScreen` and the app's `@main` constructs nothing. The day screen
  holds all three.
- The three stores are hand-written versioned JSON at forms 5 (record), 4 (roster) and 1
  (one-offs); dates are `{year, month, day}` triples; **no store carries a timestamp** and the
  only clock read in the app is `ContentView.today()`. The app has no version constant of its
  own — only the per-store forms.
- Nothing in `src/` uses `ShareLink`, `Transferable`, `FileDocument`, `fileExporter` or
  `UIActivityViewController` yet. The app target generates its Info.plist
  (`GENERATE_INFOPLIST_FILE = YES`, no plist on disk). **Unverified:** whether an exported type
  declaration for `.daybyday` can ride the generated plist or needs a plist file added.
- ADR 1054 is free on every branch and worktree.
- §7: #266 is the first `restore` Story to reach Stage 4. #261 and #262 (`FEAT: commitment`,
  both on the commitments screen) have no branch yet. If the delta MODIFIES a `commitment`
  requirement — settled 7 reaches *holds the change it refused* — `design.md` should say so,
  because whichever of the three reaches Stage 4 next serialises behind this one.

## Terms landed in CONTEXT.md

No new term. Two amendments, both dated 2026-09-15 at this grill:

- **Copy** — what it holds (values in the current form, its own form, the moment made), taken
  whole or refused, a copy of nothing is a copy, leaves through the share sheet under a dated name
  as a file of its own kind, no trace behind.
- **Commitments screen** — also holds the way a history leaves the phone, in a place of its own;
  a copy it cannot make is a refused change; a copy made leaves nothing on the screen.

## Left open

None. Every question the frontier raised was answered, and the one thing unverified — how the
`.daybyday` type is declared under a generated Info.plist — is a fact for `spec-author` to check,
not a preference of the owner's. No ADR was written at the grill: 3, 9 and 10 fix the copy's form,
which is the seam every later Story reads, and `spec-author` judges at the delta whether that
earns one (1054 is free).
