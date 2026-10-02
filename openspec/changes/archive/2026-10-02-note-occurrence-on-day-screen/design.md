## Context

See `proposal.md` § *Why*, and `grill.md`, whose twenty-four settled answers this delta is written
on. The facts the shape turns on, read off this worktree at `origin/main` 90ae2da:

- **`HappeningStore` writes form 1**, `{ version, happenings: [{ identity, name }] }`, and refuses a
  later form; `OneOffDocument` is the precedent for a second form that reads the first.
- **`DayScreen` holds a `CalendarDate` today and no clock.** `Moment` is formed at the shell's edge
  (`ContentView.momentNow()`) and handed in, per ADR-1004.
- **`DayScreen` reads its record, roster and one-offs in `readRecordAndRoster`**, at `init` and
  `shown(asOf:)`; `returnedTo(from:)` re-reads the roster. It has no happening place.
- **"Nothing is due on this day." is the shell's own line**, drawn where no group, birthday or
  one-off row is drawn and `everySourceOfTheListWasRead`; no Kit requirement states it.
- **`saysACopyCanBeRestored` reads four states by name**, and `restore`'s requirement lists the four.
- **One carried test pins the later form as a literal**: `CommitmentsScreenHappeningTests` writes
  `"version": 2` for *a happening place written by a later version…*.
- **SwiftUI's `Menu` takes `.menuOrder(.fixed)`** (iOS 16, in this SDK's interface); `.automatic`
  may put the first item nearest the button, which at the foot reads upside down.

## Goals / Non-Goals

**Goals:** note an occurrence from the day screen and draw what came, every rule drivable through
`DayScreen`, `DayView`, `Happenings` and `HappeningStore`, with no new screen in the Kit.

**Non-Goals:** no change or take-back of an occurrence, so the row of what came takes no tap (#377);
no look-back (#378); no stop or delete (#379); no copy, take-out or restore of happenings, so the
store card offers no restore for them (#380); no change to the commitments screen beyond the form.

## Decisions

### The seam

```swift
public struct TimeOfDay: Hashable, Comparable, Sendable { public let hour: Int; public let minute: Int; public init?(hour: Int, minute: Int) }
public struct Occurrence: Hashable, Sendable {
    public let happening: Happening.Identity
    public let day: CalendarDate
    public let time: TimeOfDay?
    public let note: String?
    public init(of happening: Happening, on day: CalendarDate, at time: TimeOfDay?, saying note: String?)
}
public private(set) var occurrences: [Occurrence]  // on Happenings
public mutating func note(_ occurrence: Occurrence) -> Bool  // on Happenings
@discardableResult public func note(_ occurrence: Occurrence) throws -> Bool  // on HappeningStore
public struct HappeningRow: Hashable, Sendable { public let name: String; public let timesInWords: String }  // in DayView
public let happeningRows: [HappeningRow]  // on DayView, [] from every public init
public init(startingFrom:asOf:keepingRecordAt:keepingRosterAt:keepingOneOffsAt:keepingBirthdayTicksAt:keepingHappeningsAt: URL? = nil, readingBirthdaysFrom:whileOn:copyingTo:)
public private(set) var happenings: [Happening]  // on DayScreen
public private(set) var happeningState: RosterState
public var offersNotingAHappening: Bool
public func startingTime(asOf now: Moment) -> TimeOfDay?
public enum OccurrenceRefusal: Equatable, Sendable { case notYetCome, notKept }
@discardableResult public func note(_ happening: Happening, at time: TimeOfDay?, saying note: String, asOf now: Moment) -> OccurrenceRefusal?
```

### Occurrences are held by `Happenings`, in a second form, with no identity of their own

`Happenings` holds them because it alone knows which happenings are held, which is the one thing an
occurrence is refused for; its equality reads them in order. They are keyed to `Happening.Identity`,
so a rename carries nothing over (ADR-1065). The value keeps a note as given; the screen trims.
- *Rejected:* an identity per occurrence — nothing refers to one yet; #377 can mint one on read.
- *Rejected:* staying at form 1 with an optional key — an older build would read the file, drop the
  occurrences on its next write, and never say "later version".

### Migration

Form 2 adds `"occurrences": [ { "happening": "<UUID>", "day": <DateRecord>, "hour": 9, "minute":
10, "note": "…" } ]` in noted order, `hour`, `minute` and `note` absent where none. Form 1 reads as
no occurrences and is rewritten as form 2 on the first kept change, from either screen. The carried
fixture's literal `2` becomes `HappeningDocument.currentVersion + 1`, the shape its sibling uses.

### Now is handed in, and a time of day is its own value

`TimeOfDay` exists because the shell sets a time with no day in hand; `Moment` stays a date with a
time. `now` is handed to `startingTime` and `note`, never read in the Kit (ADR-1004). The day shown
at Save is the day noted on, as `addOneOff` takes `shownDay` at commit.
- *Rejected:* `at: Moment?` — a moment on another day would need a refusal of its own.

### The refusal is returned, and the sheet holds it

`note(...)` returns its refusal and sets no `notice`; the sheet shows it until the next Save or until
it closes, which is the sheet's own life. A kept occurrence sets `notice = nil` and re-forms
`dayView`, as a kept one-off change does, and calls no `keptAChange()`: happenings are in no copy
until #380. `saysACopyCanBeRestored` is untouched.
- *Rejected:* a held refusal with its own lifetime, as `happeningRefusal` — a sheet that closes on
  every end already gives it one.

### Readings the delta takes

Rows run in the order made (settled 13's reason); times are `HH:mm`, the grill's "09:10, 18:40";
settled 4's recommendation — trimmed, blank is none, no cap — is read as accepted.

### The shell

The foot bar holds the "New one-off" field and, right of it, `Image(systemName: "bolt")`, labelled
"Note a happening", drawn exactly while `offersNotingAHappening`; with no field the bolt stands alone,
trailing. The bolt is a `Menu` of `happenings`' names with `.menuOrder(.fixed)`. A name opens a sheet
titled with it — *Cancel*, *Save* — a "Time" row showing the time with a clear button, or "No time"
tapped to set one (the picker opens on now, bounded at now on today), and the multi-line note field
the note-commitment sheet uses. A kept Save closes the sheet; a refused one keeps it open over a red
line: "Not saved. Try again." or "That time has not come yet." `happeningRows` draw as one card with
no heading after every group, each "\<name\> · \<timesInWords\>", no tap. The store card adds "The
happenings could not be read." or "The happenings were written by a newer version of DayByDay and
must not be deleted."; `everySourceOfTheListWasRead` and the "Nothing is due" line read no happening.

### What the shell draws

Option B, *Foot menu*, from https://claude.ai/artifact/UbQtkwXn4LAMc2nfoqew7n.

```
B · Foot menu   (recommended)
              [☰ ⚙]
Friday
Today, 2 October 2026
‹ M28 T29 W30 T1 (F2) S3 S4 ›
┌ Creatine - Every day
│ …
└ Protein - Every day  35 of 120 ›
┌ Kopfweh · 09:10, 18:40, no time
└
( New one-off              ) (⚡)   ⚡ beside the field, at the foot

⚡ → menu rising from the button, order made, top to bottom
              ┌ Augenmigräne
              │ Kopfweh
              └ Schlecht geschlafen
                               (⚡)
name → sheet of its own over the day
[Cancel]   Kopfweh    [Save]
┌ Time          [18:52] ⓧ
┌ note, multi-line|
[keyboard]
Future day: no ⚡, the field runs full width
```

## Risks / Trade-offs

- **The likeliest wrong implementation compares the time with the screen's today alone.** → Two
  scenarios hand a `now` whose minute, and whose date, decide the answer.
- **The second copies the one-off's tail, `keptAChange()` included.** → A scenario asserts the last
  copy has not moved.
- **A long happening name may be cut short in the menu and the sheet's inline title.** → Accepted:
  the platform's choice; the row of what came wraps, as a commitment's does.
- **A sheet left open across midnight notes on the new today** with the time it held, refused as
  not yet come where that time is later than now. → Accepted; Save says why.

## Open Questions

None. `grill.md` § *Left open* is "None." for the owner; its three facts are answered above — the
menu order by `.menuOrder(.fixed)`, a long name in § *Risks*, and the row as a name and its times in
words. Writing the delta raised nothing that needs the owner; no residual round is outstanding.
