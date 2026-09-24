## Context

See `proposal.md` § *Why*, and `grill.md`, whose eleven settled answers this delta is written on.
The facts the shape turns on, read off this worktree and the grill's fact agent:

- **The Kit imports Foundation only**; nothing imports `EventKit`, and no calendar usage key exists.
- **`CopyPlace` is the app's first setting**: an `@Observable` class opened at a file of its own
  under `ApplicationSupport/DayByDay/`, reading unreadable content as nothing kept, built once in
  `ContentView.init` and handed to both screens. `UserDefaults` is used nowhere (ADR-1017).
- **iOS 17+ calendar access is five states**: not determined, full, write-only, denied, restricted.
  `requestFullAccessToEvents` prompts only where iOS lets it; without the usage key every request
  is denied. `UIApplication.openSettingsURLString` opens the app's page in Settings.
- **Whether a change in Settings terminates the app is unverified**, in either direction.
- **`CommitmentsView` is one `List`**, *Copy* its last section; no switch-style control exists yet.
- The `birthday` Purpose names the store and not the switch; only `/opsx:archive` writes that file.

## Goals / Non-Goals

**Goals:** every rule drivable as a Kit test against a fake phone, with no EventKit and no
simulator; one new type, and no existing Kit member changed.

**Non-Goals:** reading any birthday, or handing the switch to the day screen (#328); carrying ticks
in a copy (#329); a line for a switch place that cannot be written; an ADR — the setting follows
`CopyPlace`'s shape, and nothing here is expensive to reverse.

## Decisions

### The seam

One new type and the enum it reads, beside `CopyPlace`. A test counts the phone's asks through the
closure it hands in.

```swift
public enum CalendarAccess: Hashable, Sendable { case notAsked, full, writeOnly, denied, restricted }
@MainActor @Observable public final class BirthdaySwitch {
    public static var place: URL { get }
    public init(at place: URL = BirthdaySwitch.place, readingAccess access: @escaping @MainActor () -> CalendarAccess, askingForAccess ask: @escaping @MainActor () async -> Void)
    public private(set) var isOn: Bool
    public private(set) var isRefused: Bool
    public func turnOn() async
    public func turnOff()
    public func shown()
}
```

### The phone's five answers reach the Kit unjudged

The shell maps each `EKAuthorizationStatus` onto the `CalendarAccess` case of the same meaning, and
`@unknown default` onto `.denied`. Which answers are a refusal is judged in the Kit, so settlement 2
— write-only and restricted refuse exactly as denied does — is under test.
- *Rejected:* three cases (never asked, full, refused) — write-only's verdict would sit untested in
  the shell.
- *Rejected:* `import EventKit` in the Kit — its first framework past Foundation, for one enum.

### A type of its own beside `CopyPlace`, not a member of `CommitmentsScreen`

#328's day screen needs the same switch, so it takes `CopyPlace`'s shape: one instance built in
`ContentView.init` and handed to each screen that needs it. This Story hands it only to
`CommitmentsView`; `CommitmentsScreen` is untouched.
- *Rejected:* members on `CommitmentsScreen` — the day screen would then read another screen.

### On is a reading, not a memory

`isOn` is *kept on* and *last reading full*; `isRefused` is the last reading alone. Readings are
taken at `init`, at `shown()` and after the ask, so a refusal is never remembered as an event
(settlement 9). A reading that is not full while on is kept writes *off* (settlement 8). Turning on
asks whenever access is not full and lets iOS decide whether a prompt appears; until it answers
the switch stays off, and the toggle, drawing only what the Kit says, shows off under the prompt.
- *Rejected:* ask only when never asked — builds in an unverified iOS rule about write-only.
- *Rejected:* read access live on every `isOn` — an `@Observable` property no one is told changed.

### The form on disk, version 1

`{ "on": true, "version": 1 }` at `ApplicationSupport/DayByDay/birthday-switch.json`, written whole
with `.atomic` and `.sortedKeys`. Anything unreadable, a later version included, opens off and is
overwritten by the next change. A write that fails is held for this run and not said, exactly as
`CopyPlace.persist()` does: a judgement, since the grill did not reach it and a single bit is lost.

### Migration

None — additive: a new file at a new place, and no existing document, type or encoding is touched.

### The shell

- `ContentView` builds the switch beside `copyPlace`, hands it to `CommitmentsView`, and calls
  `shown()` when the app becomes active and when *Commitments* is tapped — a visit either way.
- The adapter, in the shell: `EKEventStore.authorizationStatus(for: .event)` mapped as above, and
  an ask of `requestFullAccessToEvents()` whose thrown error is ignored, since a reading follows.
- The section: a `Toggle` labelled "Birthdays", no header; turned on runs `turnOn()` in a `Task`.
  Its footer holds the explaining line and, while `isRefused`, the refused line and a button that
  opens `openSettingsURLString`.
- The words, verbatim from `grill.md`: explaining line "Birthdays from your phone's calendar, on
  the day they fall."; refused line "Calendar access is off for DayByDay, so birthdays can't be
  read."; button "Open Settings"; `NSCalendarsFullAccessUsageDescription` "DayByDay reads your
  Birthdays calendar to show each birthday on its day. It adds nothing to your calendars and
  changes nothing in them."

### What the shell draws

Option A, *Before Copy*, chosen at the layout round from https://claude.ai/artifact/Ts3g76gSodzVvuwaDZNrD1.

```
A · Before Copy
┌──────────────────────────────────────┐
│ ‹  Commitments               ⇅   +   │
├──────────────────────────────────────┤
│ Creatine - Every day               › │
│ Nails - Every 4 days               › │
│ Finances - The 25th                › │
│ Stopped                              │
│ Nothing has been stopped.            │
│                                      │
│ Birthdays                    [ ○  ]  │   ← switch, its own section, no header
│  Birthdays from your phone's         │   ← footer: explaining line
│  calendar, on the day they fall.     │
│  Calendar access is off for          │   ← footer, only while refused
│  DayByDay, so birthdays can't be     │
│  read.                               │
│  Open Settings                       │   ← link-styled button
│ Copy                                 │
│ Copy place            Pick a folder ›│
│ Make a copy                          │
│ Restore from a copy                  │
│  Pick a folder to keep a copy there. │
└──────────────────────────────────────┘
```

## Risks / Trade-offs

- **The likeliest wrong implementation remembers the refusal as an event**, set on a refused ask.
  → The last scenario never turns the switch on and still asks for the refused line.
- **The second computes `isOn` from access alone**, so access given back turns it on again. → Both
  give-back ANDs, one through `shown()` and one through a reopened switch.
- **Settings may terminate the app, or may not.** → Both paths re-read: a fresh `init`, `shown()`.
- **The walk needs calendar access reset between steps**, and whether the walk's uninstall clears
  it is unverified. → The throwaway walk test resets it itself; a change to `scripts/walk.ts` is a
  stop, not a fix.

## Open Questions

None. `grill.md` § *Left open* is "None." with its reason, and writing the delta raised nothing
that needed the owner: the edges it turned up — access reset to never asked while on, a write-only
phone asked again, an unreadable or later switch file — follow from settlements 1, 2, 8 and 9 and
`CopyPlace`'s shipped reading. The one judgement taken, a failed write held for this run, is named
where it is made. No residual round is outstanding.
