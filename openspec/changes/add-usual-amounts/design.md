## Context

See `proposal.md` § *Why*, and `grill.md`, whose settled answers 1–13 this delta is written on. The
facts the shape turns on, read off this worktree:

- **A record carries its commitment whole.** `RecordDocument` writes a `CommitmentRecord` — name,
  schedule, day kept from, kind and identity — on every tick, number, note and day of additions, and
  `SaveInProgress` writes two more. A part added to `Commitment` lands in all of them.
- **Equality is the identity** (ADR-1059), so a `Commitment`, a `DayView.Row` holding one and a
  `Roster` all compare equal across anything that is not an identity, an entry's day kept until or
  its category. `RosterStore.rename` already has to judge "changed" by the name for this reason.
- **A category lives on `Roster.Entry`, beside the era**, and `RosterDocument` writes it on every
  entry record; the roster writes form 6, and `RosterStore.init(at:)` checks each key against the
  form it declares.
- **The copy nests `RosterDocument` whole**, so a copy carries whatever the roster form carries.
- **`DayScreen` always forms its day view with its roster** (`formDayView`); the public `DayView`
  initializers have none.
- **The total entry is a system alert** in `ContentView`, holding the field, Save, *Take back last*
  and Cancel, with `soFarOfTarget` as its message.

## Goals / Non-Goals

**Goals:** every rule the grill settled under Kit test at an existing seam where one exists; the shell
drawing layout C and deciding nothing.

**Non-Goals:** usual amounts on a number (grill 5); a name kept on the day (grill 3); reordering on
the sheet (grill 9); any change to the record's form, the copy's form, `restore` or `look-back`.

## Decisions

### The seam

```swift
public struct UsualAmount: Hashable, Sendable                                  // Commitment
public let amount: Decimal                                                     // Commitment.UsualAmount
public let name: String?                                                       // Commitment.UsualAmount
public init?(_ amount: Decimal, named name: String?)                           // Commitment.UsualAmount
public func usualAmounts(of commitment: Commitment) -> [Commitment.UsualAmount]                      // Roster
@discardableResult public mutating func declare(_ usualAmounts: [Commitment.UsualAmount], for commitment: Commitment) -> Bool  // Roster
public struct TypedUsualAmount: Equatable, Sendable { public init(amount: String, name: String) }  // CommitmentsScreen
case usualAmounts                                                              // CommitmentsScreen.SheetField
case usualAmountIsNotAnAmount(Int), usualAmountAlike(Int), moreThanFiveUsualAmounts(Int)          // CommitmentsScreen.Refusal
public let usualAmounts: [Commitment.UsualAmount]                              // CommitmentsScreen.Change
public func define(name:on:keptFrom:under:kind:lowest:highest:target:usualAmounts: [TypedUsualAmount] = []) -> Refusal?
public func change(_:toName:on:keptFrom:under:lowest:highest:target:usualAmounts: [TypedUsualAmount]? = nil) -> Refusal?
public struct UsualAmount: Hashable, Sendable { public let amount: String; public let name: String? }  // DayView
public let usualAmounts: [DayView.UsualAmount]                                 // DayView.TotalEntry
public func add(_ usualAmount: DayView.UsualAmount, on row: DayView.Row) throws  // DayScreen
```

`nil` for `change`'s `usualAmounts` is the ones the commitment already declares, as `nil` for
`target` already is, so every carried test compiles unedited. The `Int` on each refusal is the usual
amount's place, from zero, in the list handed in, blank ones counted.

### Usual amounts are the roster's, held on each entry beside the category

`Roster.Entry` gains the list, written alike on every era by `declare` and carried by every act that
forms an entry; `RosterEntryRecord` writes it. Entry equality then covers it, so `nextRoster !=
roster` sees a change, and deletion takes it with the entries.
- *Rejected:* a sixth part of `Commitment` — it would ride on every record's `CommitmentRecord`,
  moving the record's form and freezing a stale list on each tick, the refusal ADR-1023 made.
- *Rejected:* part of the total kind — changing one would put an era on, against grill 6.
- *Rejected:* a map on `Roster` keyed by identity — a second structure every era act must keep in step.

### One sheet field, and the refusal names the row

`SheetField.usualAmounts` is the whole card, so *What a commitments screen tells on its sheet lasts
until that field is edited* holds unchanged while rows are added and taken away; the row a refusal is
drawn under rides on the refusal. The screen reads the rows after the target, before its stopped guard
and the roster, and hands `Roster.declare` a list it has already judged.
- *Rejected:* `SheetField.usualAmount(Int)` — taking a row away shifts every later index.

### Decided from the settled answers while writing the delta

A row with both fields blank is no usual amount, as both range ends blank is no range: the sheet's
*Add usual amount* leaves a row a person may never fill. Two names of one amount order by the
judgment grill 12 already makes of two names — case and end blanks disregarded, then character by
character — since no collator exists outside birthdays. The entry says each amount in the Kit's
words, as `soFarOfTarget` does (ADR-1019). `canChangeMoreThanNameAndCategory` keeps its name, its
doc comment adding the usual amounts: renaming it touches every caller for no behaviour.

### The shell (ADR-1019: no rule the Kit does not state)

**The commitment sheet** draws, while the kind chosen is Total, a second card under the first: one
row per usual amount, an amount field (`.numbersAndPunctuation`, as the target's) then a name field
with the placeholder "Name", filled from `Change.usualAmounts` in their order, and *Add usual amount*
as the card's last row, never hidden. A row is taken away by swiping it. Any edit, add or removal
tells `.usualAmounts` edited. A refusal is drawn under the row its `Int` names, in the sheet's red:
"That's not an amount.", "You already have that one." and "Five usual amounts at most." The card is
editable on a stopped total, whose refusal now reads "Take it up again first to change anything
but its name, category or usual amounts."; the rows are sent as typed on Save, blank ones included.

**The total entry** leaves the alert for a half-height sheet over the dimmed day, as drawn below:
Cancel and Save either side of the row's name, `soFarOfTarget` under it, the Amount field focused as
the sheet opens so the keyboard is up, the usual amounts in a list under it — amount column, then the
name — and *Take back last* in red below, only where `offersTakeBackLast` says. Save commits the
field through `enter(_:on:)`; a tap on a usual amount calls `add(_:on:)`; either closes the sheet, as
*Take back last* does, and a refusal is told on the row as today. No confirmation before a tap.

### What the shell draws

Option C, a half-height sheet, chosen at the layout round from
https://claude.ai/artifact/PSyixPF6zQg3RgjgJkQVLp, with the owner's one change: the keyboard up.

```
┌──────────────────────────────┐
│ [dimmed day screen, top half]│
│╭────────────────────────────╮│
││            ▬▬              ││
││ (Cancel)   Protein   (Save)││  title = row name
││           30 of 120        ││  subtitle = soFarOfTarget
││ ┌────────────────────────┐ ││
││ │ Amount                 │ ││  focused as the sheet opens; keyboard up (owner's change)
││ └────────────────────────┘ ││
││ ┌────────────────────────┐ ││
││ │ 20                     │ ││  amount column, then name;
││ │ 30   Shake             │ ││  smallest first; tap adds
││ │ 35   Müesli            │ ││  and closes
││ │ 40   Greek yoghurt     │ ││
││ │ 45   Chicken breast    │ ││
││ └────────────────────────┘ ││
││ ┌────────────────────────┐ ││
││ │ Take back last         │ ││  red
││ └────────────────────────┘ ││
│╰────────────────────────────╯│
└──────────────────────────────┘

 (Cancel)   Change Protein   (Save)
┌──────────────────────────────┐
│ Protein                      │
│ [Tick|Number|Note|•Total]    │
│ 120                          │
│ Category (optional)       ⌃⌄ │
└──────────────────────────────┘
┌──────────────────────────────┐
│ 20       Name                │
│ 30       Shake               │
│ 35       Müesli              │
│ 40       Greek yoghurt       │
│ 45       Chicken breast      │
│ 50       Rice                │
│ ‹refusal under the row›      │
│ Add usual amount             │
└──────────────────────────────┘
┌ [Weekdays|Monthly|Every N|Per week] …
```

### Migration

The roster form moves to 7: every entry record carries `usualAmounts`, a list of an amount written as
a target is and a name or `null`, empty where none. Forms 1–6 read as declaring none and are left
byte-for-byte until the next kept change writes form 7. The record place, the one-off place, the
birthday place and the copy's own form do not move; a copy made after this nests roster form 7.

## Risks / Trade-offs

- **A row, a roster or a list redrawn stale after a change of usual amounts alone**, under identity
  equality. → The different-rows scenario; the list on the entry, never read off the commitment.
- **An era put on without the new usual amounts.** → The store refuses eras that disagree, and the
  one-save target-and-usual-amounts scenario reopens the store.
- **Carried roster-store tests whose fixtures declare form 6 as "the form this app writes".** → Box
  1.2 moves them to form 7 and nothing else; any other red is a stop.
- **Five usual amounts under a raised keyboard not fitting half a screen.** → Grill 7 makes a walk
  that scrolls to the fifth a G7 finding, not a licence to scroll.
- **Draft PR #361 moved the same entry to a sheet**; the two collide if it is revived.

## Open Questions

None. `grill.md` § *Left open* is "None.", and the keyboard rising is a `phone:` line rather than an
open question. Writing the delta turned up two edges — a row left blank, and the order of two names
of one amount — and both are decided above from the range precedent and grill 12, so no residual
round is outstanding.
