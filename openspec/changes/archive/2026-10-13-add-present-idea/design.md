## Context

See `proposal.md` § *Why*, and `grill.md`, whose twelve settled answers and layout this delta is
written on. The facts the shape turns on, read off this worktree:

- **`BirthdayStore` is the shape a value kept against a contact has**: version first, a later form
  refused apart, decode through the value's own rules, `.atomic` with `.sortedKeys`, held value
  replaced only after the write. `HappeningStore` repeats it.
- **`BirthdaysScreen` takes no place**, and its `Line` is `words` and `dayInWords` alone. Its tests
  construct it seventeen times and build a `Line` eight times.
- **`RosterState` is `.kept`, `.notKept` or `.writtenByALaterVersion`**, and is what the commitments
  screen says of its happening place.
- **`URL(string: "ask Anna")` is not nil** — it percent-encodes to a relative `ask%20Anna` — while
  `URL(string: "https://müller.de")` forms the IDNA host; both read off this Mac.
- **Blank space is judged by `Blank.saysNothing` and trimmed by `Blank.trimmed`** (ADR-1039).
- **No simulator here gets calendar access** (`docs/open-questions.md`), so the walk is the phone's.

## Goals / Non-Goals

**Goals:** typing an idea against a person, reading it back on their page, the count on their line,
and the file across the app being closed — every rule drivable through `PresentIdea`,
`PresentIdeaStore` and `BirthdaysScreen`.

**Non-Goals:** changing, deleting or marking an idea given (#409); a copy, take-out or restore
holding ideas (#410) — a restore leaves the file as it is; any change to the day screen, the birthday
ticks or the switch; a tap on an idea's text, which does nothing yet.

## Decisions

### The seam

```swift
public struct PresentIdea: Hashable, Sendable
public init(text: String, link: String) throws(PresentIdeaRefusal)  // on PresentIdea
public let text: String?  // on PresentIdea
public let link: String?  // on PresentIdea
public var opens: URL? { get }  // on PresentIdea, nil exactly where link is
public enum PresentIdeaRefusal: Error, Equatable, Sendable { case saysNothing, linkIsNotAWebAddress, notKept }
public final class PresentIdeaStore
public init(at place: URL) throws  // on PresentIdeaStore
public func ideas(of contact: String) -> [PresentIdea]  // on PresentIdeaStore
@discardableResult public func add(_ idea: PresentIdea, to contact: String) throws -> Bool  // on PresentIdeaStore
public enum PresentIdeaStoreError: Error, Equatable, Sendable  // notAStore, laterForm, cannotWrite
public static var presentIdeaPlace: URL { get }  // on BirthdaysScreen
public init(asOf:readingBirthdaysFrom:whileOn:keepingPresentIdeasAt ideaPlace: URL)  // on BirthdaysScreen, replaces the three-argument init
public struct Line: Hashable, Sendable { public let contact: String; public let words: String; public let dayInWords: String; public let ideasInWords: String? }
public private(set) var presentIdeaState: RosterState  // on BirthdaysScreen
public private(set) var ideaRefusal: PresentIdeaRefusal?  // on BirthdaysScreen
public func ideas(of line: Line) -> [PresentIdea]  // on BirthdaysScreen
@discardableResult public func addIdea(text: String, link: String, to line: Line) -> PresentIdeaRefusal?  // on BirthdaysScreen
public func ideaFieldEdited()  // on BirthdaysScreen
public func ideaSheetClosed()  // on BirthdaysScreen
```

### Ideas are keyed to the contact alone, in a store of their own

As a tick is (ADR-1062), without the day: an idea belongs to a person, not to one year's birthday.
- *Rejected:* keyed to the contact and the day — every idea would vanish when the birthday passes.
- *Rejected:* held in `BirthdayStore` — a second form of a file a copy already carries, for #410.

### A link is judged by the shape of its host, in the Kit

The delta's rule is a few lines of character tests and refuses what a person would not call an
address. `opens` is `URL(string: link)`, never nil for a kept link.
- *Rejected:* `URL(string:)` as the judge — it accepts "ask Anna" (§ Context).
- *Rejected:* a list of top-level domains — it goes stale. A port, an IP address and "localhost"
  are refused; nobody types them for a present.

### A line gains its contact and its count, so `birthday` is modified

`ideasInWords` is the Kit's own words, `nil` for none and while the place cannot be read; `ideas(of:)`
and `addIdea` read only the line's contact, so a page holding a line from before a showing still works.
- *Rejected:* counts in a second array beside `lines` — two lists to keep in step.

### The place is read whatever the switch, and handed in

At `init` and `shown(asOf:)`, beside the calendar. It is a required parameter, so no test reads the
real Application Support directory; the carried constructions take a temporary place. Refusals
follow `happeningRefusal`'s lifetime, held apart from anything else.

### Migration

None — additive: a new file, `present-ideas.json` beside `birthday-ticks.json`, at version 1 —
`{ "version": 1, "contacts": [ { "contact": "…", "ideas": [ { "text": "…", "link": "https://…" } ] } ] }`,
contacts sorted, ideas in the order added, an absent part omitted, read through the value's rules.

### The shell

`ContentView` hands `BirthdaysScreen.presentIdeaPlace` in. `BirthdaysView`: every line a push with a
chevron, `ideasInWords` dimmed under the words; above the card, while not kept, "The present ideas
could not be read." or "The present ideas were written by a newer version of DayByDay and must not be
deleted." A new `PresentIdeasView`: nav bar back only, the words as wrapping heading text over the day
dimmed; one card of ideas — text over the link in the accent colour and a smaller size, a link alone
in body size, each link one line cut at the tail, a tap opening `opens` with `openURL` — or "No ideas
yet."; then a "New idea" card, replaced by the line above while not kept. The sheet: "New idea",
*Cancel* and *Add*, never disabled; one-line fields "Idea" and "Link" (URL keyboard, no
capitalisation, no autocorrect); a kept add dismisses; a refused one stays, fields as typed, over the
red caption "Type an idea or a link.", "That link is not a web address." or "Not saved. Try again."

### What the shell draws

Option A, *own page*, from https://claude.ai/artifact/JH4TmWqroJyi6oJF3GBfLz; a long link is cut on
one line (the grill overrides the mockup's full links).

```
A · Own page  (recommended)
┌──────────────────────────────┐ ┌──────────────────────────────┐ ┌──────────────────────────────┐
│ (<)                          │ │ (<)                          │ │ [Cancel]   New idea   [Add]  │
│ Birthdays                    │ │ Kate Bell's 48th Birthday    │ │ ┌──────────────────────────┐ │
│ ┌──────────────────────────┐ │ │ Sat 14 November        (3)   │ │ │ Book voucher             │ │
│ │ Anna Keller's    Today > │ │ │ ┌──────────────────────────┐ │ │ │ ask Anna|                │ │
│ │ 35th Birthday            │ │ │ │ Ceramics class voucher   │ │ │ └──────────────────────────┘ │
│ │ 1 idea                   │ │ │ │ Hiking socks, size 38    │ │ │  <refusal line, red>     (4) │
│ │ Kate Bell's  Sat 14 Nov… > (1)│ https://bergzeit.ch/socks│ (2)│ ░░░░░░░░ keyboard ░░░░░░░░░ │
│ │ 48th Birthday            │ │ │ │ https://amazon.de/xyz    │ │ └──────────────────────────────┘
│ │ 3 ideas                  │ │ │ └──────────────────────────┘ │  sheet over the person's page
│ │ …                        │ │ │ ┌ New idea ────────────────┐ (4)
│ └──────────────────────────┘ │ │ └──────────────────────────┘ │
└──────────────────────────────┘ └──────────────────────────────┘
 count dimmed under the words;    nav bar: back only; the line is
 day trailing, never wraps;       the page's heading, wrapping
 chevron on every line
```

## Risks / Trade-offs

- **The likeliest wrong link rule is `URL(string:) != nil`.** → The refusal scenario's first link is
  "ask Anna".
- **The second keys the count on the line's words.** → Two contacts' lines alike in words and day
  are two lines in the modified `birthday` scenario, and Kate's twice-handed line counts twice alike.
- **A stale line held by an open page.** → `ideas(of:)` reads the contact alone, and a scenario
  reads ideas through a line given back before the add.
- **iOS 26 may cut a long large title**, which is why the heading is page text; the implementer
  confirms on the phone (W.1).
- **An unreadable present-idea file offers no take-out until #410.** → Accepted: the file is left as
  it was and the screen says so; the Stories land in order.

## Open Questions

None. `grill.md` § *Left open* is "None." with its reason. The words it left to this delta are set in
§ *The shell*, the "could not be read" line above the card as the designer suggested. Writing the
delta reached two edges — what a link's host may hold, and whether the file is read while birthdays are off —
and each has one answer that loses nothing, decided above. No residual round is outstanding.
