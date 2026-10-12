## Context

See `proposal.md` § *Why*, and `grill.md`, whose eleven settled answers, layout and four carried
Feature-grill decisions this delta is written on. The facts it turns on, read off `origin/main` at
d31938f:

- **`History` keeps four private collections** — ticks, numbers, notes, additions — and enumerates
  them by hand in `holdsRecords`, `hasRecords`, `datesRecorded`, `commitmentsWithRecords`, `settle`,
  `erase`, `move` and `recordDocumentParts`. A spec's generic "record" reaches none of these.
- **`RecordStore` mirrors the four collections** and each `add`/`remove` writes its own next mirror
  beside the other three; `settle` and `carryOver` write `recordDocumentParts()`.
- **The record form is 8**, each part judged against the form it arrived at; the copy form is 3 and
  nests the record form as written; `CopyDocument.init` and `formCopy` enumerate the four kinds.
- **`datesRecorded` is shared** by the stop, the recorded-day refusal, the interval shift offer.
- **`DayView.Row.holdsARecord`** is `isKept || number || note || total > 0`; `shiftDays` reads it.
- **The shell's row menu** is attached only where `shiftDays(for:)` is non-empty; the check's slot
  draws the green check on a kept row and nothing otherwise.
- **Carried tests naming record form 9 as a later form**: `RecordStoreTests.swift` 261, 264;
  `DayScreenTests.swift` 348, 432, 612, 3624, 4295, 7786. No other record JSON declares form 9.

## Goals / Non-Goals

**Goals:** the delta, every rule drivable through `Decline`, `History`, `RecordStore`, `DayView`,
`DayScreen`, `CommitmentsScreen` and a copy, and the shell drawing option A.

**Non-Goals:** counting declined days in a look-back (#403); days away (#401, #402); any change to
ADR-1045's colours or to what a row offers on tap; condensing the carried MODIFIED requirements, an
editorial Story's (ADR-1047).

## Decisions

### The seam

```swift
public struct Decline: Hashable, Sendable
public init?(for commitment: Commitment, on date: CalendarDate, reason: String?)
public let Decline.reason: String?
public mutating func History.add(_ decline: Decline)
public mutating func History.removeDecline(for commitment: Commitment, on date: CalendarDate)
public func History.decline(for commitment: Commitment, on date: CalendarDate) -> Decline?
public func RecordStore.add(_ decline: Decline) throws
public func RecordStore.removeDecline(for commitment: Commitment, on date: CalendarDate) throws
public let DayView.Row.isDeclined: Bool
public let DayView.Row.declineReason: String?
public func DayScreen.offersDecline(for row: DayView.Row) -> Bool
public func DayScreen.decline(_ row: DayView.Row, reason text: String) throws
public func DayScreen.takeBackDecline(on row: DayView.Row) throws
```

All are new; `History.add` of the four other kinds keeps its signatures and replaces a decline.

### A decline holds its day's place, and gives it up to any other record — ADR-1068

A decline added on a day holding any record leaves the history as it was; any record added on a
declined day replaces it, an addition short of its target included (settled 1, and "never both").
The history is then equal to one never declined, so the shipped take-backs stay true unmodified.
- *A short addition refused on a declined day:* rejected — a take-back first, for no gain.
- *A decline beside a short total:* rejected — declined and recorded at once, which "never both" bars.

### One offer, read both ways

`offersDecline(for:)` answers one question; `row.isDeclined` says which menu it means — "Decline" on
a row holding nothing, "Reason" and "Take back" on a declined one. `decline(_:reason:)` both declines
and re-reasons, so the sheet calls one member whichever word it says.
- *Separate members for declining and re-reasoning:* rejected — two seams for one record, one sheet.

### The store writes what its history holds

Every `RecordStore` change forms the next `History`, writes its `recordDocumentParts()` — five
collections now — and only then takes it, so a tick replacing a decline cannot leave it at the place.
- *Each `add` clearing a decline in its own mirror:* rejected — five places to keep in step, and the
  one that forgets writes a store the next open refuses.

### Shipped text the delta falsifies is carried in full; the rest is met by enumeration

Eight shipped requirements gain a clause and are MODIFIED whole: `record`'s refusal list, form list
and carry-over; `day-screen`'s row parts, what a row gives back and the shift offer; `commitment`'s
stop and deletion. Every other "record" already reaches a decline, and the code meets it where it
enumerates: `History`'s eight members, `DayView.Row.holdsARecord`, `RecordStore.formed`,
`CopyDocument.init` and `formCopy`. `datesRecorded` with declines is what keeps a stopped commitment
until a declined day (settled 4) and refuses a change leaving one not due.

### The shell

`rowView` attaches its `.contextMenu` where `shiftDays(for:)` is non-empty or `offersDecline(for:)`
is true: "Shift to" as today; then, on an undeclined row, `Button("Decline")` opening the reason
sheet; on a declined row, the whole `declineReason` as a disabled `Text` where there is one, then
`Button("Reason")` opening the sheet on that reason, and `Button("Take back", role: .destructive)`
calling `takeBackDecline(on:)`, unconfirmed as a tick's take-back is. The check's slot draws
`minus` in `Color.secondary` where `isDeclined`, before the chevron of an entry row; `declineReason`
draws under the name line as a `.caption`, `.secondary`, `lineLimit(1)`, above a total's caption.
The sheet is a short sheet titled by the row's name, "Cancel" leading, a `TextField("Reason
(optional)")` focused, and "Decline" — "Save" on a declined row — trailing and never disabled,
calling `decline(_:reason:)` through `keeping`. ADR-1042: nothing swipes.

### What the shell draws

Option A, *Dash*, from https://claude.ai/artifact/JKBXJW6iRm73GNygGfJ2G6.

```
A · Dash                                   (recommended)
  │ ~~Creatine~~ - Every day             ✓ │  kept: grey struck name, green check (as today)
  │ Magnesium - Every day                — │  declined: plain name, grey dash
  │   Ran out                              │  reason: grey caption, one line
  │ Nails - Every 4 days                   │  unrecorded: nothing
  │ Run - Tue, Thu, Sun                  — │
  │   Knee still sore after Tuesday's r…   │  cut to one line
  │ Yuno - 2/5x a week                     │  weekly quota: never declined
  │ Weight - Every day                 — › │  entry row: dash, then chevron; no reason, no line

  Reason sheet (short, keyboard up)
  ┌──────────────────────────────────────┐
  │ (Cancel)        Run        (Decline) │  Decline works with the field empty
  │ ┌──────────────────────────────────┐ │
  │ │ Reason (optional)                │ │
  │ └──────────────────────────────────┘ │
  └──────────────────────────────────────┘

  Long press on a declined row
  │ Run - Tue, Thu, Sun                  — │  ← row lifted
  │   Knee still sore after Tuesday's r…   │
     ┌──────────────────────────────┐
     │ Knee still sore after        │  whole reason, grey, uncut
     │ Tuesday's run, resting it…   │
     ├──────────────────────────────┤
     │ Reason                       │
     │ Take back                    │  red, as the app's other Take back
     └──────────────────────────────┘
```

```
  │ Nails - Every 4 days                   │  ← row lifted
  ┌──────────────────────┐
  │ Shift to           › │  as today
  │ Decline              │  added below; alone where no free day exists
  └──────────────────────┘
```

### Migration

The record form moves from 8 to 9, adding a `declines` list: each a commitment record — the shift
its day answers to beside it, as any record's — a date, and a reason or `null`. An earlier form reads
as holding no decline and stays byte-for-byte until the next kept change. The copy's form stays 3:
it nests the record form as written, and its later-form check refuses a copy an older app cannot
read. The roster form does not move.

## Risks / Trade-offs

- [An enumeration left at four kinds] → a decline vanishes on rename, survives a deletion or slips
  past a stop; the carry-over, deletion, stop and copy scenarios each reach one, and 2.2 lists all.
- [A decline written without the shift its day answers to refuses the whole store on next open] →
  the scenario reading a decline back on a shift's landing day.
- [Identity equality: a `Decline` is compared through its commitment's identity] → rows store
  `isDeclined` and `declineReason`, so a new reason redraws; the row-equality scenario guards it.
- [Six of the eight carried requirements are over the prose budget] → the `check:budgets` warnings
  are expected; condensing them is an editorial Story's.

## Open Questions

`grill.md` § *Left open* is "None." Writing the delta raised no question the grill had left: the one
choice it turned up — an addition short of its target on a declined day replaces the decline — is
settled answer 1 and "never both" read together, recorded above and in ADR-1068. None remain.
