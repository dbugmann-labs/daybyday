# 1044. A row that is a target is marked, and a row that offers nothing recedes

- Status: accepted — the owner's decisions at the Story grill of `add-offered-row-target` (#175) on
  2026-09-09, where that Story dissolved; this record is written by `chore/mark-the-offered-row`,
  which that grill named in its place
- Date: 2026-09-09
- Amended: 2026-09-09 — the branch went back onto the phone with the grey checkmark on it and the
  owner asked for green. Decision 8 moves a third time: a kept row's checkmark takes the system
  green, the circle keeps the accent, and a kept name stays dimmed and struck through. All three
  positions that decision has held were settled by building it and looking. This is also the closest
  the app has come to `CONTEXT.md` § *Nothing congratulates you* — the objection was put to the owner
  in those words and overruled, and decision 8 now carries both sides of it.
- Amended: 2026-09-09 — the branch was built onto the owner's phone and two things came back. The
  checkmark gives up the accent and takes the grey of the name beside it, which is the conductor's
  recommendation at decision 8 — rejected when it was argued and taken when it was seen — and a
  kept row's name is now struck through as well (decision 11). The circle keeps the accent, and
  everything this record says about a day that has not arrived stands untouched.
- Deciders: Diego Bugmann

## Context

`add-offered-today-control` (#174, merged as `4b19e71`) landed the requirement *A row says whether it
offers anything at all* in `openspec/specs/day-screen/spec.md`, and with it
`DayView.Row.offersAnything(asOf:)`. The shell branches on it: `ContentView.swift:202` wraps the row's
label in a `Button` where the row offers something and draws the same label bare where it does not.
Every day the calendar holds, and everything each of those days answers, is a requirement already.

**#175 was cut to make a row for a day that has not arrived stop being a target, and #174 had already
done it** — at the requirement level and at the shell level both. What was left when the grill reached
it was only how the two states are *drawn*, and drawing carries no requirement here: `colour`,
`color`, `dimmed`, `opacity` and `tint` appear nowhere in `openspec/specs/`, #174's own `design.md`
§ *Goals / Non-Goals* says "**Nothing about what a control looks like** … the shell's job; the delta
says only what is offered", and its § *Risks / Trade-offs* books this exact outcome in advance — "a
person on a future day now has rows they cannot tap and no message saying why … if it turns out to be
wrong it is a new want, not a defect in this delta". It turned out to be wrong within the day. The
precedent for what to do about it is `chore/draw-kept` (`docs/backlog.md` § *Decided*, 2026-09-03):
"`Row.isKept` is already public and drawing it carries no requirement, so there is nothing for a Story
to specify."

The owner, on #175 before the grill: *"It's already kind of delivered, but I'm not really happy with
the styling — to me, it is not yet really clear that it's not clickable, only because the text is
white."*

**What the shell does today**, read off `ContentView.swift` on `5c91ec7` rather than remembered. A
single `label` — one `HStack` — is built once at `:170`–`:198` and is then either wrapped as
`Button { … } label: { label }` at `:202` or drawn bare at `:219`. **No modifier distinguishes the two
branches.** The label is byte for byte the same in both. The name carries
`.foregroundStyle(row.isKept ? .secondary : .primary)` at `:174`, through
`commitmentLine(_:rhythmInWords:)` in `CommitmentLine.swift`, and both of those are *hierarchical*
styles: inside a `Button` they resolve against the button's accent tint, outside one against the
label colour. That is the whole of "the text is white" — the single visible difference between a row
that is a target and a row that is not is that one name is blue and the other is not, and on a day
that has not arrived there is no blue row anywhere on the screen to read it against.

The trailing slot at `:187`–`:197` says the rest. A kept row draws `Image(systemName: "checkmark")`
with **no explicit style at all**, so it inherits the accent inside a `Button` and the label colour
outside one — nothing chose either. A row with a number, note or total entry draws
`Image(systemName: "chevron.right")` at `.font(.caption).foregroundStyle(.secondary)`, and since all
three entries are `nil` on a day that has not arrived, the chevron is simply absent there. **A tick
row has never had a trailing mark at all while it is unkept**, which is why blue-versus-white is
carrying the whole signal on the one kind that has the most rows. Category headings are `Section`
headers at `:222` and after, outside the per-row branch entirely.

**Why this is a record and not just a diff.** Two of the decisions below spend things that were
already spent. One draws on a kept row, which `chore/draw-kept` settled by name: its mark's colour
stops being inherited and its name gains a strikethrough. The other settles what marks a row's two
states for every kind of commitment added after today, in a place — the trailing slot — that holds
exactly one thing at a time. Neither is visible from the requirement, because the requirement
deliberately says nothing about looks; a later grill asking why a kept checkmark is green while the
circle above it is blue would otherwise find only a shell commit.

## Decision

**1. This is a chore, not a Story, and #175 closes as met.** The intent #175 carried — a row for a day
that has not arrived is drawn but is not a target, for every kind — is already a requirement with its
own scenarios, and `offersAnything(asOf:)` is already public and already wired. Nothing below could be
wrong in a way a test would catch, which is ADR-1019's test, so this takes a `chore/` branch, no
change folder and no G4.

**2. No message, and that decision stands.** Nothing is written on a row, under the day title, or
anywhere else to say the day has not arrived. This was decided at the Feature grill that reopened
`FEAT: day-screen` (#27) on 2026-09-08, against B-035's own words, and the grill of #175 reaffirmed it
rather than reopening it. What follows is drawing and only drawing.

**3. Both sides carry the signal: mark what is a target, *and* make what is not recede.**
*Taken against the conductor's recommendation*, which was to mark the target only and leave the
inert row alone — on the ground that one change is cheaper to judge on the phone and that a mark
appearing is already a difference. The owner's answer is that a difference you can only see by
comparing two rows is no use on a screen where every row is inert at once, which is exactly the day
that has not arrived.

**4. A tick row that offers a tick and is not kept gets an open `circle` at the trailing edge.**
Where it is kept it keeps the existing plain `checkmark`. Same slot, never both — a row shows one
trailing mark or none. This gives the tick kind the affordance every other kind already has in that
slot, and it is what makes decision 3's "mark the target" true on the rows there are most of.

**5. A row that offers nothing fades.** One opacity over the whole label, so the name, the rhythm and
any checkmark recede together as one thing rather than three. Grey was rejected as the axis: a grey
name already means *kept* (`chore/draw-kept`, and decision 11 below, which strikes that name through
as well), and a second meaning for grey would make a kept row and a row for a day that has not
arrived read alike.

**The opacity value is not a decision, and this record does not fix one.** It is the implementer's to
set and the owner's to tune at `pnpm run phone`. Start near half strength — 0.5 — and move it until an
inert row reads as inert without becoming unreadable; the row still says what that day will ask of
you, so it may not fade to the point of not being read.

**6. Category headings do not fade.** Nor does the day title, nor the chevrons either side of it, nor
the *Today* button. A heading was never a target on any day, and the other three are still targets on
a day that has not arrived — the fade is about what a row offers, and it belongs to rows.

**7. The circle goes on tick rows only.** Number, note and total rows keep their chevron and get no
circle. The two marks say different and simultaneously true things: a chevron means the tap opens a
sheet, a circle means it toggles in place.

**8. The circle takes the accent; the checkmark takes the system green.** Blue for the thing you can
press, green for the day that is done. Both styles are **stated explicitly at the one place the mark
is drawn, which is what makes them true inside the `Button` and outside it alike** — that half of
this decision has never moved through any of its three positions and matters more than either colour
does, because an unstyled mark inherits the accent inside a `Button` and the label colour outside
one, and nothing chose either. The name of a kept row is not touched by this: it stays dimmed and
struck through (decision 11), so a kept row is now a quiet name beside a coloured mark rather than
two grey things together. `chore/draw-kept`'s "no colour" is withdrawn by this decision, for the second
time and this time knowingly.

**What the trailing slot's colours mean, now that green is spent.** There are three and there is not
a fourth: **accent — there is something here to tap**; **green — this day is done**; **grey — nothing
here is a target**, which is decision 5's fade and decision 10's chevron. Any later control that
wants a colour in that slot is judged against those three the way a want is judged against
`CONTEXT.md` § *Offered* — it either says one of these things, or it owes an argument for a fourth
meaning on a strip of screen that holds one mark at a time.

**This colour has been decided three times, and every time by building it and looking at it rather
than by arguing it.** The trail is kept whole because it is the clearest thing in this repository
about why the shell gets built at all (ADR-1019), and because two of the three positions were reached
against a well-made argument.

*First, the accent on both marks — built, and rejected on the phone.* It read *both trailing marks
take the accent — a blue circle and a blue checkmark*, taken against the conductor's recommendation,
on the owner's argument that the two marks occupy one slot and swap into each other on a tap, so a
colour change riding along with the shape change reads as a second event, where one accent across
both makes the tick and the take-back one control that changes shape. That is a good argument and it
is why the accent was built rather than talked about. It was put on the phone with `pnpm run phone`,
and the owner's words on seeing it were: *"i don't like it too much that the checkmark has the same
color as the circle."* What the argument predicted — a tap reading as two events — is not what a
screen full of blue checkmarks turned out to be about; a kept mark holding the same colour as a mark
you can press makes a row that is finished go on asking for a press.

*Second, grey matching the name — the conductor's rejected recommendation, taken when it was seen.*
Asked what the checkmark should take instead, the owner chose the grey a kept name already carries,
over the plain label colour and over dropping the mark altogether, so that a kept row's name and its
mark receded together as one thing. That is the shape this record held for a day: struck-through
dimmed name, grey checkmark. It was built, shipped to the phone and lived with.

*Third, green — asked for on a second look at the same build.* The owner: *"almost, everything is
perfect, just please make the checkmarks green now, I think i like that more."* Everything else in
the branch was accepted in the same breath — the circle, the fade, the headings, the strikethrough,
the plain name — so this is one value on one line, and the grey it replaces is one day old rather
than settled.

**`CONTEXT.md` § *Nothing congratulates you* genuinely bears on this, which it did not on anything
else in this record, and the objection was put to the owner in as many words before green was
taken.** That principle is the owner's own, agreed 2026-08-28 with `EPIC: Daily commitments` (#1): a
ticked row "just goes quiet", no streaks, no gamification, no celebration of a run of good days. It
is not a taste — streaks are the mechanic the owner abandoned other apps over, and a product built on
the durability of a record cannot afford a reason to stop opening it. **Green is the canonical
congratulation colour**: it is the colour habit trackers paint a completed day in, the colour a
filled ring and an unbroken chain are drawn in, and grey was chosen over exactly this one day earlier
partly on that ground. The objection was raised in those terms and **the owner
overruled it; the instruction stands and this is what the record now says.**

The argument on the other side is real and deserves stating rather than conceding. What the principle
forbids is **accumulating**: naming, counting, ranking, charting and celebrating a *run* of days — a
streak number, a percentage, a badge, a wall of squares that punishes the first gap. A per-day mark
says only *this one is done*. It is gone when the day is gone, nothing sums it, nothing counts it,
and no screen this app has today puts two *days*' marks next to each other — there are two screens,
a day and the commitments list, and neither can show a run of days as a run. Green also does a plain
legibility job that grey did not: a list of dimmed struck names is hard to scan for what is still
owed, and a coloured
mark separates done from not-done at arm's length, which is the posture `CONTEXT.md` § *An iPhone, in
your hand* describes. On both counts the row still goes quiet — it just goes quiet in a colour.

**It is nonetheless the closest this app has come to that line**, and that is written here so that
whoever reopens it has the argument and not only the outcome. The defence of green is that it counts
nothing, and that defence stops applying the moment a second green thing appears that adds the first
one up — a green day-level anything, a green run, a green number. The next want of that shape is
judged against this paragraph, not against the fact that green is already on the screen.

**9. The name takes the plain label colour, no longer the accent.** Names read as text and controls
read as controls, and the kept dimming from `chore/draw-kept` now reads against plain rather than
against blue.

**10. The chevron stays grey.** A disclosure chevron is a hint about what happens next rather than the
control itself, and grey is the platform's convention for one. It is not brought under decision 8.

**11. A kept row's name is struck through, and only the name.** The owner, on seeing the branch on
the phone: *"when something is ticked, it would be nice if it is striked through, to make it even
more clear that it is done."* The strikethrough **covers the name and stops there — the rhythm beside
it is not struck.** Asked directly whether to strike the whole line, the owner chose the name
alone: striking the name says *this day is done*, while the rhythm is what the commitment runs on and
is exactly as true after the tick as before it, so a rule through it would say something false.

This composes with what is already there rather than replacing any of it. **A kept row is a
struck-through, dimmed name, a green checkmark, and no animation.** It follows `row.isKept` and
nothing else, so a kept row that also offers nothing gets decision 5's opacity riding over the whole
label exactly as it rides over the mark — the two are different axes and they stack.

It is on the right side of `CONTEXT.md` § *Nothing congratulates you*, and one clause is enough
because a later reader will check: a rule through a name is a statement that the day is done, in the
same class as the checkmark beside it — it accumulates nothing, counts nothing and celebrates
nothing, and the row still goes quiet. The long form of that test is at decision 8, where the mark's
colour spends far more of the principle than a rule through a word does.

**Two things the grill considered and refused.** A **faded circle** on a row that offers nothing was
refused: that is drawn-and-inert, and `CONTEXT.md` § *Offered* says a screen draws as a target only
what it offers. The mark is absent on such a row, not dimmed. And a **day-level treatment** — fading
or marking the whole screen when the day it shows has not arrived — was not pursued: the requirement
is deliberately per-row, so that a kind added later which offers nothing on a day that *has* arrived
is covered without any of this being reopened.

### Where each decision lands, and which of them a person sees every day

Everything below is in `src/DayByDay/DayByDay/ContentView.swift`, in the per-row `ForEach` of
`dayList` at roughly `:166`–`:264`. Nothing outside that file changes, and nothing in
`src/DayByDayKit` changes at all. **The line numbers are read off `6a039bf`, the branch as it now
stands**, and they were re-read at this amendment rather than carried over: the earlier ones were
off `1c16c20`, and the commit that built decisions 8 and 11 moved almost every line in the table.

| Decision | Where | Seen when |
|---|---|---|
| 4 — open `circle` on an unkept tick row | chosen at `:186`–`:187`, drawn at `:227`–`:230` | **every day**, on most rows |
| 8 — accent on the circle, green on the checkmark | `markColor`, derived at `:194` beside `markSystemName`, applied at `:229` | **every day**, on every marked row |
| 9 — plain label colour on the name | `:181`, and the composition at `:202`–`:209` | **every day**, on every row |
| 11 — a kept row's name is struck through | `:206`, on the child `Text` handed to `commitmentLine` | **every day**, on every kept row |
| 3, 5 — the whole label recedes | the bare-label branch at `:257`–`:262` | only a day that has not arrived |
| 6 — headings, title, chevrons and *Today* untouched | `:265` and the day header above `dayList` | — |
| 7, 10 — chevron unchanged, no circle beside it | `:231`–`:235` | — |

Decisions 4, 8, 9 and 11 change the screen the owner looks at five times a day; decisions 3 and 5
change only a day that has not arrived. That split is worth knowing before the phone build, because
most of what will look different is not the thing this record was opened for — and it is what the
phone builds then proved, since all three of the changes they have sent back — the checkmark's colour
twice and the strikethrough — were about a day that has arrived.

## Consequences

- **`docs/backlog.md` § *Decided* is amended by this record, and now three times.** The decision
  decisions 8 and 11 touch is not in an ADR: it is the 2026-09-03 `chore/draw-kept` line in that
  ledger, which read "Kept is a dimmed name and a plain checkmark, no colour, no animation — the row
  goes quiet." This record's first version put the accent on that checkmark, the phone took it off
  again, and a second look put green on it. As the record now stands the line reads: *kept is a
  struck-through dimmed name and a green checkmark, no animation — the row goes quiet.* So **"no
  colour" is withdrawn**, after one day of standing restored; what the line gains beyond the colour
  is the strikethrough. Updating that line is the conductor's, not this branch's:
  **`chore/mark-the-offered-row` does not edit `docs/backlog.md`.**
- **The trailing slot is now spent for the tick kind in both its states.** A later want for a third
  thing on a tick row — a long-press affordance, a per-row indicator — has no trailing slot to use and
  must find another place, in the way ADR-1042 spent the horizontal swipe. That is the price of
  decision 4 and it is taken knowingly.
- **A cold implementer must not identify a tick row by `row.tick(asOf:)`.** That member returns
  non-`nil` for a row of **every** kind on a day that has arrived — it guards on the date and not on
  the commitment's kind (`DayView.swift:64`–`:72`) — so `row.tick(asOf: today()) != nil` would put a
  circle on unkept number, note and total rows as well. The test for "this row's tap makes a tick" is
  the one the file already makes twice: the row offers something *and* `numberEntry`, `noteEntry` and
  `totalEntry` are all `nil`. It is derived once as `isTickRow` at `:176`, beside the three `let`s at
  `:167`–`:169`, rather than written a third time next to the `else` at `:251`–`:253` that calls
  `screen.tick(row)`.
- **Decision 9 is a change of style *kind*, not of colour name.** `.primary` and `.secondary` are
  hierarchical, which is precisely why the name is blue inside a `Button` today; asking for the label
  colour means a concrete style rather than a hierarchical one at that call site. The hyphen and the
  rhythm composed inside `commitmentLine` are `.secondary` and resolve the same way, so they follow
  the name — a name that goes plain while the rhythm beside it stays tinted grey is the split decision
  9 exists to remove, and it is the same run of text. `commitmentLine` is shared with
  `CommitmentsView`, whose rows are not inside a `Button` and are therefore already drawing the label
  colour, so nothing there should move: whatever achieves this belongs at the day screen's call site
  and not inside `CommitmentLine.swift`.
- **Both trailing marks have to be styled explicitly, and they no longer take the same style.** They
  are drawn by one `if let markSystemName` at `:227`–`:230`, so the colour is a second value derived
  beside `markSystemName` — one `markColor` at `:194` — and never a second branch in the body. The
  kept arm is what decision 8 moves: `let markColor: Color = row.isKept ? Color.green : .accentColor`,
  where it currently reads `Color.secondary`. **The recommended spelling is `Color.green`**, written
  out at that `let` rather than left to inference at the `.foregroundStyle` call site.
  - **It must be a concrete `Color`, and this is the trap the grey was caught in.** Hierarchical
    styles — `.primary`, `.secondary` and the rest — resolve against the enclosing `Button`'s accent
    tint, which is the whole of why a name read blue in the first place, so `.foregroundStyle(.secondary)`
    on a mark inside a `Button` draws a dimmed blue and not grey. Green is less exposed than grey was,
    because there is no hierarchical green for a bare `.green` to resolve to and the `let` is
    annotated `Color`, so `.green` there is already `Color.green`; the spelling is a recommendation
    for a line that a reader should be able to check without knowing which of its two arms is
    hierarchical, not a defence against a bug that exists for this value. Leaving the mark unstyled
    is still the worst of the three — accent inside the `Button`, label colour outside, and neither
    chosen.
  - **`Color.green` does adapt across appearances — resolved, not assumed.** `Color.green.resolve(in:)`
    against an `EnvironmentValues` with `colorScheme` set each way, on Xcode 26.6 / Swift 6.3.3,
    gives sRGB `52, 199, 89` in light and `48, 209, 88` in dark — brighter and a shade more
    saturated against a dark background, and the documented `systemGreen` pair. It is a dynamic
    colour like `.accentColor` (`0, 136, 255` light / `0, 145, 255` dark) rather than a fixed one, so
    nothing further is needed for dark mode. Resolved with the macOS SwiftUI runtime rather than on
    the phone, which is the same caveat the strikethrough measurement above carries; nothing in the
    values looks device-specific, and `pnpm run phone` is still the last word.

  Decision 5's opacity then rides over whichever colour the mark has.
- **The strikethrough belongs at the day screen's call site, never in `CommitmentLine.swift`.** It
  goes on the child `Text` at `:206`, beside `nameColor` —
  `Text(row.name).foregroundStyle(nameColor).strikethrough(row.isKept)`, which type-checks against
  the iOS 26.0 SDK this app builds for. This is the same reasoning that already keeps decision 9 out
  of that file: `commitmentLine` is shared with `CommitmentsView`, whose rows are not a day's rows,
  know nothing about `isKept` and must not gain a rule through their names.
- **A strikethrough on the child `Text` does survive `commitmentLine`'s interpolation — measured on
  2026-09-09, not assumed.** `commitmentLine` composes `Text("\(name) \(rhythm)")` from two child
  `Text` values, and a modifier that did not survive that would have sent decision 11 into
  `CommitmentLine.swift`, which is the one place it must not go. The exact composition the day screen
  builds — `commitmentLine(Text(name).foregroundStyle(Color.secondary).strikethrough(),
  rhythmInWords:).foregroundStyle(Color.primary)` — was rendered through `ImageRenderer` and diffed
  against the same line unstruck, on Xcode 26.6 / Swift 6.3.3. Three findings, all of them things a
  cold implementer would otherwise guess at:
  - **It survives, and it stays on the name.** The only pixels that change are a three-pixel band at
    one height running `x 0…255`, where the name's own ink ends at `x 253` and the rhythm occupies
    `x 253…317`. The rule stops at the name; the rhythm is untouched, which is decision 11 exactly.
  - **The outer `.foregroundStyle(Color.primary)` does not eat it.** The same composition with and
    without that modifier produced a pixel-for-pixel identical difference.
  - **The rule takes the child `Text`'s own colour**, median brightness 0.502 against a
    `Color.secondary` name and 0.153 against a `Color.primary` one. So on a kept row the rule is
    already grey with the dimmed name it crosses and needs no colour of its own.

  For contrast, `.strikethrough()` on the *composed* `Text` is wrong rather than merely redundant: it
  draws **two** rules, three pixels deep across the name at one height and a separate one-pixel rule
  across the rhythm lower down, because the rhythm is `.caption` and sits on its own baseline. That is
  decision 11's rejected alternative, drawn. The measurement was made with `ImageRenderer` on macOS
  rather than on the phone, because `Text` interpolation is the same SwiftUI machinery on both; the
  last word is still `pnpm run phone`.
- **A kept row no longer recedes as one thing, and that is the trade green makes.** Under the grey
  the name and the mark went quiet together; under green the name is dimmed and struck while the mark
  beside it is the most saturated thing on the row. What is bought is that *done* is legible down a
  list at arm's length instead of having to be read word by word, which decision 8 takes as the
  better half of the trade. It is the piece to look at again if a day screen of mostly-kept rows ever
  reads as loud.
- **Green is spent, and the trailing slot's colour vocabulary is closed at three.** Accent means
  there is something to tap, green means this day is done, grey means nothing here is a target.
  Decision 8 records the test a fourth would have to pass; the practical consequence is that the next
  want asking for a colour in that slot — an overdue mark, a partial-progress mark, anything at day
  level — is judged against those three meanings and against `CONTEXT.md` § *Nothing congratulates
  you* rather than against the fact that colour is already in use there.
- **Nothing automated proves any of this.** The smoke layer is one XCUITest asserting the day screen
  draws (`WalkthroughUITests.swift`, ADR-1029), and no test in the repo can see a colour, an opacity
  or a rule through a word. This is checked by the owner looking at it on the phone, which is what the
  shell is for and what makes it a chore rather than a Story — and it is not a formality: the first
  build sent back a reversal and a new decision within the hour, and the second sent back a colour.
- **`CONTEXT.md` is untouched and no term is landed.** *Offered* and *target* are already there, and a
  circle, a fade, an accent and a green are implementation detail rather than domain vocabulary — the
  glossary is deliberately devoid of it. § *Nothing congratulates you* is the one part of that file
  this record leans on, and decision 8 reads it rather than changing it. `openspec/` is untouched
  too, which the chore lane requires (`docs/process.md` §5).
- **The reversal trigger is a kind whose row offers nothing on a day that *has* arrived.** Decisions 3
  and 5 make "offers nothing" read as "this day has not come yet", which is true of every kind there
  is today but is not what the requirement says. The first kind that breaks that coincidence makes the
  fade say the wrong thing, and this record is reopened rather than stretched.

## Alternatives considered

**Mark the target and leave the inert row exactly as it is.** The conductor's recommendation at
decision 3, and the cheaper half of what was taken: a circle appearing on tappable tick rows is
already a difference, and one change is easier to judge on a phone than two. Rejected because the
difference is only legible by comparison, and a day that has not arrived offers nothing on any row —
there is no marked row anywhere on that screen to compare an unmarked one against. The signal has to
survive being the only thing on screen.

**One accent across both trailing marks — a blue circle and a blue checkmark.** Decision 8's first
position, and what was actually built: the circle and the checkmark are one control in one slot
swapping shape on a tap, and changing colour at the same moment would make the tap read as two events
rather than one. It was taken over the conductor's recommendation, which was grey and was argued from
`CONTEXT.md` § *Nothing congratulates you* — that a mark saying you did the thing is the last place
this product should spend colour. Rejected on the phone rather than in the argument: a screen of blue
checkmarks reads as a screen of rows still asking to be pressed. The tap never did read as two
events, so the argument that won the round was answering a question the built app did not ask. It is
kept here because the reasoning for the accent is genuinely good and someone will reach for it again
— and because it is the one position of the three that is now ruled out on the strongest ground
available, which is that it was looked at.

**Grey matching the name.** Decision 8's second position: the conductor's recommendation, rejected
when it was argued and taken when the accent was seen, and the shape this record held for one day. It
is the strongest thing that can be said against green — a grey mark makes the whole kept row recede
together, name and mark as one quiet thing, and it keeps `chore/draw-kept`'s "no colour" intact and
`CONTEXT.md` § *Nothing congratulates you* untested. Rejected the same way the accent was: the owner
looked at it built and asked for green. Nothing in the argument for grey was refuted; it lost to a
second look, which is the loop ADR-1019 exists for, and decision 8 records what green costs so that
this paragraph is a live option rather than a closed one if the screen ever reads as loud.

**The plain label colour for the checkmark, and dropping the checkmark altogether.** The two other
answers offered when the mark's colour was first reopened at the phone, and both still rejected under
green. The label colour leaves the mark as loud as the name while saying nothing the name does not
already say; dropping the mark leaves the strikethrough and the dimming saying *done* about the name
while nothing says it about the row's trailing edge, and the slot would sit empty on the one kind
that has no chevron. Green is the loudest answer to the same question, which is why decision 8 has to
argue the principle and these two did not.

**Striking the whole line, rhythm included.** The obvious way to do decision 11 — one
`.strikethrough()` on the composed `Text`, which is also one call rather than two. Rejected by the
owner when asked directly: a strikethrough is a statement that *this day is done*, and the rhythm is
what the commitment runs on, which is exactly as true after the tick as before it. Striking it would
say something false about the commitment in order to say something true about the day. It is also
visibly wrong rather than merely over-broad — measured, the composed strike draws two rules at two
heights, because the rhythm is `.caption` and sits on its own baseline.

**Grey as the axis for a row that offers nothing** — dim the name the way a kept name is dimmed,
rather than fading the whole label. Rejected because grey is already spoken for: `chore/draw-kept`
made a dimmed name mean *kept*, so a grey name would mean two unlike things on one screen and a kept
row would read as a row for a day that has not arrived. Opacity over the whole label is a different
axis and takes the checkmark with it, which grey on the name alone would not. Decision 8's third
position leaves this argument standing on the name alone: grey means *kept* on a name and *not a
target* on the chevron and under the fade, green now carries *done* in the trailing slot, and opacity
stays the one thing that means *this day has not arrived*.

**A faded circle on a row that offers nothing**, so that every tick row has a mark and only its
strength varies. Rejected on `CONTEXT.md` § *Offered* directly: a screen draws as a target only what
it offers, and a dimmed control is drawn-and-inert, which is the shape that rule exists to forbid.
The mark is absent.

**A day-level treatment** — one fade, one banner or one wash over the whole screen when the day it
shows has not arrived. Rejected without much argument, because the requirement it would be drawing is
not the requirement that exists: *A row says whether it offers anything at all* is per-row on purpose,
so that a kind offering nothing on a day that has arrived is covered without reopening anything. A
screen-level treatment would be right for a day and wrong for a row, and would have to be undone the
first time the two came apart.
