## Context

See `proposal.md` § *Why*, and `grill.md`, whose thirteen settled answers this delta is written on.
The facts the shape turns on, read off this worktree at `origin/main` c88d19e:

- **`LookBack` cannot carry a happening.** Its `rhythmInWords` and `keptFromInWords` are not
  optional, and `LookBack.form(for:keptUntil:entries:today:history:)` walks a roster entry's eras.
- **`CommitmentsScreen` already holds what the page needs:** `happeningStore`, read at `init` and
  at `shown(asOf:)`, and `dayToKeepFrom`, the day it holds. `ContentView` makes a fresh screen each
  time the commitments screen opens, so occurrences noted on the day screen are read then.
- **The words exist.** `LookBackWords.day`, `month` and `number` are internal, and
  `Occurrence.timeInWords` says "18:40" or "no time" exactly as a happening row does.
- **`Happenings.note(_:)` has no date bound**; only `DayScreen.note(...)` refuses a day not yet
  come. A store can hold an occurrence after the day a screen holds once the clock has moved back.
- **The shell's happening row is a `Text` with a leading swipe** (`CommitmentsView.swift`), and
  `LookBackView.swift` draws the head card, the month `Grid` and the folded note cards, with
  `FoldMeasurer` private to that file.

## Goals / Non-Goals

**Goals:** a happening's look-back, every rule drivable through `CommitmentsScreen.lookBack(at:)`,
reading the store as it stands and writing nothing.

**Non-Goals:** no change to any commitment's look-back or to `LookBack`; nothing entered from the
page (settled 9); no stop or delete (#379); no copy of happenings (#380); no change to the store's
form.

## Decisions

### The seam

```swift
public struct HappeningLookBack: Hashable, Sendable
public let name: String  // on HappeningLookBack
public let sinceInWords: String?  // on HappeningLookBack
public let countInWords: String?  // on HappeningLookBack
public let months: [Month]  // on HappeningLookBack
public let occurrences: [SaidOccurrence]  // on HappeningLookBack
public struct Month: Hashable, Sendable { public let inWords: String; public let countInWords: String }  // in HappeningLookBack
public struct SaidOccurrence: Hashable, Sendable { public let dayInWords: String; public let timeInWords: String; public let note: String? }  // in HappeningLookBack
public func lookBack(at happening: Happening) -> HappeningLookBack?  // on CommitmentsScreen
static func times(_ count: Int) -> String  // on LookBackWords, internal
```

### A value of its own, asked through the look-back's own name

`HappeningLookBack` stands beside `LookBack`, and `CommitmentsScreen` answers it through an
overload of the `lookBack(at:)` it already has, so the existing seam keeps its name and its callers.
The screen resolves the happening by identity among those it lists and reads its held store.
- *Rejected:* optional rhythm and kept-from fields on `LookBack` — every carried look-back test and
  `LookBackView` would move for a page that shares none of its rules.
- *Rejected:* a member on `HappeningStore` — the shell would have to hold a place, and the screen
  already holds the store and the day.

### Ties within a day are broken newest noted first

Settled 4 orders a day by latest time, with no time last. Two alike times, or two with no time,
are said latest noted first, so the page reads newest first all the way down. A stable sort by
day and time over the occurrences reversed gives exactly this.
- *Rejected:* the noted order kept — it reads oldest first inside a page that is newest first.

### An occurrence after the day the screen holds is said and counted

Settled 2 ends the months at the current month. Only a clock moved back can leave an occurrence
later than that, and dropping it would hide a record a person made; so its month ends the run
instead, and the count and the months still agree.
- *Rejected:* drop it from the page — a silent loss the person cannot explain.
- *Rejected:* list it but stop the months at the current month — the months would no longer sum
  to the count.

### Answered while the roster cannot be read

The happening place is a store of its own, and a screen that cannot read its roster already lists,
makes and renames happenings; its look-back follows. Only an unreadable happening place answers none.

### Words live in the Kit

`LookBackWords.times(_:)` says "6 times", "1 time" and "0 times"; the page draws them as given
(ADR-1019). "Nothing noted yet." is the shell's sentence, as "No note yet." is on a note's page,
drawn where `occurrences` is empty.

### The shell

The happening row becomes a `NavigationLink` to `HappeningLookBackView(screen:happening:)`, keeping
its leading swipe; the list draws its grey chevron. The view lives in `LookBackView.swift` beside
`LookBackView`, so it shares `FoldMeasurer`; the head card's row and the month table are lifted to
file scope where both views need them, and a commitment's page draws exactly as it does now. The
name is the large title. The head card holds one row, "Since" and `sinceInWords`. Under it, a
"Months" heading and one row per month, its count right-aligned in monospaced digits; then
`countInWords` as a headline and one card per occurrence: its day in caption semibold, its time on
the right, its note beneath folded to two lines, a cut one opening in place on a tap as a note's page
does. Where `occurrences` is empty the page is the title and "Nothing noted yet." alone.

### What the shell draws

Option A, *Two lists*, from https://claude.ai/artifact/25ZuEcDrHDgG2TMkQaGxKQ.

```
A · Two lists
┌──────────────────────────┐
│ (‹)                      │
│ Kopfweh        large tit.│
│┌────────────────────────┐│
││Since     14 July 2026  ││   ← settled 11; the mockup drew "since 14 July 2026  (sec)" here
│└────────────────────────┘│
│                          │
│ Months         headline  │
│ October 2026     2 times │
│ ──────────────────────── │
│ September 2026   0 times │
│ ──────────────────────── │
│ August 2026      3 times │
│ ──────────────────────── │
│ July 2026         1 time │
│ ──────────────────────── │
│                          │
│ 6 times        headline  │
│┌────────────────────────┐│
││2 October 2026     18:40││
││Behind the left eye ... ││
││  (2 lines, tap opens)  ││
│└────────────────────────┘│
│┌────────────────────────┐│
││2 October 2026   no time││
│└────────────────────────┘│
│┌────────────────────────┐│
││28 August 2026     07:15││
││Woke up with it.        ││
│└────────────────────────┘│
└──────────────────────────┘
Empty:  (‹) / Kopfweh / Nothing noted yet.
```

## Risks / Trade-offs

- **The likeliest wrong implementation takes "since" from the first occurrence noted.** → The count
  scenario notes the earliest day last.
- **The second reverses the day screen's order within a day**, putting no time first. → A scenario
  holds five on one day, ties and no-time included.
- **The third stops the months at the latest occurrence**, losing the run of empty months the page
  exists for. → The months scenario asks again as of a later month.
- **Lifting the head card and month table can move a commitment's page.** → Task 5.2 holds every
  commitment page unchanged; the walk does not show one.

## Open Questions

None. `grill.md` § *Left open* is "None." with the reason, and the two edges writing the delta
reached — ties within a day and an occurrence after the day the screen holds — are decided above,
since neither is a preference the owner holds: each has one answer that loses nothing. No residual
round is outstanding.
