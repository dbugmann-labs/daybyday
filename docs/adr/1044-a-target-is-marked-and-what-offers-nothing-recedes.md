# 1044. A row that is a target is marked, and a row that offers nothing recedes

- Status: accepted — the owner's decisions at the Story grill of `add-offered-row-target` (#175) on
  2026-09-09, where that Story dissolved; this record is written by `chore/mark-the-offered-row`,
  which that grill named in its place
- Date: 2026-09-09
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
already spent. One puts colour on a kept mark, which `chore/draw-kept` decided against by name. The
other settles what marks a row's two states for every kind of commitment added after today, in a
place — the trailing slot — that holds exactly one thing at a time. Neither is visible from the
requirement, because the requirement deliberately says nothing about looks; a later grill asking why
a kept checkmark is blue would otherwise find only a shell commit.

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
any checkmark recede together as one thing rather than three. Grey was rejected as the axis:
`.secondary` on a name already means *kept* (`chore/draw-kept` — "Kept is a dimmed name and a plain
checkmark, no colour, no animation"), and a second meaning for grey would make a kept row and a row
for a day that has not arrived read alike.

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

**8. Both trailing marks take the accent — a blue circle and a blue checkmark.** This is a deliberate
**amendment to `chore/draw-kept`'s "no colour"**, and it also settles the checkmark's tint, which
until now was inherited and therefore blue inside a `Button` and the label colour outside one with
nothing having chosen either. *Taken against the conductor's recommendation*, which was a coloured
control and a quiet, uncoloured statement — a blue circle for the thing you can tap and a plain
checkmark for the thing that is merely so — argued from `CONTEXT.md` § *Nothing congratulates you*,
on the ground that colouring a kept mark is the app being pleased with you. The owner's answer is
that the two marks occupy one slot and swap into each other on a tap, so a colour change riding along
with the shape change reads as a second event; one accent across both makes the tick and the take-back
one control that changes shape. *Nothing congratulates you* is untouched by it — the mark still
appears and nothing accumulates, celebrates or counts.

**9. The name takes the plain label colour, no longer the accent.** Names read as text and controls
read as controls, and the kept dimming from `chore/draw-kept` now reads against plain rather than
against blue.

**10. The chevron stays grey.** A disclosure chevron is a hint about what happens next rather than the
control itself, and grey is the platform's convention for one. It is not brought under decision 8.

**Two things the grill considered and refused.** A **faded circle** on a row that offers nothing was
refused: that is drawn-and-inert, and `CONTEXT.md` § *Offered* says a screen draws as a target only
what it offers. The mark is absent on such a row, not dimmed. And a **day-level treatment** — fading
or marking the whole screen when the day it shows has not arrived — was not pursued: the requirement
is deliberately per-row, so that a kind added later which offers nothing on a day that *has* arrived
is covered without any of this being reopened.

### Where each decision lands, and which of them a person sees every day

Everything below is in `src/DayByDay/DayByDay/ContentView.swift`, in the per-row `ForEach` of
`dayList` at roughly `:166`–`:222`. Nothing outside that file changes, and nothing in
`src/DayByDayKit` changes at all.

| Decision | Where | Seen when |
|---|---|---|
| 4 — open `circle` on an unkept tick row | the trailing slot, `:187`–`:197` | **every day**, on most rows |
| 8 — accent on both trailing marks | the same slot | **every day**, on every marked row |
| 9 — plain label colour on the name | `:172`–`:175`, at the call to `commitmentLine` | **every day**, on every row |
| 3, 5 — the whole label recedes | the bare-label branch at `:219` | only a day that has not arrived |
| 6 — headings, title, chevrons and *Today* untouched | `:222` and the day header above `dayList` | — |
| 7, 10 — chevron unchanged, no circle beside it | `:193`–`:197` | — |

Decisions 4, 8 and 9 change the screen the owner looks at five times a day; decisions 3 and 5 change
only a day that has not arrived. That split is worth knowing before the phone build, because most of
what will look different is not the thing this record was opened for.

## Consequences

- **`docs/backlog.md` § *Decided* is amended, not this file's predecessor.** The decision decision 8
  amends is not in an ADR: it is the 2026-09-03 `chore/draw-kept` line in that ledger, which read
  "Kept is a dimmed name and a plain checkmark, no colour, no animation — the row goes quiet." As of
  this record it reads: *kept is a dimmed name and a plain checkmark in the accent colour, no
  animation — the row goes quiet.* The dimming, the plainness of the mark and the absence of animation
  all stand; only "no colour" is withdrawn, and only for the trailing mark. Updating that line is the
  conductor's, not this branch's.
- **The trailing slot is now spent for the tick kind in both its states.** A later want for a third
  thing on a tick row — a long-press affordance, a per-row indicator — has no trailing slot to use and
  must find another place, in the way ADR-1042 spent the horizontal swipe. That is the price of
  decision 4 and it is taken knowingly.
- **A cold implementer must not identify a tick row by `row.tick(asOf:)`.** That member returns
  non-`nil` for a row of **every** kind on a day that has arrived — it guards on the date and not on
  the commitment's kind (`DayView.swift:64`–`:72`) — so `row.tick(asOf: today()) != nil` would put a
  circle on unkept number, note and total rows as well. The test for "this row's tap makes a tick" is
  the one the file already makes twice: the row offers something *and* `numberEntry`, `noteEntry` and
  `totalEntry` are all `nil` (`:193`, and the `else` at `:213`–`:216` that calls `screen.tick(row)`).
  Use that, and prefer deriving it once beside the three `let`s at `:167`–`:169` over writing the
  condition a third time.
- **Decision 9 is a change of style *kind*, not of colour name.** `.primary` and `.secondary` are
  hierarchical, which is precisely why the name is blue inside a `Button` today; asking for the label
  colour means a concrete style rather than a hierarchical one at that call site. The hyphen and the
  rhythm composed inside `commitmentLine` are `.secondary` and resolve the same way, so they follow
  the name — a name that goes plain while the rhythm beside it stays tinted grey is the split decision
  9 exists to remove, and it is the same run of text. `commitmentLine` is shared with
  `CommitmentsView`, whose rows are not inside a `Button` and are therefore already drawing the label
  colour, so nothing there should move: whatever achieves this belongs at the day screen's call site
  and not inside `CommitmentLine.swift`.
- **The accent on the trailing marks has to be asked for, in both branches.** A checkmark inside a
  `Button` is accent-tinted by inheritance today and one outside a `Button` is not, so decision 8 is
  only satisfied when the mark is given the accent explicitly — otherwise a kept row on a day that has
  not arrived keeps drawing a label-coloured checkmark and decision 8 is half true. Give the mark its
  own style and let decision 5's opacity ride over it.
- **Nothing automated proves any of this.** The smoke layer is one XCUITest asserting the day screen
  draws (`WalkthroughUITests.swift`, ADR-1029), and no test in the repo can see a colour or an
  opacity. This is checked by the owner looking at it on the phone, which is what the shell is for and
  what makes it a chore rather than a Story.
- **`CONTEXT.md` is untouched and no term is landed.** *Offered* and *target* are already there, and a
  circle, a fade and an accent are implementation detail rather than domain vocabulary — the glossary
  is deliberately devoid of it. `openspec/` is untouched too, which the chore lane requires
  (`docs/process.md` §5).
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

**A coloured control and a quiet, uncoloured statement — a blue circle, a plain checkmark.** The
conductor's recommendation at decision 8, argued from `CONTEXT.md` § *Nothing congratulates you*: a
mark that says you did the thing is the last place this product should spend colour, and the row is
meant to go quiet. Rejected by the owner because the circle and the checkmark are one control in one
slot swapping shape on a tap, and changing colour at the same moment makes the tap read as two
events rather than one. Recorded because it is the strongest argument against decision 8 and a later
reader will reconstruct it whether or not it is written down.

**Grey as the axis for a row that offers nothing** — dim the name the way a kept name is dimmed,
rather than fading the whole label. Rejected because grey is already spoken for: `chore/draw-kept`
made a dimmed name mean *kept*, so a grey name would mean two unlike things on one screen and a kept
row would read as a row for a day that has not arrived. Opacity over the whole label is a different
axis and takes the checkmark with it, which grey on the name alone would not.

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
