## Context

Motivation is in `proposal.md` § *Why*; the behaviour contract is `specs/day-screen/spec.md` and is
not repeated here. The grill that settled the questions this delta rests on is `grill.md` in this
folder — ten questions over three rounds on 2026-09-06, with `## Left open` reading "None." and its
three deliberate exclusions named.

`DayByDayKit` exports seven seams today: `Schedule.isDue(on:)` (#8, #9, #10, #11), `Commitment`
(#42), `Tick`/`History` (#55), `RecordStore` (#56), `RosterStore` (#103), `DayView` (#70, widened by
#71, #72 and #92) and `DayScreen` (#91, widened by #92, #93 and #103). Five facts about what is
already shipped shape everything below, and each was read out of the sources on 2026-09-06 rather
than recalled:

- **`DayScreen.tick(_:)` already throws, and already has all three guards.** It returns early when
  the row is not one `dayView` holds, when `recordStore` is `nil`, and when `row.tick(asOf: today)`
  is `nil`; it throws only from `recordStore.add`/`remove`. So the three places a tap is *silent* by
  requirement are already three `return`s, and the one place a refusal happens is already one
  `throw`. The delta's third requirement is those three `return`s, and its first is that `throw`.
- **`RecordStore.write` collapses every write failure into `RecordStoreError.cannotWrite(at:)`** —
  but only inside its `do`. `try encoder.encode(document)` sits **outside** it, so an encoding
  failure escapes as `EncodingError`. This does not change the delta, because nothing here reads the
  error at all; it is why `docs/open-questions.md` owes an entry (`tasks.md`'s closing note).
- **`DayScreen` is `@MainActor @Observable`**, and `dayView` is `public private(set) var`. A new
  `public private(set) var` therefore redraws the shell when it is assigned, with no extra work.
- **`DayView.Row` is `public`, `Hashable` and `Sendable`**, and its `commitment` and `date` are
  internal to the package. So a row is comparable by value from `src/DayByDay`, and carries no
  identity beyond its value. `ContentView.swift` already works around exactly that in its `ForEach`
  (`id: \.offset`), for the reason `docs/open-questions.md` § *The shell identifies rows by
  equality* records.
- **`RecordStore.init` treats a place where no file exists as an empty store.** A path beneath an
  existing ordinary file therefore opens as `.kept` with nothing in it and refuses every write —
  which is why the shipped scenario *a change that cannot be kept is refused…* works, and why it is
  the delta's workhorse place.

**Measured on this machine on 2026-09-06 rather than recalled.** `cd src/DayByDayKit && swift test`
reports **300 tests passing** at `566297e`, on Apple Swift 6.3.3 (swiftlang-6.3.3.1.3), target
`arm64-apple-macosx26.0`; `openspec` is 1.10.0 and `node --version` is v24.19.0.

**The two places this delta needs, both proved on this machine on 2026-09-06** rather than assumed:

1. *A place where nothing can be written* — `<dir>/blocker/record.json` where `blocker` is an
   existing ordinary file. Already the idiom in `DayScreenTests.swift:209`.
2. *A place that can be read from but not written to, and can then be made writable* — an ordinary
   file in a directory whose POSIX permissions are set to `0o500`. Proved end to end: reading a file
   inside such a directory succeeds; `FileManager.createDirectory(at:withIntermediateDirectories:
   true)` on it **also succeeds**, so `RecordStore.write` reaches its `data.write` and fails there
   with `NSCocoaErrorDomain 513` / `EACCES`, which it turns into `cannotWrite`; and setting the
   directory back to `0o700` makes the next write land. Without that last part, three of this
   delta's scenarios — the ones where a change is refused and then a later change *is* kept — cannot
   be set up at all, which is why it was checked before the delta was written rather than after.

Every date this delta pins was checked twice on 2026-09-06, once in Python's proleptic Gregorian
calendar and once in Foundation's own `.gregorian` calendar under UTC — the calendar `CalendarDate`
uses — and both agree in every case: **Saturday 1 January 1583**; Thursday 1 January 2026; **Sunday
30 August 2026**, **Monday 31 August 2026**, **Tuesday 1 September 2026**, **Wednesday 2 September
2026**; **Friday 31 December 9999**.

## Goals / Non-Goals

**Goals:**

- A refused tap is visible to the person who made it, on the row they made it on.
- The refusal still reaches the caller, so a shell written later cannot make the app silent again
  without a test going red.
- The three ends of what is told are one rule each, and the "day being shown changing" end is
  written so that a move with nowhere to go cannot accidentally trip it.
- Nothing that already passes changes: all 300 existing tests stay green and **unedited**.

**Non-Goals:**

- **Telling a cause.** Not which of making and taking back was asked for, and not why the place
  refused. Settled at the Feature grill on ADR-1021's reasoning and re-settled here.
- **A second notice.** At most one row at a time, always the last tapped.
- **Giving a row an identity.** Settled item 10: where two rows of one day view are equal, both are
  told of, and changing that is a Story of its own against
  `docs/open-questions.md` § *The shell identifies rows by equality*.
- **Changing what the screen says about keeping a record.** A refused write is not a store that will
  not open, and the screen must never guess otherwise.
- **Making a day that has not arrived stop inviting the tap.** That is B-028's territory, and this
  delta only requires that such a tap is silent.
- **Wording, colour, placement or animation in the shell.** `tasks.md` § 3, drawn under ADR-1019 and
  covered by no scenario, exactly as #92's title and #93's controls were.
- **Fixing `RecordStore.write`'s unwrapped encode.** Recorded, not fixed — `tasks.md`'s closing note.

## Decisions

### The seam

**Widened, not new: `DayScreen` gains one public stored property and no method.** An existing seam
beats a new one (`AGENTS.md` § *Vocabulary you need before Stage 4*), and every scenario in this
delta is a question about a day screen.

```swift
@MainActor @Observable public final class DayScreen {
    /// The row a change was last refused on, or `nil` when there is nothing to tell. Set when
    /// `tick(_:)` throws; cleared by `shown(asOf:)`, by a change that reaches the record's place,
    /// and by the day being shown changing. Carries no cause: there is nothing here to read but
    /// which row, which is the whole of what a person is told.
    public private(set) var refusedChangeRow: DayView.Row?
}
```

One optional, and **nothing else**. No `RefusalReason`, no message string, no count, no `Bool`
alongside it.

- **A `DayView.Row?` rather than an index.** Settled item 10 requires that two rows of one day view
  that are equal are *both* told of. An index tells exactly one of them, so the row-by-value shape is
  not a preference — it is the only shape that satisfies the settled answer, and it satisfies it
  structurally rather than by a rule anyone can forget. It also matches what the shell already has:
  inside its `ForEach` it holds a `row` and can write `row == screen.refusedChangeRow`.
- **No cause, because no cause is representable.** "Every refusal is told the same way" and "it does
  not say which of make or take-back failed" are the two settled answers hardest to keep true under
  a later edit — someone adds a nicer message, and the requirement quietly dies. An `Optional<Row>`
  has nowhere to put one. That is why this delta has no scenario asserting the *absence* of a cause:
  the shape asserts it, and a test cannot assert the absence of something that does not exist.
- **Public, because the shell is the only reader** and there is no other way for it to draw
  anything. `private(set)` because nothing outside may set or clear it: the three ends are this
  capability's, not a caller's.
- **Named for the change and not for the tick.** `tick(_:)` covers making and taking back, and
  settled item 4 widened the clearing rule to *any* change that lands, so `refusedChangeRow` is the
  name that stays true. The Story is called `add-refused-tick-notice` because that is the want's
  name (B-027), not because the property should be.

**Rejected: an enum `Notice` on the screen** (`case none / case refusedChange(DayView.Row)`). It is
the same information with a name that invites a second case, and the first thing a second case would
be is the cause this delta exists to refuse.
**Rejected: putting it on `DayView.Row`.** A `DayView` is formed from commitments, a date and a
history; it cannot know a write was refused without being handed something that is not one of those,
and it is a value that gets thrown away and rebuilt on every change. That it *cannot* hold this is
the cleanest argument that the notice is the screen's.
**Rejected: a callback or a thrown error the shell renders.** The shell already gets the throw and
already discards it; `docs/open-questions.md` § *No UI smoke layer* means anything the shell holds
alone is untested by construction. The whole point of a fact on the screen is that twenty scenarios
can reach it.

### The three ends, and the one that is easy to get wrong

Every end is one assignment of `nil`, and where each goes is decided by *what changed*, never by
*which method was called*:

| Where | Why |
|---|---|
| `shown(asOf:)` | inherited: nothing survives being shown but the commitments, the two places and the day being shown |
| `tick(_:)`, on the line after the write succeeds | a change reached the place |
| `showPreviousDay()` / `showNextDay()`, **inside** the `guard let` | the day being shown changed |
| `showToday()`, **only when `shownDay != today`** | the same rule, stated for the one move that never refuses |

The last row is the trap. `showToday()` today reads:

```swift
public func showToday() {
    shownDay = today
    dayView = dayViewOfShownDay()
}
```

It has no `guard` and never refuses, because going back to today always has somewhere to go — that
is a shipped requirement in as many words. So the obvious edit, clearing at the top of every move,
is **wrong**: it would clear on a screen already showing today, where settled item 2 says what is
told stands. The scenario *what a day screen tells on a row stands when a day screen showing today
is sent back to today* is red on exactly that implementation, and it is the most important test in
this change.

The two stepping moves have the opposite shape and are safe by construction: their `guard let ...
else { return }` already means "nowhere to go", so putting the clear inside the guard makes the
requirement fall out of the control flow rather than out of a comparison. This is why the delta says
**the day being shown changing** rather than "a move": the gesture is not the rule, and phrasing it
as the gesture is what produces both bugs at once.

### Why a refused change leaves `recordState` alone

`recordState` is assigned in exactly two places, `init` and `shown(asOf:)`, and both assign it from
`Self.open(at: recordPlace)`. This delta adds no third. Settled item 9 is therefore satisfied by not
writing a line, which is the best way to satisfy anything — and the scenario *a refused change does
not change what a day screen says about keeping a record* is the guard against someone later
"improving" the screen by setting `.unreadable` when a write fails. That would be the screen
guessing that a refused write proves a store that will not open, which it does not: a full disk
refuses a write and opens the record perfectly.

### Where the notice is *not* raised, and why that is three `return`s and not a rule

`tick(_:)`'s three existing guards are, in order: the row is not held; there is no store; the row
offers no tick. Each is a settled silence (items 5, 6 and the shipped "changes nothing at all"), and
each is already a bare `return`. **So requirement three of this delta is implemented by changing
nothing at all**, and its five scenarios exist to hold that shape against a later edit that raises
the notice at the top of the method — which is where a person adding it would naturally put it.

The order matters and the delta pins it: the row-not-held guard comes before the no-store guard,
which comes before the no-tick guard. The scenario *a tap on a row for a day that has not arrived is
told nothing on the row* is set up at a place that **cannot be written**, so it fails an
implementation that reached the store before checking the row — it would raise the notice on a tap
the delta requires to be silent.

### How the shell draws it

Inside the existing `ForEach`, one comparison and one `Text`:

```swift
if row == screen.refusedChangeRow {
    Text("Not saved. Try again.")
}
```

Under the row's name, per `CONTEXT.md` § *Day screen*. The `try?` on `screen.tick(row)` **stays** —
the screen is what does the telling now, and a `do/catch` in the shell that said anything of its own
would be the shell inventing a requirement, which is what `docs/open-questions.md` § *The shell
swallows the one failure a tick reports* actually objected to. It objected to nothing being said,
not to the `try?`. The exact words, the placement and the styling are `tasks.md` § 3's and carry no
scenario, exactly as #92's title and #93's controls did.

### Twenty scenarios, split by what can be wrong on its own

**Five on raising** — that it happens at all and reaches the caller too, that it lands on the row
tapped and no other, that a take-back is no different, that a second tap moves it, and that it
leaves `recordState` alone. **Ten on the lifetime** — two on being shown again (including where the
record has since become unreadable, because being shown re-forms everything from the place), three
on a change landing (the same row again, another row, and a take-back — the three faces of settled
item 4), three on the day being shown changing (each step and the way home), and two on the cases
that must *not* end it (both ends of the calendar, and going home from home). **Five on silence** —
a screen not keeping a record, a screen holding a later version's record, a row for a day that has
not arrived, and a foreign row twice, once for raising nothing and once for ending nothing.

## Risks / Trade-offs

- **Clearing at the top of every move.** The single most likely implementation, and it breaks
  settled item 2 in two places at once → mitigated by *stands when a move has nowhere to go* and
  *stands when a day screen showing today is sent back to today*, both red on it, and by
  § *The three ends* saying where each clear goes and why.
- **Clearing at the top of `tick(_:)`.** Equally natural, and it breaks two different requirements:
  a tap on a foreign row would end what is told, and a second refused tap would leave nothing behind
  → mitigated by *does not end what is already told* and *a second refused tap is told on the row
  tapped last and no longer on the first*.
- **Clearing before the write rather than after it.** Then every refusal would clear the notice it
  is about to set, which happens to still work — and then stops working the moment anyone reorders
  the two lines → mitigated by putting the clear *after* a successful write in the same branch, and
  by *what a day screen tells on a row ends when the same change is made again and is kept* being
  the only scenario that pins the successful path's clear.
- **A stale row.** What is told names a row by value, and the day view is re-formed on every change
  that lands. If a clear were ever missed, the shell would compare a row that is no longer in the
  list and simply draw nothing — a silent failure rather than a loud one → mitigated by every one of
  the ten lifetime scenarios asserting `refusedChangeRow` directly at the seam rather than through
  what the shell would draw.
- **Two equal rows are both told of.** Accepted, and it is settled item 10 rather than a defect of
  this change. It cannot bite today: the day-one week has no two commitments alike in name, schedule
  and kept-from day. It is the same gap `docs/open-questions.md` § *The shell identifies rows by
  equality* already records, and it stays there.
- **The permission-based place is the only new test mechanism in this change**, and a test that
  leaves a directory at `0o500` behind makes the next run of an unrelated test unreadable → mitigated
  by each such test using a fresh UUID-named directory and setting it back to `0o700` before it
  returns, and by `tasks.md` naming that explicitly. It was proved working on this machine before
  the delta was written (§ *Context*), which is the other half.
- **The shell is still uncovered by any test.** `docs/open-questions.md` § *No UI smoke layer*,
  unchanged. This change adds one conditional `Text` to that exposure. `tasks.md` § 3 requires a
  simulator run against a place that cannot be written, and a written record of what was seen —
  which is the only way anyone finds out whether the message is legible where it is drawn.
- **`RecordStore.write` can still throw something that is not a `RecordStoreError`.** Accepted and
  recorded rather than fixed: the notice follows any refusal whatever type it arrives as, so the
  delta is unaffected, and fixing it inside a Story scoped to `day-screen` would be a silent edit to
  `record`'s capability — the same reason #71 left the shell's row identity alone.

## Open Questions

**None.** The grill's own `## Left open` reads "None." with its reason, and writing this delta
turned up nothing that would change the specs, the approach or the tasks. Two questions came close
and both resolved to facts rather than preferences, recorded here so nobody re-opens them:

- *Does what is told carry words, or only a row?* — a fact about the shipped code, not a preference.
  The screen's other two statements about itself (`RecordState`, `RosterState`) are enums the shell
  turns into words, and ADR-1022 put words in the kit for exactly one thing — the day title — because
  those words are the answer rather than a rendering of it. A refusal has no words that are its
  answer: settled item 8 says there is only ever one message. So it is a row, and the words are
  `tasks.md` § 3's. § *The seam*.
- *Do the four existing requirements the settled answers touch need restating?* — read line by line
  against the shipped spec rather than assumed, and the answer is no. `proposal.md` § *Capabilities*
  records the check for each, and the shown-again requirement's last paragraph turned out to
  **already require** the first of the three ends.

Three things were found next to this change and deliberately left outside it, all already on the
record and all named by the grill: two equal rows sharing what is told
(`docs/open-questions.md` § *The shell identifies rows by equality*), nothing automated proving the
shell draws it (§ *No UI smoke layer*), and `RecordStore.write`'s unwrapped encode, which
`tasks.md`'s closing note sends to `docs/open-questions.md` as a new entry.
