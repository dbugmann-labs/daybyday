## Context

See `proposal.md` § *Why*, and `grill.md`, whose eight settled answers and layout this delta is
written on. The facts the shape turns on, read off this worktree:

- **Where is words in the shell alone.** `DayScreen.saysACopyCanBeRestored` is a `Bool`; the words
  "A copy can be restored from Commitments" are a `Text` in `ContentView`. The five carried tests of
  the modified requirement assert the flag, so none of them can tell Commitments from Settings.
- **Every copy, take-out, restore and copy-place act is `CommitmentsScreen`'s**, and the birthday
  switch is `BirthdaySwitch`, handed to `CommitmentsView` from `ContentView`. The shell builds a
  `CommitmentsScreen` when the Commitments button is tapped, calls `birthdaySwitch.shown()`, and on
  the way back calls `DayScreen.returnedTo(from:)` with it, which is what draws a restored copy and
  a switch turned on.
- **Commitments is a push** (`navigationDestination`); its copy and birthday sections are two
  `Section`s below *Stopped*, with the pickers, the share sheets, the restore confirmation and the
  folder-holds-a-copy ask attached to `CommitmentsView`.
- **The bundle already says "1.0" and "1"** (`MARKETING_VERSION`, `CURRENT_PROJECT_VERSION`).
- **No spec names the toolbar, the refused line's button, the switch's tint or the version.** The
  one requirement that places any of this is restore's, which the delta modifies.

## Goals / Non-Goals

**Goals:** the day screen's restore line names Settings; Settings draws everything that leaves
Commitments, in grill option C; Commitments is its two lists and what is done to them.

**Non-Goals:** any change to what a screen does or refuses, to any Kit signature, or to any
requirement but the one modified. The moments' region format (`docs/open-questions.md` § *Known
gaps*) and B-066's late day title stay as they are.

## Decisions

### The seam

No member is new or changed. The acceptance tests of the modified requirement attach where they
already do, and carry their titles, fixtures and assertions unedited:

```swift
public var saysACopyCanBeRestored: Bool { get }                          // DayScreen — unchanged
public func returnedTo(from commitmentsScreen: CommitmentsScreen? = nil)  // DayScreen — unchanged
```

This is not an editorial Story, because the day screen's words change for a person, and it has no
red: the one changed word sits where the flag's tests cannot reach, so rule 3's loop has no scenario
to take. The reviewer reads the word in the diff, and the walk shows it where it can be driven.

### "A commitments screen" in the specs stays the Kit's screen

Settings draws the half of `CommitmentsScreen` that leaves the commitments screen; every restore,
copy, take-out and copy-place requirement stays true word for word, and so does day-screen's
*returned to from a commitments screen that has restored a copy*. `CONTEXT.md` § *Commitments
screen*'s 2026-09-29 amendment says this: what moves is where these are drawn, not what they do.
- *Rejected:* a `SettingsScreen` in the Kit, split off `CommitmentsScreen` — moves the subject of
  every restore requirement and its tests for a change in drawing.
- *Rejected:* rewording those requirements to say Settings — a delta across two specs that changes
  no behaviour, and that the grooming pass declined.

### Settings builds a Kit screen of its own each time it opens

The Settings button builds `CommitmentsScreen(asOf: today(), copyingTo: copyPlace)` and calls
`birthdaySwitch.shown()`, as the Commitments button does now; the sheet's dismissal, by Done or by a
swipe, calls `screen.returnedTo(from:)` with it, then drops it. The app being shown again calls
`shown(asOf:)` on whichever is open. The Commitments button stops calling `birthdaySwitch.shown()`,
and `CommitmentsView` stops taking the switch.
- *Rejected:* one `CommitmentsScreen` shared by both — a refusal held on one would be drawn on the
  other, which neither screen's requirements allow.

### The changed word stays in the shell

`saysACopyCanBeRestored` stays a `Bool`, and the shell's `Text` changes. `grill.md` settled answer
5 accepts the flag's tests as the cover.
- *Rejected:* the line's words said by the Kit — a new member for one word, which the grill did not
  ask for.

### What carries no requirement

The version line, "Open iPhone Settings", the two symbols, the switch's tint and the sheet are the
shell's (ADR-1019): none is a rule the Kit states, and the version reads the bundle, which the Kit
cannot. The version is `CFBundleShortVersionString` and `CFBundleVersion`, as "Version 1.0 (1)".

### The shell

A new `SettingsView(screen: CommitmentsScreen, birthdaySwitch: BirthdaySwitch)` in
`src/DayByDay/DayByDay/`, in its own `NavigationStack` inside a full-height sheet: large title
"Settings", Done as the confirmation action. Its sections, and everything they present, move from
`CommitmentsView` with their words unchanged but two: the refused line's button says "Open iPhone
Settings", and the switch takes `.tint(.accentColor)`. The copy place's refusal line moves under
the last-copy line, as the wireframe draws it. Helpers both views need (`momentText`, the refusal
texts) are shared rather than copied. The day screen's toolbar puts `list.bullet` ("Commitments")
and `gearshape` ("Settings") in one trailing group; Today and the one-off checkmark are unchanged.

### What the shell draws

Option C, "Settings, then acts", from https://claude.ai/artifact/QQNRaRDA8cHEuX92Lu9Rfy.

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

## Risks / Trade-offs

- [The changed word is under no test] → the reviewer checks the string; W.6 shows it where the
  walk can put an unreadable record in the simulator, as `take-out-an-unreadable-store`'s did.
- [A sheet's change not redrawing its presenter, as #303 found] → `returnedTo(from:)` runs on every
  dismissal, and two `phone:` lines check a restore and a switch turned on reach the day screen.
- [Pickers, share sheets and the restore confirmation presented from inside a sheet] → full height,
  and the walk and a `phone:` line exercise the folder picker and the file picker.
- [#347 `page-the-week-strip` also edits `ContentView.swift`] → different regions; a rebase.

## Open Questions

None. `grill.md` left none open, and writing the delta turned up no preference that would change
it: one requirement moves by one word, and every drawing choice was settled at the layout round.
