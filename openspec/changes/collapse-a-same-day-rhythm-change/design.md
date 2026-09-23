## Context

`Roster.put(era:on:keptUntil:under:)` puts the new era in front and ends the newest one on the date
given, whatever that leaves: an era kept from after that date holds no day, and eras further back are
never touched. `CommitmentsScreen.change` puts a rhythm, range or target era on kept from
`dayToKeepFrom`, as of the day before; `restart` does the same from the picked day, with a special
case that changes the era in place when the picked day is the day kept from. `RosterDocument
.formRoster()` refuses any two entries of one identity sharing schedule, day kept from and kind, and
`folded()` refuses the same inside a chain; both are read by `RosterStore.init(at:)`,
`RosterStore.formed(from:)` and `CopyDocument.formCopy()`, so a restore reads what the store reads.
Records key on identity and date alone, so no era change touches the record place. See
`proposal.md` for the why and `grill.md` for the ten settled answers this delta is written on.

## Goals / Non-Goals

- **Goals.** No roster this app writes holds an era holding no day, two eras holding one day, or two
  alike eras side by side; every roster already on a phone in one of those shapes reads again.
- **Non-Goals.** A stop on the day of a change, which leaves the newest era holding no day and is
  #306's (settled 9). Any new refusal or reworded one, the restart picker's bound, and the shell
  (settled 10). Filling a gap between eras, which nothing writes.

## Decisions

### The seam

```swift
@discardableResult public mutating func Roster.put(era: Commitment, on commitment: Commitment, keptUntil date: CalendarDate, under category: String?) -> Bool
public init(at place: URL) throws
public func CommitmentsScreen.change(_ commitment: Commitment, toName name: String, on rhythm: Rhythm, keptFrom: CalendarDate, under category: String?, lowest: String? = nil, highest: String? = nil, target: String? = nil) -> Refusal?
@discardableResult public func CommitmentsScreen.restart(_ commitment: Commitment, from day: CalendarDate) -> Refusal?
public func CommitmentsScreen.askToRestore(from file: URL) -> Refusal?
public func CommitmentsScreen.confirmRestoring() -> Refusal?
```

Every one exists and keeps its signature; only behaviour moves. The second is `RosterStore`'s.

### One mend, run by the put and by the reader

One package-internal mend over one identity's eras — cut to the day before the kept era in front,
drop what then holds no day unless it is the newest, join alike neighbours — is what `put` runs after
putting the era on and what `formRoster()` and `folded()` run on each identity before answering.
The duplicate-shape guards in both go: after the mend no two eras of one identity share a day kept
from, so they can no longer fire. `folded()`'s guard against two kept-or-stopped entries alike in
every part stays, because those mint two identities its record map cannot tell apart.
- *Mend on read only:* rejected — the roster in memory would differ from the one read back after
  the write, the round-trip failure #303's fold shipped.
- *Collapse in the screen only:* rejected — `put` would still build what the reader must mend.

### Alike is the schedule at the roster, the rhythm at the screen

The roster joins eras equal in schedule and kind, so a restart (same interval, new start) never
joins the era it restarts. The screen decides the change back: where the era the new one would give
way to, after the drop, has the asked rhythm and kind, it puts on no era, keeping that era's start.
- *Join on rhythm at the roster:* rejected — a restart would fold into the count it restarted.

### A change before a future day kept from keeps that day

The new era is kept from the later of `dayToKeepFrom` and the day the commitment is kept from, after
any day-move in the same save, and an interval era starts there (settled 7).

### The restart's already-due check stays on the newest era

Today's code asks the commitment's newest era, whose own floor makes any day behind it not due; the
delta writes that down rather than asking the era holding the day. That refusal exists because a
restart there changes nothing, and a restart reaching behind a later era always changes something.
- *The era holding the day:* rejected — it refuses a reach the owner chose to keep (settled 8).

### No ADR of its own

ADR-1059 said what an era is, and is amended in place. The restart bound this reverses lives only
in `CONTEXT.md` § *Restarting*, which the grill already amended; no ADR held it.

### Migration

No form changes. A roster on a phone in any shape the mend reads is read mended on every open, its
place untouched, and written mended at the next change kept. A copy is mended when restored. A
roster the duplicate guard locked out reads again; nothing a person saw is lost.

## Risks / Trade-offs

- [A same-day change taken back loses a same-day restart it replaced] → accepted: that restart's era
  held no day once the change replaced it.
- [Carried test *a look-back chains every era of the commitment it was asked about* puts three alike
  eras, which now join and pass for the wrong reason] → tasks.md § 1 gives them differing schedules.
- [Carried scenario *a commitments screen whose roster holds what could not be a roster says it is
  not keeping one* says "the form this app writes" of a form-4 fixture; read as form 6 it would now
  mend] → its test is form 4 and stays refused; its wording is not this Story's.
- [Two carried requirements under new headings, and one MODIFIED, stay over the prose budget] →
  condensing is an editorial Story's (ADR-1047); only the sentences this rule falsified moved.

## Open Questions

None. `grill.md` left nothing open, and writing the delta turned up no preference whose answer would
change it; the restart check and the future-day rule were settled from today's behaviour and settled 7.
