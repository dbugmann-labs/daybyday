# Grill — add-settings-screen

*9 questions over 3 rounds, the last the layout round, 2026-09-29, one fact agent, no fact sent to the owner. The grooming pass
for B-067 settled the boundary in 6 more questions over 2 rounds (`docs/backlog.md` § Decided and
§ Grooming passes, 2026-09-29): the name **Settings**, what moves to it (the copy place, making,
taking out and restoring a copy, the birthday switch, a version line), reached from the day screen
beside Commitments and from nowhere else, one Story, under `FEAT: restore` because restore's
*A day screen that is not keeping a store says a copy can be restored and where* is the only
requirement that places any of it. This file does not repeat those answers.*

## Settled

1. **The birthday refused line's button says "Open iPhone Settings"**, not "Open Settings", and
   still opens DayByDay's page in the phone's Settings. *Inside a screen titled Settings, "Open
   Settings" reads as a link to itself. The wording is in no spec (fact agent), so this is shell
   only.*
2. **The day screen's restore line says "A copy can be restored from Settings".** One word changes
   from "Commitments". *It names the screen by the label its toolbar symbol carries.*
3. **The version line reads "Version 1.0 (1)"**: the marketing version and, in brackets, the build
   number, both from the app's bundle. *The build number is what tells two phone installs of one
   version apart.*
4. **Settings opens as a sheet with a Done button**, not a push like Commitments. *What the owner's
   capture asked for, and the iOS convention for a place you go into, change and close; it also
   avoids the pushed-screen return where B-066's late day title shows. Commitments stays a push
   (`ContentView.swift:242`, fact agent); P6's brief called it a sheet and was wrong.*
5. **The walk** shows five pictures: the day screen's toolbar with Today and the two symbols;
   Commitments as the roster alone; Settings with no copy place; Settings with a copy place and its
   last-copy line; Settings with birthdays on. A sixth, the day screen saying a copy can be restored
   from Settings, is shown **only if** the implementer can put an unreadable store into the
   simulator's container. If it cannot, the kit test on `saysACopyCanBeRestored` covers it, and it
   is never a phone line, because a person cannot break a store on the phone. *The line is the
   changed requirement's only visible trace.*
6. **Three `phone:` lines**: a copy restored from Settings, then closed, leaves the day screen
   drawing what the copy holds; birthdays turned on in Settings with calendar access granted, then
   closed, leave the Birthdays group on the day screen; with calendar access denied, Settings shows
   the refused line and "Open iPhone Settings" opens DayByDay's page in the phone's Settings. *The
   file picker and the system permission prompt cannot be driven in the walk, and a sheet's
   mutation failing to redraw its presenter is what #303 found once.*
7. **Commitments' toolbar symbol is `list.bullet`**, and Settings' is `gearshape`, labelled
   "Commitments" and "Settings" for accessibility. *Commitments is a list a person manages, not
   somewhere to tick; `checklist`, P6's pick, would draw checkmarks on a button that ticks nothing.
   Asked because the grill settled two symbols but not which.*
8. **The birthday switch takes the app's tint when on**, not the system green it ships with.
   *ADR-1045's amendment of 2026-09-28 keeps green for a checkmark alone; the switch is moving
   anyway. Turned up by `designer`.*

## Terms landed in CONTEXT.md

None at this grill. **Settings** landed at the grooming pass for B-067, along with its amendments
to *Commitments screen*, *Copy place*, *Restore*, *Take-out* and *Birthday*.

## Layout

Option C, "Settings, then acts", chosen from three at https://claude.ai/artifact/QQNRaRDA8cHEuX92Lu9Rfy
on `designer`'s recommendation. *The copy place sits directly above its last-copy line, which
`CONTEXT.md` § Copy place asks for, rather than with the act rows and their refusal lines between
them. The screen reads the way the **Settings** term does: the two settings first, the acts after.
One glass capsule is iOS 26's default for adjacent trailing items, and Commitments already draws its
own two that way. Full height because the folder picker, the file picker, the share sheet and the
restore confirmation all open on top of it.* The wireframe, verbatim from the designer (Settings
shown with a copy place and birthdays on):

```
C — Settings, then acts   (recommended)
Day screen toolbar:  (Today)                    ( ≡   ⚙ )     one capsule
Sheet, full height:
                                                  (Done)
  Settings                                          large title
  ┌──────────────────────────────────────────────┐
  │ Copy place                        Backups  › │   swipe: Forget
  └──────────────────────────────────────────────┘
  Last copy 29 Sep 2026 at 14:32                  footer, right under it
  [Stopped since …: …]  [refused copy place line]
  ┌──────────────────────────────────────────────┐
  │ Birthdays                               [●○] │
  └──────────────────────────────────────────────┘
  Birthdays from your phone's calendar, on the day they fall.
  [Calendar access is off for DayByDay, so birthdays can't be read.]
  [Open iPhone Settings]
  Copy
  ┌──────────────────────────────────────────────┐
  │ Make a copy                                  │
  │ [copy refusal line]                          │
  │ [Take out the files + causes + refusal, only while offered]
  │ Restore from a copy                          │
  │ [restore refusal] [Restored the copy from …] │
  └──────────────────────────────────────────────┘
               Version 1.0 (1)                    centred footer
```

With no copy place, the row's value is "Pick a folder" and the footer is "Pick a folder to keep a
copy there.", as today.

## Left open

None. Every question the frontier raised was answered. One finding is not this Story's: the copy's
moments are said in the phone's region format (`momentText`), which predates it and will show in
the walk. It is recorded in `docs/open-questions.md` § Known gaps and left alone here, because
this Story moves those lines unchanged.
