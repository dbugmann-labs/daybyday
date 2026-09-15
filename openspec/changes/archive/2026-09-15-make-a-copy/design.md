## Context

See `proposal.md` § *Why*, and `grill.md`, whose eleven settled answers this delta is written on.

- **The three stores are hand-written versioned JSON**, at forms 5 (record), 4 (roster) and 1
  (one-offs). Each document type builds itself from its value and forms the value back. No store
  carries a timestamp, and the only clock the app reads is `ContentView.today()`, at the edge.
- **`CommitmentsScreen` opens the roster place and the record place and has no one-off place.**
  `readPlaces` undoes a torn save, opens both, carries back orphaned records; `init` and
  `shown(asOf:)` are its two callers. `DayScreen` holds the three place statics.
- **`RefusedChange` has eight cases and `Refusal` fifteen**, `.notKept` among them, which is the
  one the spec says as *a place that could not be written*.
- **The requirement that counts the kinds of refused change still says seven.** `restarting`
  shipped as the eighth in `add-interval-restart` (#248) without that sentence moving, so the spec
  today forbids a kind that another of its own requirements demands be held.
- **Nothing in `src/` uses `ShareLink`, `Transferable`, `FileDocument` or `fileExporter`.**
- **A partial `Info.plist` and a generated one merge**, measured here on Xcode 27.0: with
  `GENERATE_INFOPLIST_FILE = YES` kept and `INFOPLIST_FILE = Info.plist` added to the app target's
  two configurations, the built plist holds the generated keys *and* the file's exported type. The
  file must sit at `src/DayByDay/`, not inside `DayByDay/`: inside the synchronized folder the
  build fails with *Multiple commands produce … Info.plist*.

## Goals / Non-Goals

**Goals:** a copy that is the three values and knows when it was made; whole or refused; one file
handed to the share sheet under a name that says when; a refusal in the screen's own vocabulary.

**Non-Goals:** reading a copy back (`restore`, #267); the copy place and the copy the app writes on
its own (#269, #268); taking an unreadable store out as it lies (#270); a name inside the file; any
change to a store's form; deleting the file after the share sheet, which the platform clears.

## Decisions

### The seam

- `public struct Moment: Hashable, Sendable` — `public init?(on day: CalendarDate, hour: Int, minute: Int)`, `public let day: CalendarDate`, `public let hour: Int`, `public let minute: Int`
- `public struct Copy: Hashable, Sendable` — `public init(moment: Moment, history: History, roster: Roster, oneOffs: OneOffs)` and those four as `public let`
- `public enum Copy.Store: Hashable, Sendable, CaseIterable { case record, roster, oneOffs }`
- `struct CopyDocument: Codable` — `static let currentVersion = 1`, `init(_ copy: Copy)`, `func formCopy() -> Copy?`, internal like the other three documents
- `public static var copyDirectory: URL` — on `CommitmentsScreen`
- `public func makeACopy(asOf moment: Moment, writingInto directory: URL = CommitmentsScreen.copyDirectory) -> Result<URL, Refusal>` — on `CommitmentsScreen`
- `case storeCouldNotBeRead` — added to `CommitmentsScreen.Refusal`
- `case makingACopy(Copy.Store?, Refusal)` — added to `CommitmentsScreen.RefusedChange`
- `public init(asOf:keepingRosterAt:keepingRecordAt:keepingOneOffsAt:)` — `CommitmentsScreen.init` gains the one-off place, defaulting to `DayScreen.oneOffPlace`

### A copy is the values, not the files (ADR-1054)

Settled answers 3, 9 and 10 fix a form every later Story reads, so they are recorded there rather
than here. `makeACopy` opens the three stores at the three places — the same `undoTornSave` path
`readPlaces` takes — and writes their values through `CopyDocument`, so a torn save is undone and an
earlier-form store yields a current-form copy.

- Rejected: copying the three files' bytes — cheaper, and the shape `take-out-an-unreadable-store`
  (#270) needs, but it carries a torn save and an old form off the phone.
- Rejected: copying what the screen already holds — it holds no one-offs, and its roster is as old
  as the last read.

### The moment is formed at the edge, like `today()`

`Moment` is a `CalendarDate` with an hour and a minute, formed in `ContentView` from
`Calendar.current` beside `today()`, and handed in. The kit reads no clock and knows no time zone
(ADR-1004). An hour outside 0–23 or a minute outside 0–59 forms no `Moment`, as an impossible date
forms no `CalendarDate`.

- Rejected: a `Date` in the kit — an instant needs a zone to be said as 14.32, and the kit has none.
- Rejected: seconds — the name is to the minute (answer 11), and nothing else reads the moment yet.

### The file is written where the platform may clear it, and the screen answers where

`copyDirectory` is `FileManager.default.temporaryDirectory`. The screen writes one file there and
answers its URL for the shell to hand the share sheet; a copy of that name already there is
replaced, since it is the same minute's copy. This is **not** the **copy place**, which is #269's
folder a person picks and this change does not touch.

- Rejected: handing back bytes for the shell to write — the *could not be written* refusal (answer
  7) would then be the shell's, where no test sees it.

### The refusal is the screen's existing one, with one new cause

A copy that could not be written is `.notKept`, the shipped *a place that could not be written*. A
store that could not be read is new, and the store is named on the `RefusedChange` rather than on
the `Refusal`, so the refusal answered to the caller stays the same value the screen holds. No store
is named where the write failed.

- Rejected: a `Refusal` case per store — three cases saying one thing, and the shell would switch
  twice.

### Two `commitment` requirements MODIFIED, and the count is corrected

*Holds the change it refused* gains making a copy and the store it names; its count goes from seven
to **nine**, which also lands `restarting`, shipped as a kind in #248 while that sentence stayed at
seven (ADR-1049 requires the kinds be counted in exactly one requirement). *Lasts until the app is
shown again* gains one sentence: a copy made does not end a held refusal, because the file it writes
is not a place the screen keeps a change at. Both blocks are carried whole; no other word moves.
Both were over the 150-word budget on `main`, at 350 and 252 words, and grow with those sentences to
380 and 276 — splitting either is an editorial Story. `#261` and `#262` are the two open Stories on this capability and will
serialise behind this one.

### Migration

None — no store's form moves, and a copy is read by nothing yet. The copy's own form starts at 1,
and a copy already written stays readable by the rule its own form number carries.

### The shell (ADR-1019)

A `Section` below *Stopped* with one row, *Make a copy*. The tap forms a `Moment` beside `today()`,
calls `makeACopy`, and on success puts the URL in `@State`, which presents a sheet wrapping
`UIActivityViewController` — `ShareLink` needs its item before the tap, and the copy does not exist
until then. On a refusal the section draws the held refused change, as every other section does:
*Your record could not be read.*, the roster's and the one-offs' likewise, and the shipped words for
a place that could not be written. The exported type `com.dbugmann.daybyday.copy`, conforming to
`public.json` with the extension `daybyday`, is declared in the partial `Info.plist` measured in
§ *Context*.

## Risks / Trade-offs

- **A copy carries everything, including a name someone wrote into a note.** Accepted: it is the
  person's own file going to their own store, and answer 3 is the whole history or nothing.
- **The share sheet's outcome is invisible to the app**, so nothing says a copy was saved
  (answer 6). #268 decides what its last-copy line counts.
- **Two copies in the same minute are one file.** Accepted: the second replaces the first, and the
  values differ by at most one change.
- **The temporary directory is cleared on the platform's schedule**, so a URL held past the share
  sheet may point at nothing. Nothing holds one past the sheet.
- **The walk's refusal shot needs a store made unreadable from inside the simulator.** If it cannot
  be driven, that is a stop and a report under ADR-1053, not a quietly dropped picture.

## Open Questions

None. `grill.md` § *Left open* is "None." with its reason, and the one thing it left unverified —
how `.daybyday` is declared under a generated `Info.plist` — was a fact, now measured in
§ *Context*. The store named when more than one cannot be read, and replacing a copy of the same
name, follow from settled answers 1 and 11 and are recorded above rather than asked, so there is no
`## Questions for you` section.
