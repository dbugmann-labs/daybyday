## Context

See `proposal.md` § *Why*, and `grill.md`, whose ten settled answers this delta is written on.

- **`OneOffs` holds its entries in the order added**, `internal`; its public surface is add, tick,
  take back, remove and `standingDay(for:asOf:)`. Nothing lists what it holds. `OneOffStore` writes
  entries in held order, so a store opened again reads them back in that order.
- **`DayScreen` opens `record.json` and `roster.json`** through `applicationSupportPlace(fileName:)`,
  and says each place's state through a three-case enum.
- **`DayView.groups` holds `Group(category:rows:)` of commitment `Row`s**; every change on a screen is
  guarded by `dayView.rows.contains(row)`.
- **`DayScreen.Notice` holds `row: DayView.Row` and `cause`**; the shell matches
  `row == screen.notice?.row` (`ContentView.swift:499`) and keys rows by offset (`:419`).
- **All 340 `DayScreen(` openings in `DayScreenTests.swift` pass their record and roster places**
  explicitly; none passes a one-off place, because none exists.
- **An undone one-off stands past its date only on the today** (ADR-1052), so a lateness count needs
  the row's date and the one-off's date and nothing else.

## Goals / Non-Goals

**Goals:** the order of a day's one-offs decided once, in `one-off`, and handed to a day view that
orders nothing; a third place shaped exactly as the two already shipped; one notice for both kinds
of row.

**Non-Goals:** making, removing or renaming a one-off from a row (#244); a row identity that is
neither value nor position (#244, `docs/open-questions.md`); backdating a tick (a want); any change
to the reach, to the one-off store's form, or to `record`.

## Decisions

### The seam

- `public func standing(on day: CalendarDate, asOf today: CalendarDate) -> [OneOff]` — on `OneOffs`
- `func isDone(_ oneOff: OneOff) -> Bool` — on `OneOffs`, internal
- `public init(of groups: [Roster.Group], oneOffs: OneOffs, asOf today: CalendarDate, on date: CalendarDate, in history: History)` — on `DayView`
- `public let oneOffGroup: DayView.OneOffGroup?` — on `DayView`
- `public struct OneOffGroup: Hashable, Sendable` with `public let heading: String` and `public let rows: [OneOffRow]` — in `DayView`
- `public struct OneOffRow: Hashable, Sendable` with `public var name: String`, `public let isDone: Bool`, `public var lateInWords: String?` and `public func offersTick(asOf today: CalendarDate) -> Bool` — in `DayView`
- `public static var oneOffPlace: URL` — on `DayScreen`
- `keepingOneOffsAt oneOffPlace: URL = DayScreen.oneOffPlace` — a new last parameter of `DayScreen.init`
- `public enum OneOffState: Equatable, Sendable { case kept, unreadable, writtenByALaterVersion }` — in `DayScreen`
- `public private(set) var oneOffState: OneOffState` — on `DayScreen`
- `public func tick(_ row: DayView.OneOffRow) throws` — on `DayScreen`
- `public let row: DayView.Row?` — on `DayScreen.Notice`, changed from non-optional
- `public let oneOffRow: DayView.OneOffRow?` — on `DayScreen.Notice`

### The order is `one-off`'s answer, and a day view only asks for it

`standing(on:asOf:)` sorts by date with a stable sort over held order. A day view calls it for its
own date and today, exactly as it calls `roster.groups(on:)`'s answer, so "a day view orders nothing
of its own" stays true without an exception (`CONTEXT.md` § *Day view*).

- Rejected: sorting in `DayView` — a second place an order could be decided.
- Rejected: `DayScreen` handing `[OneOff]` — the row would still need done-ness from somewhere.

### A One-offs group of its own, not a fifth `Group`

`Row` holds a `Commitment` and every member reads it; a one-off row would make each optional.
`oneOffGroup` is one member beside `groups`, so "after every group of commitments" is structure
rather than data: the shell draws it after `groups`, and no answer can place it anywhere else.
`rows` stays commitment rows, which keeps every shipped guard and scenario reading as it does.

- Rejected: a heading of `nil` category — that is already the uncategorised group.
- Rejected: a shared protocol for both row kinds — a wider seam for one caller.

### Lateness is derived from what the row is, never stored

A one-off row holds its one-off, its date and whether it is done; `lateInWords` is
`oneOff.date.days(until: date)` where undone and above zero. Identity is therefore those three
things, and two rows that read alike are equal.

- Rejected: storing the today on the row — equal-looking rows would differ.
- Rejected: storing the count — equality would rest on a derived number.

### One notice carrying a row of either kind

`Notice` gains `oneOffRow`, and `row` becomes optional; exactly one is set. The shell's match and
every shipped test comparing `notice?.row` compile unchanged, since optional chaining flattens.

- Rejected: a second `oneOffNotice` — two notices, against grill answer 9.
- Rejected: an enum case per kind — rewrites every shipped notice assertion.

### Five requirements MODIFIED, each by a sentence

*Holds the day view* counts five things to open from; *a day view is a value* counts its One-offs
group; *re-reads when shown* reads three places; *lasts only until* ends on a change of any kind at
either place; *tells nothing* counts a tap reaching no place, rather than not the record's, as no
change. Each would otherwise contradict an ADDED requirement. Titles are kept, so no scenario moves.
Four were over the prose budget on `main` already and each grows by its sentence; *tells nothing*
stood at it and stays within it. None is split here, since condensing is an editorial Story's lane.

### The shipped tests pass a one-off place of their own

A defaulted parameter would open the machine's real `one-offs.json` under every shipped test. Each
opening gains a temporary one-off place; no scenario or assertion changes. ADR-1052 is amended in
place for grill answer 2, and no new ADR is written: every other decision repeats a shipped shape.

### Migration

None — additive: a new file at a new place, in the one-off store's shipped form.

## Risks / Trade-offs

- **Sorting one-offs by name** reads right on most fixtures. → "Book dentist" is added after
  "Call mum" on the same date.
- **Lateness counted as of the today on any day**, or a late one-off on the shown day. → The
  moved-off-today and ticked-late scenarios.
- **A screen reading its one-offs as of the day shown, or on being returned to.** → Scenarios for both.
- **A take-back on a past day moves a row out of its group** while the shell keys rows by offset. →
  Accepted: the day view is replaced whole, and #244 owns identity for adding and removing.

## Open Questions

None. `grill.md` § *Left open* is "None." with its reason, and row identity is assigned to #244.
"1 day late" in the singular is the grill's own assumption, adopted as written. Writing the delta
raised no preference the grill had not settled, so there is no `## Questions for you` section.
