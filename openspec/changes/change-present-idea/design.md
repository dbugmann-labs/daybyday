## Context

See `proposal.md` § *Why*, and `grill.md`, whose eleven settled answers and layout this delta is
written on. The facts the shape turns on, read off this worktree:

- **An idea has no identity.** `PresentIdea` is `text` and `link`, two alike are both held, and
  `PresentIdeasView` keys its rows by offset. Anything done to an idea names it by where it stands.
- **`PresentIdeaDocument` is at form 1**, and two carried tests write `"version":2` as *a later
  form* — the store's and the screen's later-form scenarios. Both titles stay true at form 2; their
  fixtures move to 3.
- **`BirthdaysScreen` holds one refusal, `ideaRefusal`**, ended by `ideaFieldEdited()`,
  `ideaSheetClosed()`, the next add and `shown(asOf:)`. `CommitmentsScreen.daysAwayRefusal` is the
  shape this follows: one refusal for a sheet and a removal off the page, drawn in the section
  footer while the sheet is not up, and opening the sheet tells it edited first.
- **Every confirmation in the app is the Kit's**: `askToRemove`/`confirmRemovingDaysAway`/
  `cancelRemovingDaysAway`, and the stop and delete of a commitment. The shell draws an alert.
- **`BirthdaysScreen` is `@Observable` but the store is a plain class**, so a write through a swipe
  changes nothing the page observes; the page already bumps a `@State` when its sheet closes.

## Goals / Non-Goals

**Goals:** changing, deleting, marking and unmarking an idea on its person's page, the count and the
order that follow from the mark, and all of it across the app being closed — every rule drivable
through `PresentIdeaStore` and `BirthdaysScreen`.

**Non-Goals:** carrying ideas or their marks in a copy (#410); anything on the day screen or the
birthday ticks — no seam here touches either, which is what keeps giving and ticking apart; an undo;
asking before a change sheet is cancelled; reordering ideas by hand.

## Decisions

### The seam

```swift
public let isGiven: Bool  // on PresentIdea, false for every idea init(text:link:) makes
@discardableResult public func change(_ position: Int, of contact: String, to idea: PresentIdea) throws -> Bool  // on PresentIdeaStore
@discardableResult public func delete(_ position: Int, of contact: String) throws -> Bool  // on PresentIdeaStore
@discardableResult public func mark(_ position: Int, of contact: String, given: Bool) throws -> Bool  // on PresentIdeaStore
public func ideas(of line: Line) -> [PresentIdea]  // on BirthdaysScreen, unchanged signature, now not given first
@discardableResult public func changeIdea(_ position: Int, of line: Line, text: String, link: String) -> PresentIdeaRefusal?  // on BirthdaysScreen
@discardableResult public func markIdea(_ position: Int, of line: Line, given: Bool) -> PresentIdeaRefusal?  // on BirthdaysScreen
public private(set) var ideaAwaitingDeletion: PresentIdea?  // on BirthdaysScreen
public func askToDeleteIdea(_ position: Int, of line: Line)  // on BirthdaysScreen
public func cancelDeletingIdea()  // on BirthdaysScreen
@discardableResult public func confirmDeletingIdea() -> PresentIdeaRefusal?  // on BirthdaysScreen
```

A position is a zero-based offset: the store's into a contact's ideas in the order added, the
screen's into what `ideas(of:)` gives back. The scenarios' "first" is offset 0.

### An idea is named by where it stands

The store already holds a contact's ideas as an ordered list, and the grill settled that two alike
are two. Naming by offset needs nothing new on disk.
- *Rejected:* an identity per idea, as a happening has (ADR-1065) — a form and #410's copy shape
  for a page where two alike ideas behave alike.
- *Rejected:* naming by value — two alike ideas would be one.

### The store keeps the order added; the screen maps its own order onto it

Taking a mark back returns the idea to where it was added, so the order added must survive the mark;
only the screen sorts not-given before given. Each screen member maps its offset to the store's
before it writes, and `ideaAwaitingDeletion` holds the store's offset, which no add, change or mark
moves.
- *Rejected:* the store keeping page order — the place an idea was added would be lost at its mark.

### The mark is on the idea, so the idea requirement is renamed

`ideas(of:)` keeps its type and every carried comparison holds, since no carried idea is given.
`PresentIdea`'s equality now includes the mark; nothing compares ideas across a mark.
- *Rejected:* a second list of given ideas beside `ideas(of:)` — two offset spaces for one card.

### The deletion awaits confirmation in the Kit, and every refusal is `ideaRefusal`

As every confirmation and refusal in the app is (§ Context). Awaiting is replaced by a new ask and
ended by a cancel, a confirmation or a showing.
- *Rejected:* an alert the shell holds alone — Settled 7 would be a rule no test sees.
- *Rejected:* a second refusal member for the page — one sentence, two sources to clear.

A place that cannot be read needs no rule of its own: `ideas(of:)` gives back none, so every offset
names no idea and is refused as not kept, and no row is drawn to swipe.

### Migration

Form 2: an idea record gains `"given": true`, written on a given idea only and read as not given
where absent or `false`. A form-1 file opens as none given, unwritten until the next change, which
writes form 2; a form-1 file is never refused for holding `given`, which is ignored there. Every
write is form 2, an add included.

### The shell

`PresentIdeasView` alone. Each idea row: a leading swipe, a pencil tinted accent labelled "Edit",
opening the change sheet; a trailing swipe, a gift tinted accent labelled "Mark given" — on a given
idea an `arrow.uturn.backward` labelled "Take back" — then a trash tinted red labelled "Delete",
calling `askToDeleteIdea`. A given row: text and link struck through, the text `.secondary`, the
link still `.tint` and still opening `opens`. The alert "Delete this idea?", *Delete* (destructive)
and *Cancel*, shown while `ideaAwaitingDeletion` is set. The change sheet is `NewIdeaSheet`'s shape
titled "Change idea" with *Cancel* and *Save*, never disabled, Idea and Link filled with the idea's
text and link or empty; a kept change dismisses, a refused one stays, fields as typed, over the same
three red sentences. `ideaRefusal` is drawn as that red caption in the ideas card's footer while no
sheet is up; opening either sheet calls `ideaFieldEdited()` first. After every swipe action the page
bumps the same `@State` its sheet's dismissal does.

### What the shell draws

Option A, *swipe actions*, from https://claude.ai/artifact/RqAa4vLxV3nM4tXVBR3AqE; the gift's
take-back is labelled "Take back", the app's existing word.

```
A · Swipe actions  (recommended)
┌──────────────────────────────┐ ┌──────────────────────────────┐
│ (<)                          │ │ (<)                          │
│ Kate Bell's 48th Birthday    │ │ Kate Bell's 48th Birthday    │
│ Sat 14 November              │ │ Sat 14 November              │
│ ┌──────────────────────────┐ │ │ ┌──────────────────────────┐ │
│ │ Ceramics class voucher   │ │ │ │ oucher     [gift][trash] │ │ ← swiped left
│ │ https://amazon.de/xyz    │ │ │ │ https://amazon.de/xyz    │ │
│ │ ~Hiking socks, size 38~  │ │ │ │ ~Hiking socks, size 38~  │ │
│ │ ~https://bergzeit.ch/so~ │ │ │ │ ~https://bergzeit.ch/so~ │ │
│ └──────────────────────────┘ │ │ └──────────────────────────┘ │
│ ┌ New idea ────────────────┐ │ │ ┌ New idea ────────────────┐ │
└──────────────────────────────┘ └──────────────────────────────┘
 nav bar: back only, as shipped. A given idea is struck through
 (text grey, link still accent) and moved to the foot of the same
 card. Swipe right: pencil (accent) opens "Change idea" [Cancel]/
 [Save] with Idea and Link filled in. Swipe left: gift (accent) and
 trash (red); on a given idea the gift is replaced by take-back.
 Delete asks the Days away-style alert: Delete / Cancel.
```

## Risks / Trade-offs

- **The likeliest wrong code hands the screen's offset straight to the store.** → The take-back
  scenario takes back the second idea the page gives back, which is the first added; the change and
  confirmed-deletion scenarios hold a given idea first, so each changes or deletes the page's first
  idea, which is the second added.
- **A swipe that writes but leaves the page as drawn**, since the store is not observed. → § *The
  shell*'s bump, and W.2 shows the row moved without leaving the page.
- **A carried later-form fixture left at 2 turns red once form 2 ships.** → Tasks 2.2 names both.
- **An offset gone stale under an open alert** after the app is shown again. → Showing ends what
  awaits deletion, so the alert's *Delete* then does nothing rather than delete a neighbour.

## Open Questions

None. `grill.md` § *Left open* is "None." with its reason, and the words it left to this delta are
set in § *The shell*: "Change idea", "Save", "Delete this idea?", "Mark given" and "Take back".
Writing the delta reached three edges — where a delete or mark refusal is said with no sheet up, a
mark asked of an idea already so, and an offset naming no idea — and each follows a shipped
precedent, decided above. No residual round is outstanding.
