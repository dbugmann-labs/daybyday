## Context

See `proposal.md` § *Why*, and `grill.md`, whose eleven settled answers and layout this delta is
written on. The facts it turns on, read off `origin/main` at df27843:

- **One private function is the floor.** `DayScreen.reachEarliest(asIfShown:)` answers the earlier of
  `roster.earliestKeptFrom ?? today` and the day handed. Three readers: `showDay(_:)`'s guard,
  `weekPageLanding(.before)`, and `weekStrip(asIfShown:markShown:)`'s `isOffered`.
- **The shell reads the floor once**, as the day picker's `in:` range; it reads
  `dayPickerReach.opensOn` as "the day being shown" in six places, and carried tests do 69 times.
- **`Roster.earliestKeptFrom`** is the roster's answer, `nil` where it holds no commitment; a roster
  that cannot be read is held as an empty one, so it answers `nil` too.
- **`WeekStripDay`** carries `isShown`, `isToday`, `isOffered` and `isAway`. Carried tests read it
  field by field and never construct one, so a fifth field breaks none of them.
- **The mark and the days-away dot never fall on one day** (`grill.md`, facts found), so the dash can
  take the dot's slot.
- **`CalendarDate` forms 1583 to 9999 only**, and 1 January 1583 is a Saturday; `DayScreen` already
  holds the last date privately as `lastSupportedDate`.
- **`openspec` 1.10.0 refuses a MODIFIED block that drops a scenario** (ADR-1047 decision 2).

## Goals / Non-Goals

**Goals:** the delta, every rule driven through `DayScreen`, and the shell drawing option B.

**Non-Goals:** a mark on the day picker (settled 6); any spoken word for the mark (settled 11); the
picker's forward end; renaming `Reach` in code; condensing the carried requirements.

## Decisions

### The seam

```swift
public let DayScreen.WeekStripDay.isEarliestKeptFrom: Bool
public var DayScreen.dayPickerReach: Reach
public func DayScreen.showDay(_ day: CalendarDate)
public func DayScreen.showPreviousWeek()
public var DayScreen.weekStrip: [WeekStripDay]
public var DayScreen.previousWeekStrip: [WeekStripDay]?
public var DayScreen.nextWeekStrip: [WeekStripDay]?
```

The first is new; the rest keep their signatures and change what they answer. A scenario's "marks D
as the earliest day anything on its roster is kept from" reads `isEarliestKeptFrom`.

### The picker keeps its answer, whose earliest day is now a constant

`dayPickerReach` and `Reach` stay as they are, and `earliest` is always 1 January 1583. It is the
existing seam: the shell's picker range reads it unchanged, and no carried `.opensOn` assertion
moves. *Reach* retires as a domain term in `CONTEXT.md`, and in code the name keeps only its plain
English sense, how far the picker goes back.
- *`dayPickerOpensOn` plus a public first-date constant on `CalendarDate`:* rejected. It adds a new
  seam and a member on `schedule`'s type, and edits 69 carried assertions, all for a name.
- *No earliest day at all, the shell bounding the picker itself:* rejected, because the shell would
  then know the calendar's range, which ADR-1019 rules out.

### One landing rule each way

`weekPageLanding(.before)` becomes the twin of `.after`: the same weekday where it exists, else
1 January 1583 where the target week holds it, by the offset arithmetic it already uses, else `nil`.
The floor then drops out of all three readers, and `reachEarliest(asIfShown:)` goes. The neighbour
strips are formed by the same `weekStrip(asIfShown:markShown:)`, so they carry the mark as well,
which `grill.md` asks for under *Found while drawing*.

### The mark is the roster's answer, read where the strip is formed

`isEarliestKeptFrom` is `date == roster.earliestKeptFrom`, computed beside `isAway`, so a `nil`
answer marks nothing (settled 9). Nothing is stored, so the mark follows every roster read.
- *The today as a stand-in where the roster answers none, as the floor had:* rejected (settled 9).

### Readings the delta makes of the settled answers

- **Settled 2's "every past day"** leaves the picker's forward end where it is, the last date.
- **Settled 8's "wherever it falls"** includes the day shown and the today. The dash then sits in the
  capsule, which is how the wireframe draws it.
- **A title naming "the earliest day its day picker reaches" is kept** wherever its body still holds,
  so its test keeps its name.

### Four requirements are renamed so that their floor scenarios can go

Four requirements each lose scenarios about the floor: *shows a day picked*, the one-offs, the strip's
offers, and the neighbour strips. `openspec` refuses that through MODIFIED, so each one is REMOVED and
then ADDED under a new heading, carried whole less those scenarios. Each lands at the foot of the spec
file.

### The shell

In `ContentView.weekStripDay(_:isInteractive:)`, a day where `isEarliestKeptFrom` draws a 10×2pt
`Capsule` in the bottom overlay slot the dot uses. It is `.secondary`, or the text colour where the
day is shown, the same as the dot. The opacity line is left as it is: only a day with no date fades.
The accessibility label stays the full date (settled 11), and the picker sheet is unchanged. Comments
naming the floor are corrected, and nothing else moves.

### What the shell draws

Option B, *Dash under*, from https://claude.ai/artifact/Ufy5JFguE11pzsDuYe7phK.

```
B · Dash under
  ‹   M    T    W    T    F    S    S   ›
     (14)  15   16   17   18   19   20
                ▬         ·                    a short grey dash in the dot's slot under the number
  shown on the marked day:
  ‹   M    T   (W)   T    F    S    S   ›
      14   15  (16)  17   18   19   20
               (▬)        ·                    the dash inside the capsule, in its text colour, as the dot is
```

## Risks / Trade-offs

- [A type named `Reach` outlives the term] → the decision above says why. An editorial Story may
  rename it.
- [A carried test that uses `showDay` or a page back as a shortcut may have relied on a refusal] →
  any carried test that turns red, other than those `tasks.md` § 2.2 deletes and its five
  *rewritten* boxes, is a stop.
- [A graphical picker running back to 1583 is a long way to scroll] → its month-and-year wheel
  reaches that far in a few turns, and the stock control is kept (settled 6).
- [The renamed requirements move to the foot of `day-screen`'s spec] → accepted, as in earlier
  Stories.

## Open Questions

None. `grill.md` § *Left open* is "None.", and writing the delta turned up no question of preference
for the owner. The readings above follow from settled answers, so they are recorded here rather than
asked.
