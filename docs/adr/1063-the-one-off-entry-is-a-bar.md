# 1063. The one-off entry is a bar at the foot of the day screen

- Status: accepted — the owner's decision on 2026-09-28, taken as a chore under ADR-1019 the way
  `chore/swipe-the-day` (#177) went one under ADR-1042; this record is written by
  `chore/one-off-bar`
- Date: 2026-09-28
- Deciders: Diego Bugmann

## Context

At the grill of `make-one-off-on-day-screen` (#244) the owner placed the **one-off entry** as the
last line of the day view's One-offs group, typed in place as in Apple Reminders, with a toolbar `+`
to bring it into focus. That shape is recorded in the first two sentences of the archived
`openspec/changes/archive/2026-09-15-make-one-off-on-day-screen/design.md` § *The shell
(ADR-1019)*, and it is right on a short day. On a full one the group sits last of every group, so
the entry sits below the fold, and a field focused there lands under the keyboard.

The shell answered that with two reach-ins past SwiftUI, both in
`src/DayByDay/DayByDay/ContentView.swift`, both correct, and both fragile.

**`ScrollListToBottom`** is a hidden `UIView` placed as the shown list's background. The toolbar `+`
bumps a request token; the view walks the window for every `UIScrollView`, takes the one nearest
`x == 0` because the paged day content holds three lists side by side, and sets its content offset
to the bottom by hand, one runloop turn later, before focus is asked of the entry. It exists because
`ScrollViewReader.scrollTo` and `.scrollPosition` address a row by identity, and a row the `List`
has not drawn has none: on a day with the entry off screen both left the list where it was, and the
`+` focused nothing.

**`oneOffKeyboardHeight`** is the keyboard's height, read off `keyboardWillChangeFrameNotification`
and judged hidden against `UIScreen.main.bounds`, padded into the lists' `.contentMargins` while a
one-off field has focus. It exists because `List`'s own keyboard avoidance did not shrink its
visible area on this SDK, so the entry, already the last row, had nothing below it to scroll into.

Each depends on something the platform does not promise: the view hierarchy a `List` builds, the
order and position of three scroll views, a screen-sized keyboard frame. Either can break on an SDK
update with nothing failing but the phone.

A spike on 2026-09-28, on the iPhone 17 Pro simulator against the installed iOS 27.0 SDK with the
project targeting 26, found `safeAreaBar(edge: .bottom)` compiles, and that attached once to the
`NavigationStack`'s content its field rose with the software keyboard and sat above it, with no
keyboard tracking at all; after a day swipe it was still one bar in the same frame.

**Amended 2026-09-28**, while the chore was built: `safeAreaBar` was dropped for
`.safeAreaInset(edge: .bottom)`, because a field inside `safeAreaBar`'s content never let
`@FocusState` hold `.entry`, read or written, so the toolbar checkmark that reads that focus never
showed for the entry; a `@FocusState` local to the bar's own view did no better. `.safeAreaInset`
is the ordinary view tree, and its field rose above the keyboard just the same.

## Decision

**The one-off entry is a bar pinned at the foot of the day screen**, drawn with
`.safeAreaInset(edge: .bottom)` attached to the paged day content, the way Messages pins its field.
It is always in reach, rises above the keyboard with no keyboard tracking, and is never scrolled to.
It is drawn as an opaque pill, and so is a refusal told under it.

- **It is drawn on every day the entry is offered, which is exactly when `oneOffGroup != nil`**, and
  nowhere else. It is one bar for the screen, not one per page, so the disabled entry line each
  neighbouring page drew goes with the in-group line.
- **Return and the toolbar checkmark commit what is typed, through one path, and answer a refusal
  alike.** A kept add drops focus. A refused add keeps focus, with its text and its cause told under
  the bar's field, whichever of the two committed it, as a refused rename already did (grill answer
  18). The owner asked for the checkmark to match Return at the phone walk on 2026-09-28.
  Everything else the archived section says about committing — on losing focus, and before the day
  moves — stands.
- **The toolbar `+` is gone.** Its only job was to bring the field into view, and a bar is always
  in view.
- **The day's rows run under the bar** rather than stopping flat at its top edge: the lists fade
  out beneath it with `.scrollEdgeEffectStyle(.soft, for: .bottom)`, and the paged content is
  clipped horizontally only, which still hides the neighbouring pages.
- **One-off rows still live in the group where they stand.** Only the line that makes one moves;
  renaming from a row, its tick and its long press are untouched.
- **The shell draws the One-offs group only where it holds at least one row.** The bar is the offer,
  so a heading over nothing has no job left. The kit is unchanged: a day view still holds the group,
  holding no rows, where none stands on its date (`openspec/specs/day-screen/spec.md`, *A day view
  draws the one-offs standing on its date as one group headed One-offs*); only the drawing skips it.
  The owner's answer on 2026-09-28, while this record was written.
- **A horizontal drag on the bar moves nothing.** The day swipe belongs to the paged content, and
  the bar is a control that owns its own bounds, which ADR-1042 already says is no competing claim.
  ADR-1042 is untouched.

**This supersedes the first sentence of the archived `make-one-off-on-day-screen` `design.md`
§ *The shell (ADR-1019)*** — "The entry is a `TextField` as the last line of the group on the shown
page, and a disabled line on each neighbour" — **and the second**, which shows the toolbar `+` and
has it focus the entry. **For a refused add only, it also supersedes the third sentence's** "it
commits and drops focus", said of the checkmark: a refused add now keeps focus there, and a kept add
still drops it. The archive stays unedited, as every archive does; this record is where the
change is read.

**`ScrollListToBottom` goes**, with every scroll that exists to carry the entry into view, **and
so does the keyboard-height tracking.** Renames still happen in their row, and the tracking served
them too, but a rename on the last row of a 25-row day with the keyboard up read the same frames
with it and without it — row maxY 489, bar minY 499, keyboard minY 583. No `UIScreen.main` read and
no keyboard notification remains in the shell.

**No scenario moves, which is why this is a chore.** `openspec/specs/day-screen/spec.md` says a
one-off committed in the one-off entry is added on the day the screen shows, and that a refused add
is told "under the one-off entry". Neither places the entry, so there is no line in this change a
kit test could catch, and it passes ADR-1019's test. Hiding the empty heading passes it for the same
reason: the spec says what a day view holds, which does not change, and never says the shell draws
an empty group. What it carries is this record, because
reversing a placement the owner chose at a grill is a decision, and the archived sentences it
contradicts cannot be edited.

## Consequences

- **The entry no longer sits where the one-off it makes will appear.** A name typed at the foot
  lands as a row in the group above, which is the price of Reminders' in-place typing traded for
  reach; on a full day the new row may be off screen when it is made.
- **Every day screen offering the entry gives up a strip at its foot**, on days a person means to
  add nothing as well as on days they do.
- **Both reach-ins leave the shell.** Nothing in it walks the window for a scroll view or reads
  the keyboard's frame.
- **On a day no one-off stands on, the day screen draws no One-offs heading at all**, and the bar
  alone says one-offs are being kept. Where one-offs cannot be read there is neither.
- **`CONTEXT.md` § *One-off entry* and § *Day view* are amended in place, dated 2026-09-28**, and no
  new term is landed.
- **The reversal trigger is the safe-area inset failing the phone** — a bar that does not rise with the
  keyboard, or a drag on it that moves the day. Going back costs both reach-ins again.

## Alternatives considered

**Keep the entry last in the group and keep both reach-ins.** Free today, and it keeps typing in
place. Rejected because it spends the product's most frequent screen on two workarounds that break
silently, to keep a field below the fold on exactly the days a one-off is most likely to be added.

**Move the entry to the top of the One-offs group.** Rejected: the group is still last of every
group, so on a full day the entry is still below the fold and still under the keyboard, and both
reach-ins stay.

**Keep the `+` and have it open a sheet holding the field.** Rejected: one more tap for every add,
and a sheet over the day hides the day the one-off is being added to.
