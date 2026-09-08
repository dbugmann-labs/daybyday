# 1042. The horizontal swipe on a day screen belongs to the day, not to the row

- Status: accepted — the owner's decision at the Feature grill that reopened `FEAT: day-screen`
  (#27) on 2026-09-08; this record is written by `chore/swipe-the-day`, which that round's G2 named
  in place of a fourth Story
- Date: 2026-09-08
- Deciders: Diego Bugmann

## Context

A day screen moves one calendar day at a time, and today it moves by aim. `ContentView.swift` draws
a `chevron.left` and a `chevron.right` either side of the day title, each a borderless button, with
a `Today` button under them; the three call `DayScreen.showPreviousDay()`, `showNextDay()` and
`showToday()`, all three of which are already `public` in
`src/DayByDayKit/Sources/DayByDayKit/DayScreen.swift`. The want that opened this — *get to the day
before or after without aiming at a chevron* — is about the aiming and about nothing else: the
behaviour it asks for is the behaviour that already ships.

Moving between days is something a person does on this screen constantly — every visit that is not
about today begins with it, and catching up on a missed day is nothing but it. `CONTEXT.md` § *An
iPhone, in your hand* has the product happening in five daily visits with a phone in hand, and
§ *Entered where you stand* keeps every entry in the row on the day screen, so the day screen is
where the thumb already is; a small target at the top of a list is the wrong shape for something
reached that often.

**The commitments screen has already spent its horizontal swipe, twice.** `CommitmentsView.swift`
attaches `.swipeActions` to the rows of both lists — *Stop* and *Remove* on the kept list, *Resume*
and *Remove* on the stopped one, from `add-roster-removal` (#145) — and `.onMove` with an
`EditButton` for the order, from `add-roster-order` (#146). The day screen's own list has no row
swipe action of any kind, on `main` or on any open branch.

**That is the whole difficulty, and it is not a wiring difficulty.** A horizontal swipe on a screen
can belong to exactly one thing. A thumb makes one horizontal drag; if the row under it takes that
drag, the screen never sees it, and if the screen takes it, no row can ever be given one. Whichever
way it goes, the choice is permanent in practice, because the loser is not merely unimplemented — it
is unavailable to every requirement written afterwards. So the decision worth recording is not that
a swipe moves the day. It is who owns the gesture on this screen, forever.

## Decision

**A horizontal swipe on a day screen moves the day it is showing.** Swiping left goes to the next
day; swiping right goes to the previous one — the content follows the thumb, the way a stack of days
would. It calls the same two members the chevrons call and does nothing they do not do, including at
the two ends of the calendar, where a day screen stays exactly as it is (`CONTEXT.md` § *Day
navigation*).

**It sits beside the chevrons rather than replacing them.** The chevrons stay, and so does the
`Today` button. A gesture nothing on the screen depicts is a gesture a person has to be told about,
and the chevrons are what tells them.

**The screen owns the horizontal swipe on this screen, permanently. No row on a day screen may ever
take a swipe action** — no swipe-to-take-back, no swipe-to-anything. Any affordance a day-screen row
is later given is a tap, a press, or something inside the row's own entry, and a want that can only
be served by a row swipe on this screen is a want this record refuses rather than one waiting its
turn.

**The two screens therefore read differently under the thumb, and that is chosen rather than
tolerated.** On the commitments screen a horizontal swipe acts on the row it started on; on the day
screen it moves the whole day, wherever it started. One gesture, two meanings, one screen apart.

**The reason the screen wins is frequency.** Moving days happens constantly; taking a record back is
rare, and it is already reachable inside the row's own entry — a number or a note is taken back by
committing it empty, and a total by its own act on the row (ADR-1033, ADR-1041). The rare thing
already has a way; the constant thing had only a chevron.

**This is a chore and not a Story**, under ADR-1019 and the precedent of `chore/draw-kept`.
`showPreviousDay()` and `showNextDay()` are public and already wired, so the gesture introduces no
behaviour the kit does not already specify and there is nothing for a delta to say: every day the
swipe can reach, and everything each of those days answers, is already a requirement in
`openspec/specs/day-screen/spec.md` with its own scenario. It passes ADR-1019's test — there is no
line in it that could be wrong in a way a test would catch — and it therefore takes a `chore/`
branch, no change folder and no G4. What it does carry is this record, because the ownership above
is a decision, and a decision that closes a door for every later requirement does not belong in a
diff nobody signs.

## Consequences

- **Swipe-to-take-back on the day screen is now decided, and the answer is no.** It has never been
  asked for; if it is, the answer is a tap or a press, and the cost of this record is that the
  cheapest phone gesture is not available to it.
- **The reversal trigger is a day-screen row affordance that genuinely has no other gesture** — one
  where a tap and a press are both already spent on that row, or where the row swipe is the thing
  being asked for by name. If that arrives, this record is reopened rather than stretched, and the
  price of reopening it is that the swipe navigation goes: the two cannot both have it, which is
  the finding this record exists to carry forward.
- **A person who learns the swipe on one screen learns the wrong thing about the other.** The
  mitigation is that the day screen's rows have no swipe to compete with, so the failure is a swipe
  that moves the day when someone meant to act on a row — recoverable by swiping back, and it
  destroys nothing. The reverse mistake on the commitments screen is worse and is not made worse by
  this, since that screen has no day to move.
- **A control that owns its own bounds keeps the gestures inside them.** This claim is over the
  screen's background and over its rows. The date picker this Feature round is adding as a control
  of its own is not a competing claim, and neither is anything else that draws its own box and
  handles what happens inside it.
- **Nothing automated proves the gesture works.** The smoke layer is one XCUITest asserting the day
  screen draws (`WalkthroughUITests.swift`, ADR-1029), and a green `ui-smoke` promises only that a
  merge whose diff reached the app drew it. Whether that test grows a `swipeLeft()` is the chore's
  call and not this record's; either way the gesture is checked by the owner looking at it, which is
  what the shell is for.
- **`CONTEXT.md` § *Day navigation* gains one sentence and no new term is landed.** A gesture is an
  affordance, not domain vocabulary — but the entry that defines moving between days is where a
  later grill will look, and the constraint above is invisible from § *Row* and § *Day screen*
  unless something points at it. One sentence in the one entry, pointing here, is the whole of it.
- **The chore lands independently of this round's Stories** (#174 → #175 → #176). It touches only
  `ContentView.swift`'s day list and takes no kit surface, so it neither blocks them nor waits on
  them.

## Alternatives considered

**Leave the horizontal swipe unclaimed and keep only the chevrons.** Free, reversible, and it keeps
the gesture available for whatever a day-screen row wants later — the strongest thing about it. It
is rejected because it declines to answer the want at all: the chevrons are what the want was
complaining about, and a screen that is visited five times a day is the wrong place to leave the
cheapest gesture unspent against a row affordance nothing has asked for. Keeping an option open has
a price, and here the price is paid on every visit that is not about today.

**Let both claim it — a swipe starting on a row acts on the row, a swipe starting anywhere else
moves the day.** It appears to give everything, and it is the arrangement iOS makes easy. Rejected
because the ambiguity lands on most of the screen: the day screen is a list of rows, so nearly every
pixel a thumb can reach is a row, and a person swiping would have to know which of two unlike things
they were about to do from where their thumb happened to start. The day would then be movable only
in the margins, which is not a gesture — it is a second small target, and small targets are what
this started as.

**Replace the chevrons with the swipe.** Tidier, and it removes two controls from a screen this
product wants quiet. Rejected because nothing would then depict the way to move a day: a person
opening the app for the first time would see a title and no way past it, and the app has no
onboarding and wants none. The chevrons cost one line of a list header and are what teaches the
gesture.

**Give the day screen a vertical or a two-finger gesture instead, and leave the horizontal one to
rows.** Rejected on the same frequency argument, from the other side. The list scrolls vertically,
so the vertical axis is spent already and more expensively than the horizontal one; and a two-finger
gesture on a phone held in one hand is not a gesture this product can use.
