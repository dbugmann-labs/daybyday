## Context

See `proposal.md` § *Why*, and `grill.md`, whose twelve settled answers and layout this delta is
written on. The facts the shape turns on, read off this worktree:

- **The way in is `CommitmentsScreen.offersGoingToBirthdays`**, `birthdaySwitch?.isOn ?? false`,
  read live. The commitments screen's `whileOn:` switch has one other use, `shown(asOf:)` showing it
  again, and carried restore and present-idea-copy tests still open a commitments screen with one.
- **`DayScreen.birthdayState`** is formed with every day view: `.off` wherever no calendar or no
  switch was handed or the switch reads off, else `.calendarUnreadable`, `.on`, `.ticksUnreadable` or
  `.ticksWrittenByALaterVersion`. `shown(asOf:)` shows the switch again first; Settings is a sheet off
  the day screen, and closing it calls `returnedTo(from:)`, which forms again.
- **The shell opens `BirthdaysScreen(asOf: today(), …)`** inside `CommitmentsView`'s gift action,
  with `BirthdaysScreen.presentIdeaPlace` and the copy place; `DayScreen` already names the
  present-idea place beside a record place, and holds the calendar, the switch and the copy place.
- **`BirthdaysScreen.lines`** is the only list the view draws; `listed` holds the calendar's lines
  before the idea counts are added, and every kept idea change rebuilds `lines` from it.
- **Foundation, measured on this Mac:** `range(of:options: [.caseInsensitive,
  .diacriticInsensitive])` finds "mul" and "MÜL" in "Anna Müller's" and "mül" in "Hans Muller's",
  and not "mül" in "Mueller", "ole" in "Øle" or a typed `'` in a calendar's `’`.

## Goals / Non-Goals

**Goals:** the way in on the day screen and the Birthdays screen it opens, the search, what it
matches, what it says of matching nobody and how long it lasts — every rule drivable through
`DayScreen` and `BirthdaysScreen`.

**Non-Goals:** searching present ideas or contacts; Contacts access; highlighting a match; a way in
anywhere but the day screen; any change to the day screen's Birthdays group or its ticks.

## Decisions

### The seam

```swift
public var offersGoingToBirthdays: Bool { get }  // on DayScreen: birthdayState != .off; moved off CommitmentsScreen
public func birthdaysScreen() -> BirthdaysScreen?  // on DayScreen: as of today, nil where it offers no way
public private(set) var search: String  // on BirthdaysScreen, exactly as typed, "" when opened
public func searchEdited(to text: String)  // on BirthdaysScreen
public var offersSearch: Bool { get }  // on BirthdaysScreen
public var nobodyMatches: String? { get }  // on BirthdaysScreen: "Nobody matches “Kim”." or nil
public private(set) var lines: [Line]  // on BirthdaysScreen, unchanged signature, now the lines matching
```

`CommitmentsScreen.offersGoingToBirthdays` is deleted; its `init(…whileOn:…)` is kept as it stands.

### The day screen opens the Birthdays screen

`birthdaysScreen()` makes it from the day screen's own today, calendar, switch, copy place and the
present-idea place beside its record place, so "lists from today, whichever day" (Settled 3) is a
rule a test sees, and a test's temporary record place never reaches the real ideas file.
- *Rejected:* the shell keeps calling `BirthdaysScreen(asOf: today(), …)` — the rule would live in a
  view no test drives.

### Offered with the day view, not read live

`offersGoingToBirthdays` is `birthdayState != .off`, formed when the Birthdays group is, so the gift
and the group always agree. The switch only moves in the Settings sheet, whose closing forms again.
- *Rejected:* `birthdaySwitch?.isOn` read live, as the commitments screen did — a second reading of
  "on" beside the one the day screen already says, and on with no calendar.

### The search narrows `lines`, and is held only while it is offered

`lines` becomes `listed` with the counts, filtered; the view, `ideas(of:)` and every idea change keep
working on the `Line` they already take. `searchEdited(to:)` stores the text as typed — a stored trim
would eat the space typed between two words — and matches on `Blank.trimmed` (ADR-1039), with
`[.caseInsensitive, .diacriticInsensitive]` and no locale. Forming with nothing listed empties the
search, since a held search with no field drawn would filter a list nobody can see searched.
- *Rejected:* a second `matchingLines` beside `lines` — two lists the view and every count must
  choose between.
- *Rejected:* keeping a search across a showing that lists nothing — it would come back unasked.

### Accents are folded; spellings are not

"mul" finds "Müller" and "mül" finds "Muller", but neither finds "Mueller": folding "ü" to "ue" is a
language's rule, and Settled 5 chose words that do not depend on the phone's language.
- *Rejected:* `localizedStandardContains` — it reads the phone's locale.

### The sentence for matching nobody is the Kit's

`nobodyMatches` composes `Nobody matches “<search>”.` from the trimmed search, curly quotes, the
mockup's words; the empty-list sentences stay the view's as they are.
- *Rejected:* the view composing it — it would trim the search a second time, by its own rule.

### The shell

`ContentView`: the gift (`gift`, labelled "Birthdays") is the first button of the trailing
`ToolbarItemGroup`, before Commitments and Settings, drawn exactly while
`screen.offersGoingToBirthdays`; it leaves the day screen exactly as the Commitments button does,
sets `birthdaysScreen = screen.birthdaysScreen()` and pushes. The `navigationDestination` sits on the
day stack, never on the item, and the screen is dropped when the push pops, as today.
`CommitmentsView` loses the gift, its spacer, its destination and the three parameters that fed them.
`BirthdaysView`: while `screen.offersSearch`, a field at the foot in `.safeAreaInset(edge: .bottom)`
in the one-off bar's shape — opaque capsule, a `magnifyingglass` leading, prompt "Search", the app's
own word (ADR-1022), autocorrection off — bound to `search` through `searchEdited(to:)`. Where
`nobodyMatches` is set it is drawn in the lines section's card in place of the empty sentence.
No `.searchable`: its iPhone placement on a pushed screen is the platform's, and the foot is named.

### What the shell draws

Option A, *Field at foot*, from https://claude.ai/artifact/XTenF7BJmm27xcpzS2fTjT.

```
A — Field at foot (recommended)
Day screen                          Birthdays screen
┌──────────────────────────────┐    ┌──────────────────────────────┐
│ [Today]      ( 🎁  ☰  ⚙ )    │    │ (<)                          │
│ Wednesday                    │    │ Birthdays                    │
│ Today, 14 October 2026       │    │ ┌──────────────────────────┐ │
│ ‹ M T W T F S S ›            │    │ │ <words>       <day>    > │ │
│ Birthdays                    │    │ │ <n ideas>                │ │
│ ┌ <birthday rows> ─────────┐ │    │ │ …                        │ │
│ ┌ <commitment rows> ───────┐ │    │ └──────────────────────────┘ │
│ ( New one-off              ) │    │ ( 🔍 Search                ) │  ← field at foot, rides keyboard
└──────────────────────────────┘    └──────────────────────────────┘
No match: ┌ Nobody matches "<typed>". ┐ in a card, field stays at foot
```

### Migration

None — nothing kept at any place changes, and the search is held nowhere.

## Risks / Trade-offs

- **The likeliest wrong code opens the Birthdays screen as of the day being shown.** → The opening
  scenario moves the day screen a day back first, and asserts the ask and "Today".
- **A filtered `lines` rebuilt unfiltered by an idea change.** → The keeping scenario adds an idea
  while a search is held and asserts Kate's line alone.
- **A search for a name with an apostrophe** typed `'` against a calendar's `’` matches nothing, and
  the keyboard's smart punctuation decides which is typed. A person types a name, which holds none.
- **The gift vanishing while the Birthdays screen is up**, if access is withdrawn — the destination
  sits on the stack, not the item, so the screen stays and says birthdays are off.
- **The walk cannot show birthdays on in the simulator** (`docs/open-questions.md`), so four of its
  six steps are the phone's.

## Open Questions

None. `grill.md` § *Left open* is "None." with its reason, and the three things its layout left to
this delta are set above: the words "Nobody matches “…”.", the field's own prompt "Search", and the
foot named in the build. Writing the delta reached four edges — a search held when the screen next
lists nothing, a search edited while none is offered, "ü" against "ue", and the way in while the
calendar cannot be read — and each is decided above or in the delta. No residual round is
outstanding.
