# Backlog

**Things I want the application to do, in my own words, before anyone has agreed to build
them.** One entry per want, and wants only: a want is something the app should let you *do*.
`/atlas idea <whatever you say>` writes them — one want or a whole braindump in a single go,
split into entries and the split reported back before it commits; `/atlas backlog` grooms them.
Nothing here is agreed and nothing is implemented from this file: an idea becomes real when it
is a requirement in a capability spec that has passed G4, however obvious it seems.
`docs/process.md` §4, ADR-1010.

**Everything that is not a want** — open product questions, open technical decisions, known gaps
in what is built — is `docs/open-questions.md`; the rules that judge a want rather than being
one are `CONTEXT.md` § *Product principles*.

**An entry leaves in exactly three directions, all of them through `/atlas backlog`:** promoted
into a Feature or a Story against an existing one, dropped with the reason, or merged into
another entry. Whichever it is, the entry is deleted from *Wants* and one line lands in
*Decided* below. **Nothing expires.** A want sits here until a pass takes it, and sitting costs
it nothing: a pass carries one cluster forward, so waiting is the normal state and not a debt.
Nothing counts how long an entry has been here and `pnpm run status` never asks you to answer
for one. ADR-1010.

**Each entry carries a *Principle* line** naming which of `CONTEXT.md` § *Product principles* the
want was tested against and what the test returned — one principle, not all four. A want that
*fails* one is still captured, with the failure written down, so the next pass drops it
deliberately rather than letting it quietly never come back. B-001 to B-009 predate the field;
the first pass, on 2026-09-02, filled them in as it read them.

## What day one looks like

The owner's actual week, as stated on 2026-09-04. Every cluster `/atlas backlog` proposes is
judged against this rather than against a category of app — **and every grooming pass walks it
line by line to find the commitments that have no want, no spec and no open Story at all.** That
sweep is the only step in the whole process that asks what is *missing* rather than whether what
is here is coherent, which is why it runs before any clustering:

> creatine daily · magnesium daily · nails every 4 days · gym Mon/Wed/Sat · run Tue/Thu/Sun ·
> public pool Fri · contact lenses every 14 days · finances every 25th · yuno 5× a week

**This replaced an earlier week, and the wants argued against that one have not been re-judged.**
Until 2026-09-04 the week here was the one stated on 2026-08-28: *gym Mon/Wed/Sat · run
Tue/Thu/Sun · finances every 25th · reading 3× a week · supplements and habits daily · journaling
daily · contact lenses every 14 days · water plants every 3rd day*. Gym, run, finances and contact
lenses carried over unchanged; reading, supplements and habits, journaling and water plants are no
longer kept; creatine, magnesium, nails, public pool and yuno are new. Four wants argue from a
commitment that has left — B-017 and B-025 both ground the weekly quota in reading, B-018 in
supplements morning and evening, B-029 in telling supplements and habits apart — and B-004's Open
line reads journaling as a tick rather than as written text.

**A rhythm leaving the week is not evidence the want was wrong**, so none of those is dropped by
this. Every schedule *shape* the old week asked for is still asked for: yuno 5× a week wants the
weekly quota exactly as reading did, so B-017's and B-025's arguments carry across with the name
substituted. B-018 and B-029 are the ones genuinely weakened — nothing in the week is now a
supplement taken twice a day, and creatine and magnesium are two supplements where there was one
line reading "supplements and habits", which is a different question about categories than the one
B-029 was capturing. **Re-judged 2026-09-06, at the fifth pass, ahead of its sweep: all five
stand**, and each entry carries the result under a *Re-judged* line — B-005 too, which argued from
the same line without being counted. B-005 has since been dropped, on 2026-09-08, and its
re-judgment reads in *Decided*; the other four entries still carry theirs. Nothing cited water
plants.

**Whether to build any of this at all is settled and is not to be re-argued.** Checked against
what already exists on 2026-08-29: nothing found does all four rule shapes without streak
mechanics. Apple Reminders does weekday sets, every N days and a day of the month — free and
already installed — but has no weekly quota and keeps no record of what was ticked, and a
durable record is the failure being solved (the gap is a few days old and cannot be
reconstructed). The habit-tracker category — Streaks, HabitKit, Habitify, Do Habits — has the
quota and is built on the streaks the owner abandoned apps for; a specific calendar date is the
shape it lacks, not the quota.

## Wants

### B-007 — look at one commitment on its own, deliberately and rarely
*Captured 2026-08-28, migrated 2026-09-02.*

> "a detail page per area, visited deliberately and rarely, to look rather than to enter"

*Folded in 2026-09-02:*

> "It's possible that there will be some areas which have a detail page, e.g. a graph where you
> can see the weight / mood / protein over time. But this should be a separate area which can be
> navigated to."

*Merged in 2026-09-02, from B-008 (captured 2026-08-29):*

> "still open: whether looking back means navigating to a past day, or a view that aggregates a
> commitment over time"

- **Trigger** — occasionally, and never as part of the five daily visits.
- **Touches** — unclaimed. Probably its own capability rather than `day-screen`, because its
  whole point is that it is not the landing screen — and the braindump says so twice, calling it
  "a separate area which can be navigated to".
- **Principle** — tested against *five percent of seven things*: strains. A page per
  commitment is depth on one thing at a time, and it passes only if the page is the same
  thin thing for every commitment rather than a deep one for weight.
- **Open** — the word *area* was dropped from the vocabulary (`CONTEXT.md`). What this is a page
  *per* needs re-deciding before it is a Feature. The braindump narrows it without settling it:
  the three examples it gives — weight, mood, protein — are the commitments that carry a number,
  and it says "some areas", not all. A page per numeric commitment and a page per commitment are
  different Features.
- **Open** — from B-008: the page *is* the aggregate — "eleven gym sessions last month" for a
  tick, a line for a number — and B-008's principle test travels with it: a count is one step
  from a streak, and it stays on the right side only while it is looked at deliberately and
  never shown unasked. B-008's other half, navigating to a past day, is B-016.
- **Open** — *folded in 2026-09-08, at the grill of `add-note-record` (#140), at the owner's
  direction rather than from a want of his own, so there is nothing to quote.* That grill settled
  that a row says **nothing** about a note: a note is reachable only through the entry its row
  offers, so the only way to read what you wrote on Tuesday is to move to Tuesday and open that
  row's field. Nothing in the product draws a note anywhere else, and nothing is planned to. The
  note is therefore a third thing this page would be for, beside the count for a tick and the line
  for a number the Open above already names — and it is the one that is least like an aggregate,
  because what you want back is the words themselves rather than a shape they add up to. Whether
  that is the same page or a different one is part of what "a page *per* what" has to settle.

### B-009 — carry my history to a new phone
*Captured 2026-08-28, migrated 2026-09-02.*

> "carrying your history to a new phone; restore, not live sync between devices"

- **Trigger** — once every few years, and catastrophically if it does not work.
- **Touches** — unclaimed. Storage, whose shape was settled after this want was captured by
  `add-record-store` (#56): one versioned JSON file at a place the app names, which is the one
  thing a backup has to carry. ADR-1017.
- **Principle** — tested against *restore, not sync*: passes by definition. It is the want
  the principle exists to promise, and the principle's second half — no live sync — is the
  boundary the quote already draws.
- **Open** — restore is stated as the boundary, so live sync is out. What "restore" means
  concretely — a file, iCloud, a backup you can see — is not decided.
- **Open** — *folded in 2026-09-03, from the fourth sweep:* what a person does when the record
  cannot be read. `add-day-screen` (#91) has the day screen draw the day, keep nothing, and leave
  the file "for a person or a later version of the app to recover" — indefinitely. Nothing says
  how a person recovers. Restoring from a copy is the answer to a corrupt file as much as to a new
  phone, so it belongs here rather than as a want of its own.

### B-011 — see something of a commitment's history on the day screen itself
*Captured 2026-09-02.*

> "It can be decided if you want to see some information also on the landing screen, where
> entries are made"

- **Trigger** — passive, during a daily entry visit rather than a deliberate look.
- **Touches** — `day-screen`, and whatever B-007's page turns out to be: it is the same history,
  shown in the other place.
- **Principle** — tested against *nothing congratulates you*: a number's recent trend is a record
  and survives, but this want is one design decision away from failing — "six days in a row" on
  the landing screen is the streak the principle exists to forbid.
- **Open** — the owner explicitly left this undecided ("it can be decided"), so what grooming
  inherits is a decision, not a want. It cannot be taken before B-007, because what may appear on
  the day screen depends on what the detail page is a page *per*.

### B-017 — meet a quota over a longer span than a week
*Captured 2026-09-02.*

> "maybe I also want daily / biweekly / monthly quotas?"

- **Trigger** — the same trigger as the weekly quota, said of a longer stretch: gym twelve times
  this month, any days.
- **Touches** — `schedule` (#6). It is the weekly quota shape with its span made a parameter, and
  it needs no change to what a record is — which is what separates it from B-018.
- **Principle** — tested against *five percent of seven things*: fails, and is captured anyway.
  A quota over a different span deepens a rhythm that Story #11 already makes expressible; nothing
  on the day-one week asks for it, where reading 3× a week asks for the weekly one.
- **Re-opens a drop.** *Decided*, 2026-08-28: an unanchored "once a month" rule and a rule bounded
  to a stretch of weeks were dropped as *"invented while answering a question about rules; nothing
  in the day-one list claims either. Re-capture it if something real does."* This is that
  re-capture, and the monthly half is the same want the drop refused — refused then for want of
  anyone asking, not on its merits.
- **Open** — a fixed menu of spans, or any number of weeks? A quota of 12 a month and a quota of
  3 every 2 weeks are the same rule under different parameters, and the shape of the parameter is
  what decides whether this is one Story or three.
- **Open** — does "monthly" mean a calendar month or four weeks? February and a 31-day month hold
  different numbers of chances, which is the same collision `day-of-month` met and answered by
  clamping.
- **Open** — the week boundary that Story #11 could not answer (`docs/open-questions.md`
  § *Week turnover*) becomes worse here, not better: a span longer than a week has to say where it
  starts before a quota over it means anything.
- **Re-judged 2026-09-06** — stands, with yuno 5× a week where reading 3× a week was: the new week
  asks for the weekly quota exactly as the old one did, and for no longer span.

### B-025 — know where I stand on a weekly quota, inside its week
*Captured 2026-09-03, from the sweep. The wording is the sweep's.*

> "Know where you stand on a weekly quota inside its week — reading, two done, one to go."

- **Trigger** — mid-week, looking at the reading row and deciding whether tonight is one of the
  three.
- **Touches** — `schedule` (#6) and `day-screen` (#27). ADR-1015 makes a quota commitment due
  every day of its week, so its row appears all seven days saying exactly the same thing; the day
  view cannot see the week and says so by design (`CONTEXT.md` § *Day view*).
- **Principle** — tested against *nothing congratulates you*: **strains harder than any want yet
  captured, and is captured anyway.** "Two of three" is a count, and a count over a run of days is
  a streak with the arithmetic hidden. It survives only if what is shown is what the rhythm still
  *asks* — one more night this week — and never what has been achieved. If that distinction cannot
  be held in the design, this is a drop, and the next pass should say so rather than build it.
- **Open** — blocked on *Week turnover* (`docs/open-questions.md` § *Open product questions*):
  where a week begins and what an unmet third night becomes on Sunday night. Nothing about
  standing in a week means anything until that is answered, and this want is the thing that
  forces it.
- **Open** — what a met quota's row does: disappear, go quiet, or stay unchanged. `CONTEXT.md`
  § *Day view* records that hiding a met one is "a later Story's" and leaves it there.
- **Re-judged 2026-09-06** — stands, and sharper: yuno 5× a week leaves two spare days where reading
  left four, so *is tonight one of them* is asked on more days, and a row that says the same thing
  all seven is wrong on more of them.
- **Said again 2026-09-07, in the owner's own words.** The wording above is the sweep's; this is
  the first time the want has been stated by the person who has it, and it names a form:

  > "For the commitments that have the "n times a week" shape, it currently says something like "3x
  > a week" next to the commitment. However, I would like to know how many times it was already
  > kept this week (something like 1/3x a week)"

- **Touches, from that wording** — the string it wants changed is `schedule`'s, not a screen's.
  *A schedule says the rhythm it runs on in words* and *A weekly-quota schedule is said as a number
  of times a week* are what produce "3x a week", and neither has ever been given a history. "1/3x a
  week" is that string with a count of kept days put inside it, so either those words stop being the
  schedule's alone or the count is drawn beside them and the words are left as they are. They are
  said in two places since #144 — the commitments screen entry (`CommitmentsView`) and the day
  screen row (`ContentView`) — and "next to the commitment" does not say which is meant, or whether
  both are.
- **Open, from that wording** — it asks for "how many times it was already kept", which is the
  achieved side of the line the *Principle* above draws, and "one to go" is the asked side. The want
  is now on record in the form that principle warns about. Whichever pass takes it has to put that
  choice to the owner rather than quietly pick the safe half.

### B-032 — start a weight entry from the last weight I gave
*Captured 2026-09-06.*

> "When entering the weight for a day, I want my last weight entry to be prefilled, so that I can
> adjust it based on the last entry I made"

- **Trigger** — once a day, on the scale, changing the number by a few hundred grams from
  yesterday's.
- **Touches** — `record`, for what a numeric entry is, and `day-screen` for the row it is made in.
  It cannot be taken before B-001, which is the want that makes a weight recordable at all;
  nothing about this is buildable while there is no weight to prefill from.
- **Principle** — tested against *entered where you stand*: **passes, and is the sharpest example
  of it yet** — a weight typed from scratch is five taps on a number pad, and adjusted from
  yesterday's it is one or two, in the row. Tested against *five percent of seven things*:
  **fails** — it deepens one payload kind that does not exist yet rather than making a new record
  possible. Both are written down because the second is why a pass might reasonably not take it,
  and the first is why it is worth having when B-001 lands.
- **Open** — the last entry *ever*, or the last one before the day being entered? The day screen
  moves between days, so entering a weight for last Tuesday can prefill from Monday or from
  today, and only the first is "the last entry I made" as of that day.
- **Open** — does a prefilled row read as already answered? A suggested value and a recorded one
  must be told apart, or a day nobody stepped on the scale for silently carries a number. This is
  the one way the want could do real damage to the record, and it is a design question rather
  than a preference.
- **Open** — is this weight, or every number? B-002's protein accumulates across a day and B-003's
  mood is a single tap, so neither obviously wants it. If it is weight only, the prefill is a
  property of a kind of payload, which is a thing `record` does not have yet.

### B-034 — choose a mood from its range instead of typing it
*Captured 2026-09-06, at the grill of `add-number-record` (#138).*

> "Bounds only - but for a mood, I would like to have 1-10 (whole numbers) as predefined inputs,
> which can be chosen with e.g. a slider"

- **Trigger** — evening, once a day, saying how the day went; the one interaction the mood
  commitment exists for.
- **Touches** — `day-screen`, for what a row offers when the commitment declares a range. Not
  `record`: #138's grill settled that a range is bounds and nothing else, so 5.5 is a mood and the
  wholeness lives in the affordance rather than in what a number is.
- **Principle** — tested against *entered where you stand*: **passes**. A mood typed on a number
  pad is a keyboard for one digit; chosen from its range it is one gesture in the row, which is
  what "as little interaction as the value allows" means for a value with ten possibilities.
  Tested against *five percent of seven things*: **fails** — it deepens an entry that #139 will
  already have made possible. Both are written down because the second is why a pass might
  reasonably not take it.
- **Open** — is this every number with a range, or a mood? A weight with a range of 40 to 150 has
  a hundred and ten whole values and no useful slider, so the affordance may turn on how wide the
  range is rather than on the range existing.
- **Open** — a slider over whole numbers can express less than the record accepts, since the
  record takes 5.5. Is that a deliberate narrowing, or does the row need both ways in?
- **Open** — the *Decided* line of 2026-09-06 already sends the mood's one tap to the Story that
  enters a number (#139). This entry is that line's missing half: what the affordance actually is.

### B-039 — be reminded to record a day before it is gone
*Captured 2026-09-08, from the sixth grooming sweep. The wording is the sweep's.*

> "Be reminded to record a day before it is gone — every line of the week depends on remembering
> to open the app."

- **Trigger** — a day that ends unopened. All nine lines of the day-one week are recorded only if
  the app is opened, and the failure the whole product is built against is *"a gap a few days old
  that cannot be reconstructed"* (`docs/open-questions.md` § *Settled*, 2026-08-29).
- **Touches** — unclaimed, and probably nothing that exists. No capability holds a clock: ADR-1004
  says a commitment due "at 07:00" would be *"a notification concern, not a due-ness"* one, which
  parks the idea without deciding it. `EPIC: Daily commitments` (#1) does not exclude it, unlike
  graphs, restore and prefill.
- **Principle** — tested against *nothing congratulates you*: **passes on the letter and strains on
  the spirit.** A reminder is not a streak and celebrates nothing, but the same settled note that
  makes this want urgent also says what disqualifies Apple Reminders on its own terms — it *"nags
  and forgets"*. This product is the half that does not forget; whether it may also be the half
  that nags is the question, and it is the owner's alone.
- **Open** — is this a notification at all, or something quieter: a badge, or a day screen that
  says the last day you recorded nothing on? The want is "do not lose a day", and a notification is
  only the loudest of the answers to it.
- **Open** — per commitment, or per day? "creatine daily" and "finances every 25th" ask for
  different things: one is a time of day, the other is a date that comes round once a month and is
  easy to miss entirely.
- **Open** — a time of day is a thing no schedule holds. ADR-1004 bounded the rule engine to
  calendar dates on purpose, so this is either a fifth thing beside a schedule or a property of the
  reminder rather than of the commitment.

### B-041 — put a commitment in another group by dragging it there

*Captured 2026-09-08, at the grill of `add-category-order` (#168). The wording is the grill's; the
decision it records is the owner's, twice.*

> "The drop into another group is the gesture § Settled 14 was chosen for, and the owner has not
> changed their mind about it." — `add-commitment-category`'s `grill.md` § *Settled* 26

- **Trigger** — reorganising the list after a few commitments have piled up under the wrong words,
  with a thumb, on the phone.
- **Touches** — `commitment`, and only the app shell. **The requirement already exists and is
  tested**: *a commitment dropped among another group's entries is put under that group's category*
  and its neighbours are shipped scenarios of the commitments screen, reached at
  `CommitmentsScreen.move(_:toOffset:under:)`. Nothing is owed below the seam — what is missing is
  a gesture that reaches them.
- **Principle** — tested against *five percent of seven things*: **it loses.** The row's *Category*
  action already refiles across groups in one tap, so this deepens something that works rather than
  making a new thing possible. *An iPhone, in your hand* is the principle that argues for it — a
  drag is what a thumb reaches for — and it is not enough on its own.

  **Amended 2026-09-10**, after `rework-commitment-row-actions` (#192) shipped. **The one tap that
  argument rests on is gone.** That Story withdrew the row's *Category* action, and with it
  `CommitmentsScreen.put(_:under:)` and the requirement behind it; refiling across groups is now the
  change sheet's category field, reached by swiping right on the row for the pencil, opening the
  sheet, setting the word and saving. The verdict is left where it was on purpose — this entry is
  not the place to re-decide it, and the next grooming pass is — but the margin it was decided by is
  narrower than the line above reads, and a pass that quotes "already refiles in one tap" is quoting
  something that stopped being true. `grill.md` § *Settled* 14 of #192 recorded that this was owed.
- **Open** — is it buildable at all? Two things were measured rather than guessed at #147, and any
  future attempt starts from them: **`.onMove` and `.dropDestination(for:)` cannot share a
  `ForEach`** — instrumented, `.onMove` won every long press and `.dropDestination` never fired —
  and **an abstract `UTType` was not what was missing**, the payload having been moved to an
  exported type of the app's own with no change. Apple documents nothing either way.
- **Open** — is it testable? **No, on this machine.** The Simulator has no GUI here and XCUITest's
  synthetic touch never triggered `.dropDestination` in any configuration, so every attempt is a
  round trip through the owner's phone. Two evenings went that way. Price the want with that in it.
- **Open** — does iOS 27 make it free? `DynamicViewContent.reorderable(collectionID:)` is documented
  as moving items *within and between sections*, which is exactly this want — but it is beta, it is
  not in the SDK this project builds against, and its `sources` are item ids. Worth re-reading
  before anyone hand-writes a gesture again.

### B-042 — act on a commitment with one swipe, and keep the mode for reordering

*Captured 2026-09-09, after the phone walk of `add-commitment-editing` (#148).*

> "I was thinking to rename the 'Edit' just to 'Reorder', and to offer editing (Edit / Remove /
> Stop / Resume) as swipe actions.. what is your suggestion here, and what is state of the art?
> you can also think about 2 different swipe actions (left / right)"

> "Category as a swipe action is really not needed anymore, it can be done with the edit, so this
> has to be removed"

> "I want to have icons instead of words for the swipe actions - just nicer"

- **Trigger** — every visit to the commitments screen that is not just reading it: stopping
  something, renaming it, getting rid of it. Today each of those either needs a mode entered first
  or sits in a row of word-labelled buttons that grows every time a Story adds one.
- **Touches** — `commitment` (#26). Three of the four acts already have shipped requirements and
  seams behind them and are only being re-reached — `askToStopKeeping`/`confirmStopKeeping`,
  `askToRemove`/`confirmRemoving`, `keepAgain`, and the change sheet #148 landed. **The fourth is
  not**: dropping the *Category* swipe leaves `CommitmentsScreen.put(_:under:)` with no caller in
  the app, so *A commitments screen puts a commitment under a category, and offers the categories
  in use* would be a shipped, tested requirement nothing can reach. That is the delta, and it is
  why this is a Story rather than a chore.
- **Principle** — tested against *five percent of seven things*: **it loses**, as B-041 does. Every
  act it touches already works; this makes them nicer to reach. *An iPhone, in your hand* is what
  argues for it, and the honest weight is that the owner walked the feature on the phone and this
  is what they came back with.
- **Open** — which edge carries what. The suggestion made at capture, on Mail's and Reminders'
  convention: **leading edge Edit**, benign and most frequent; **trailing edge Stop-or-Resume then
  Remove**, destructive outermost so a full swipe removes. Never more than three a side before the
  labels truncate. Not decided.
- **Open** — icons or words. Icons are what Mail uses and they fit more per side, but they are
  learned rather than read, and *Stop keeping* is not a verb with an obvious glyph. The want asks
  for icons; whether every one of the four has an icon a person will guess is the question.
- **Open** — does the renamed *Reorder* mode keep anything but `.onMove`? If editing leaves it,
  the mode does one thing, and a mode that does one thing may not need to be a mode at all.
- **Open** — this reverses a decision taken hours earlier, and deliberately: the grill of #148
  settled at Q12 that the sheet and the swipe both set a category, and the phone walk changed the
  owner's mind. Recorded so the next pass does not read it as an oversight.

## Decided

One line per entry that has left, newest first. This is the dedup index: `/atlas idea` reads it
before writing a new entry, so a want that was dropped once is not re-argued from scratch three
months later.

- 2026-09-09 — reach the commitment form when I want it, not always under the list (B-037), and
  build a rhythm without being told what it will say (B-036) → both **shipped**, inside
  `FEAT: commitment` (#26), Story #148 `add-commitment-editing`, merged 2026-09-09. Neither was in
  that Story's accepted breakdown: they were taken into it during its grill, by the owner's
  decision, because a dedicated edit sheet beside a permanent define section is two forms that
  drift — so the one sheet serves defining and changing, reached by a `+` in the toolbar, and the
  rhythm-preview requirement was deleted outright as a REMOVED requirement, the first this
  repository has written. B-037's own open question is answered: a sheet, not a pushed screen.
  #26's G2 comment records a five-Story breakdown that does not carry either of them and is owed
  an amendment. B-042 above reworks the same row a third time.

- 2026-09-08 — **dropped**: tick a habit phrased as a negative, where ticking records that it was
  *not* done (B-005). Already covered: the Feature grill that reopened `FEAT: record` (#53) on
  2026-09-06 settled that negation is **a name**. A commitment called "No nail biting" takes a
  plain tick and its name says the rest; nothing in the record knows the difference and an absence
  is never counted, which is also what keeps it clear of *nothing congratulates you*. The fifth
  pass left it behind on purpose and told the sixth to propose the drop; the sixth proposed it and
  got no answer. Dropped by the owner directly on 2026-09-08, outside a pass. Re-capture it only if
  a negative turns out to need something a name cannot carry — the open question the entry ended
  on, whether *nails every 4 days* is this want said the other way round, is a question for that
  commitment's own rhythm and not for a want.
- 2026-09-08 — not be offered a way back to a day I am already on → `FEAT: day-screen` (#27),
  reopened under `EPIC: Daily commitments` (#1), a fourth round against that capability. The Today
  button is **hidden** on the day the screen is showing as today, not drawn-and-inert: it carries
  nothing there, and the want said "should not exist". Half of one Story with B-035, because the
  grill settled that both are the same rule — **offered**, landed in `CONTEXT.md` at that grill and
  product-wide rather than this screen's.
- 2026-09-08 — know that a commitment on a future day cannot be ticked yet → the same
  `FEAT: day-screen` (#27), the other half of that Story, and **against the want's own words**:
  no message. A row for a day that has not arrived is drawn — it still says what the day will ask —
  but it is not a target, which is what `day-screen`'s own prose already argued for. Since #141
  every kind's entry refuses a future day, so this is one rule over every row rather than four. It
  amends a shipped requirement, *A day screen tells nothing on a row where there was no tick to
  refuse*, whose third silent case stops being reachable.
- 2026-09-08 — get to a day weeks back without stepping through every day between → the same
  `FEAT: day-screen` (#27), a Story of its own and the only one here needing new kit surface. A date
  picker as **its own control** rather than the day title, so the Today button survives beside it;
  floored at the earliest kept-from day on the roster and **open forward**. Deliberately not a
  calendar month grid: that is a look-back view, Epic #1 excludes those by name, and it stays with
  B-007.
- 2026-09-08 — get to the day before or after without aiming at a chevron → **a chore on the app
  shell**, not a Story, under ADR-1019: `showPreviousDay` and `showNextDay` are already public and
  already wired to the chevrons, so the gesture carries no requirement. It sits **beside** them
  rather than replacing them, and **swiping left goes to the next day**. It owes an ADR all the
  same, because the grill claimed the horizontal swipe for the screen permanently — no row on a day
  screen can ever take a swipe action, which is the opposite of the commitments screen (#145, #146).
- 2026-09-08 — see the day's commitments in separated groups rather than one list →
  `FEAT: commitment` (#26), Story #147 `add-commitment-category`, whose delta carries *A day view
  draws its rows in the groups it was handed, and draws no group with nothing due* and has passed
  G4. Promoted by that Story's own grill rather than by a pass; the sixth pass verified it on the
  branch and moved the entry, as the fourth pass had to verify the third's claim.
- 2026-09-06 — see what rhythm a commitment runs on, in words → `FEAT: commitment` (#26),
  reopened, as Story #144 `add-rhythm-in-words`, the head of cluster B's chain. One change with two
  delta specs: `schedule` gives its payloads back and says each shape in words, and `commitment`
  drops "a name and nothing else" from the commitments screen's entries. The 2026-09-03 G1 had this
  reopening `FEAT: schedule` (#6); at G2 the owner accepted the second delta spec in its place, so
  #6 stays closed. Whether the day screen row says it too is left to the Story's grill.
- 2026-09-06 — get rid of a commitment for good, not just stop keeping it → `FEAT: commitment`
  (#26), Story #145 `add-roster-removal`, blocked by #144. A roster operation reached from the
  commitments screen, for a kept or a stopped commitment, after a confirmation. What becomes of the
  ticks, and whether removal is offered on a commitment that has any, is its grill's; it owes
  ADR-1027's test for a place nothing has ever been taken on at. The icon layout the owner sketched
  is the screen's to decide there.
- 2026-09-06 — put my commitments in the order I want them → `FEAT: commitment` (#26), Story #146
  `add-roster-order`, blocked by #145. The roster's order becomes one the person set, on the
  commitments screen; a stopped commitment's place in it is its grill's. Not B-030 said differently:
  groups are an order the app works out and stay a want behind B-029.
- 2026-09-06 — tell supplements and habits apart as kinds of commitment → `FEAT: commitment` (#26),
  Story #147 `add-commitment-category`, blocked by #146. A category is held on the roster and not on
  the commitment: ADR-1030 let the kind be a fourth part only because it never changes, and a
  category a person can change re-keys every tick on the argument ADR-1023 made. A fixed set or
  invented words, and how many per commitment, are its grill's. B-030 waits on it and stays a want.
- 2026-09-06 — change a commitment: its name, or the rhythm it runs on → `FEAT: commitment` (#26),
  Story #148 `add-commitment-editing`, blocked by #147 and last in the chain so the four cheaper
  Stories land first. Left behind at the 2026-09-03 G1 because it does not compose; taken now
  because its grill decides whether a commitment gains an identity of its own, which is an ADR
  amending 1023 and 1030 in place — ADR-1030 names this want as its trigger. The kept-from day is in
  scope beside the name and the rhythm. `add-kind-to-commitments-screen` (#142) is blocked by it,
  because every Story of the chain and #142 delta `commitment` and serialise (process §7).
- 2026-09-06 — record a weight for a day, and see it as a line over months → the first half to
  `FEAT: record` (#53), reopened under `EPIC: Daily commitments` (#1), amended rather than doubled.
  A **number** is a kind of record: one decimal for the day, replaced when entered again, no unit,
  an optional range. The second half, the line over months, was already B-007's and stays there.
- 2026-09-06 — add to a running total across a day → `FEAT: record` (#53). A **total** is a kind of
  its own: the additions in the order they were made, summed, kept when the sum reaches a required
  **target**. The owner chose accumulation over a number typed once, and a target over kept on the
  first addition, against the recommendation both times.
- 2026-09-06 — set a mood for the day with one tap → `FEAT: record` (#53). Mood is a number with a
  **range** of one to ten, declared with the commitment and refusing what is outside it; the one tap
  is the row's affordance and belongs to the `day-screen` Story that enters a number.
- 2026-09-06 — write two or three sentences about a day → `FEAT: record` (#53). A **note** is a kind
  of record: short text for the day, typed in the row and nowhere else. The journal is written text
  and not a tick — the lean the braindump gave, now decided.
- 2026-09-06 — meet a quota more than once in a single day → merged into the **total** kind at
  `FEAT: record` (#53): three taps in a day are a total added to by one, with a target of three. It
  contradicted `CONTEXT.md` § *Record*'s one per day and no longer does — the record is the
  additions, and there is one per commitment per day.

- 2026-09-03 — see, in the row, that today's commitment is kept → a chore on the app shell,
  `chore/draw-kept`, under ADR-1019: `Row.isKept` is already public and drawing it carries no
  requirement, so there is nothing for a Story to specify. Kept is a dimmed name and a plain
  checkmark, no colour, no animation — the row goes quiet. Lands before #100, since there is
  nothing to say a tick was *not* kept while nothing shows that one was. **Amended 2026-09-09** by
  ADR-1045, over two looks at the built app: a kept row's name is **struck through**, and the
  checkmark takes the **system green**. The line reads *a struck-through dimmed name and a plain
  green checkmark, no animation.* "No colour" is **withdrawn**, and only for the checkmark — it is
  the only mark the trailing slot draws at all. The open circle an unkept tick row briefly offered
  in the accent was **removed 2026-09-09 by `chore/unmark-the-offered-row`** after a day of use,
  reversing ADR-1045 decision 4; the accent had been tried on the checkmark first and rejected, so
  it no longer appears in that slot in either state. **The row no longer goes quiet in the way this line meant**: that clause was
  written when the mark was plain, and green is the canonical congratulation colour, so this is
  the closest the app has come to `CONTEXT.md` § *Nothing congratulates you*. The objection was
  put to the owner in those terms and overruled; ADR-1045 § *Decision 8* carries both sides and
  the trigger for reopening it.
- 2026-09-03 — be told when a tick I made was not kept → Story #100 `add-refused-tick-notice`,
  under `FEAT: day-screen` (#27), appended to the chain after #93. The refusal is told on the row
  that was tapped and stays until the app is shown again or a tick on any row is kept — the
  lifetime a screen without its record already has; every refused tick is told the same way.
  `CONTEXT.md` § *Day screen* carries it.
- 2026-09-03 — define a commitment from the phone, a name and the rhythm it runs on → `FEAT:
  commitment` (#26), reopened rather than minted, under `EPIC: Daily commitments` (#1). Taken at G1
  with B-020 and B-013 as one Feature, the commitment's lifecycle, in a session of its own. That G1
  left two of the cluster's five wants behind, and they stay in *Wants* above: B-021, because
  saying a rhythm in words is a delta against `openspec/specs/schedule/spec.md` and reopens
  `FEAT: schedule` (#6); and B-014, because changing a commitment does not compose — a rename
  keeps its history only if `record` re-keys its ticks, and a rhythm change cannot be retroactive
  at all, since `Tick` refuses a date its commitment is not due on. The reasoning is on #26 as a
  comment.
- 2026-09-03 — see every commitment I keep, in one place → the same `FEAT: commitment` (#26). It is
  the list B-013 and B-014 both have to reach a commitment through, and its own open question —
  whether retired commitments show in it — was answered at G1: they are hidden from it.
- 2026-09-03 — stop keeping a commitment → the same `FEAT: commitment` (#26). Its own open
  question, whether retiring is a kept-until day mirroring ADR-1013's kept-from day, was answered
  at G1 and the answer is no: `Tick` embeds the whole `Commitment` value and `History.isKept`
  matches by value, so a fourth part would change a commitment's identity and orphan every tick
  already recorded — the history would read empty the moment anything was retired. Retiring
  belongs to whatever holds the set of commitments a person keeps, and every past day then answers
  exactly as it did.
- 2026-09-03 — tick a commitment on the phone and find it still ticked → `FEAT: day-screen`
  (#27), reopened, under `EPIC: Daily commitments` (#1). Story numbers follow at #27's G2. The
  requirements live behind the seam in `DayByDayKit` and not in `src/DayByDay`, because CI runs
  `swift test` only where a `Package.swift` is while check 4 walks every `.swift` in the tree —
  a test in the app target would match its scenario and never run. It consumes two known gaps:
  the store's place under `Library/Application Support/`, and the fourth error case
  `RecordStore.init` can throw.
- 2026-09-03 — see which day the screen is showing → `FEAT: day-screen` (#27), same cluster. Its
  Story carries a delta against `openspec/specs/schedule/spec.md` as well, to read a
  `CalendarDate` back; that is the fifth face of the payload read-back gap, and the first change
  in this repo to delta two capabilities at once. The date is said as a weekday and a date, with
  "Today" added only on today.
- 2026-09-03 — move between days on the phone → `FEAT: day-screen` (#27), same cluster. `DayView`
  already answers for every supported date and shipped `previousDay`/`nextDay` with #72; what was
  missing was any way to reach them. A day screen holds the today it was handed when the app was
  shown and does not follow the clock while it is being looked at, so a screen never moves onto a
  different day underneath the person reading it.
- 2026-09-02 — tick a commitment from the day I am looking at → Story #71
  `add-tick-from-row`, under `FEAT: day-screen` (#27). The tap belongs to `day-screen`, settled at
  the Feature grill: `record` says what a tick is and knows nothing of a row, so #53 stays closed.
  Its other half — whether the same tap takes the tick back — went into the Story rather than
  staying a want.
- 2026-09-02 — go to a day other than today, and tick it → Story #72 `add-day-navigation`, under
  `FEAT: day-screen` (#27), with the ticking half in #71. A day view answers for every supported
  date, so the open product question *how far back the past stays writable* is answered in
  direction: as far back as the calendar goes, bounded by navigation rather than by a rule. It
  leaves `docs/open-questions.md` when #72 settles it, not before.
- 2026-09-02 — keep unticked commitments visible into the evening rather than silently missed →
  Story #70 `add-day-view`, under `FEAT: day-screen` (#27). It needs no requirement of its own: a
  day view lists what the date asks for and a ticked commitment stays in it and goes quiet, which
  is the whole of this want.
- 2026-09-02 — tick a due commitment on a day, and have it kept → `FEAT: record` (#53),
  under `EPIC: Daily commitments` (#1). B-001..B-005 stay wants and reopen it when they come;
  B-009 is now a Story against it rather than a capability of its own.
- 2026-09-02 — merged: B-008 (see a commitment aggregated over time) into B-007. A page per
  commitment *is* the aggregate; the two were one look-back said in two breaths, and B-008's
  other half — navigating to a past day — is B-016.
- 2026-09-02 — dropped into `CONTEXT.md` § *Product principles* as *Entered where you stand*:
  B-010 (make every daily entry from the landing screen, without navigating). It says how
  everything is entered and adds nothing to enter, so it judges wants rather than being one —
  the reading its own Open line suspected.
- 2026-08-31 — reading 3× a week, any nights, open until the week turns over → Story #11
  `add-weekly-quota-schedule`, under `FEAT: schedule` (#6).
- 2026-08-31 — a commitment due on the 25th of every month → shipped,
  `openspec/specs/schedule/`.
- 2026-08-31 — a commitment due every N days, counted from a start date → shipped,
  `openspec/specs/schedule/`.
- 2026-08-30 — a commitment due on a set of weekdays → shipped, `openspec/specs/schedule/`.
- 2026-08-28 — a day screen, its ticks, and the schedule behind them → `EPIC: Daily commitments`
  (#1), and from there `FEAT: schedule` (#6), `FEAT: commitment` (#26) and `FEAT: day-screen`
  (#27).
- 2026-08-28 — dropped: an unanchored "once a month" rule, and a rule bounded to a stretch of
  weeks. Invented while answering a question about rules; nothing in the day-one list claims
  either. Re-capture it if something real does.

## Grooming passes

One dated line per `/atlas backlog` pass, appended by the pass itself, oldest first. A pass that
promoted nothing still gets a line: this log is where a pass records what its sweep found and
which clusters it declined and why, and the next pass — and `/to-tickets` — start from that
reasoning rather than from the wants alone. Say what the coverage sweep found, including when it
found nothing.

- 2026-09-02 — pass over 11 wants, the first.
  - **Sweep** — every rhythm on the day-one week is shipped or in flight (#11), and not one of
    the eight commitments can yet be defined on the phone, shown for a day, or ticked. Ticking
    has no Feature, no Story and no want — the Epic absorbed it on 2026-08-28 and no Feature
    claimed it, and both in-flight Stories say in writing that no tick exists. `commitment`
    (#42) excludes changing and retiring one by name and nothing wants either; defining one
    from a screen is unsaid; going to a day other than today is implied by "the past is
    writable" and said nowhere. `docs/open-questions.md` holds no want in disguise.
  - **Housekeeping** — Principle lines filled in on B-001..B-009. Captured B-012..B-016 from
    the sweep; merged B-008 into B-007; dropped B-010 into `CONTEXT.md` as *Entered where you
    stand*.
  - **Taken forward** — cluster A, the record: B-012, with B-001..B-005 behind it — grilled and
    promoted at G1: B-012 → `FEAT: record` (#53). Its G1 left behind B-001..B-005, which reopen
    #53 when they come and mean amending Epic #1's exclusion list then; and for its G2 the pass
    suggested the pure record shape as Story 1, durability with the storage ADR as Story 2, and
    a check whether #27's first Story reads records, which decides whether #27 and #53
    serialise (`docs/process.md` §7).
  - **Not taken**, each with the disposition the pass proposed, so the next pass starts from it
    rather than from the Touches lines alone:
    - **B**, day-screen: B-006, B-011, B-016 stay wants for #27's G2, which status already
      lists; B-006 reads as a requirement of #27's first Story rather than a Story of its own,
      and B-011 cannot be decided before B-007.
    - **C**, looking back: B-007, with B-008 now inside it, unclaimed; nothing to look back at
      until #53 has a Story, so it stays.
    - **D**, restore: B-009, a Story against #53 once the first record Story has chosen the
      store.
    - **E**, the commitment's lifecycle: B-013, B-014, B-015 as Stories reopening #26 — define
      first, then change, then retire; B-013 may be a kept-until day mirroring ADR-1013.

- 2026-09-02 — pass over 18 wants, the second, on the same day as the first.
  - **Sweep** — three silences, all captured before clustering: B-019, ticking from the row,
    which is the seam between `day-screen` (#27) and `record` (#53) that neither Feature's
    intent claims; B-020, seeing every commitment in one place, which B-013 and B-014 both have
    to reach a commitment *through*; B-021, a rhythm said in words, whose technical half was
    already in `docs/open-questions.md` § *Known gaps* before anyone had asked for it. The
    day-one week has no rhythm left uncovered: all four shapes shipped when #45 merged mid-pass,
    closing Story #11 and `FEAT: schedule` (#6). Nothing was stale — the counter counts passes
    dated strictly after a capture and both passes are 2026-09-02, so the forced choice first
    fires on a later date. *(Left as the pass wrote it. The claim was wrong — B-001..B-009 were
    captured 2026-08-28 and both passes counted against them — and the counter it describes was
    withdrawn on 2026-09-03, ADR-1010.)*
  - **Taken forward** — cluster A, the day screen you can use: B-019, B-006, B-016, grilled and
    taken to `FEAT: day-screen` (#27). #27 is at G2 rather than G1, so no Feature was minted and
    the three wants left *Wants* the same day, once its Stories carried numbers: B-006 → #70,
    B-019 → #71, B-016 → #72. The grill settled three things, now in `CONTEXT.md` as **day
    view** and **row**: ticking belongs to `day-screen` and #53 stays closed; a day view answers
    for every supported date, and a row after today is shown and refuses the tick; the day
    preserves the order it is handed, because a commitment has no identifier to order by. The
    open product question *how far back the past stays writable* is answered in direction but
    stays open in `docs/open-questions.md`, by that file's own rule that an item leaves when the
    change forcing it settles it — here, #27's first Story.
  - **Not taken**, each with the disposition this pass proposed:
    - **B**, the commitment's lifecycle: B-015, B-020, B-014, B-013, B-021 as Stories reopening
      `commitment` (#26), plus a screen capability that should not be minted before #27 has
      proved the seam; recommended next, once #56 has chosen the store.
    - **C**, a record that is not a tick: B-001..B-005 and B-018 reopen #53 and change
      `CONTEXT.md` § *Record*, agreed the same morning; whoever takes it must merge or separate
      B-002 and B-018 deliberately rather than let both survive by default.
    - **D**, looking back: B-007 and B-011, unclaimed, nothing to look back at until #56 lands a
      store.
    - **E**, restore: B-009, a Story against #53 once the store is chosen — and Epic #1 excludes
      "export and restore" by name, so promoting it amends the Epic's exclusion list.
    - **F**, quota spans: B-017 stays; the weekly quota shipped today and nothing on the day-one
      week asks for a longer span.

- 2026-09-03 — pass over 19 wants, the third.
  - **Sweep** — four silences, all confirmed and captured before clustering, and three of them
    one discovery: `schedule`, `commitment`, `record` and `day-screen` had all shipped and
    closed, and the app on a phone still recorded nothing, because every Story stopped at the
    `DayByDayKit` seam. B-022 tick and keep it on the phone, B-024 move between days, B-023 name
    the day you are on — the shell drew row names and neither ticked, persisted, moved nor said
    which day it was. B-025 is the weekly quota's missing half, a row that appears all seven days
    saying the same thing, captured with its failure written down: it strains *nothing
    congratulates you* harder than anything yet captured and is blocked on *Week turnover*
    besides. The day-one week has no rhythm uncovered. The lifecycle verbs on `commitment` are
    all claimed (B-015, B-014, B-013); on `record`, create and untick shipped and nothing in the
    app used either. `docs/open-questions.md` held no other want in disguise.
  - **Taken forward** — cluster A, the app that records anything at all: B-022, B-023, B-024,
    grilled and taken to `FEAT: day-screen` (#27), reopened rather than minted. It is Epic #1's
    own outcome sentence, which had closed undelivered. The grill ran two rounds and settled
    five things: the requirements land in `day-screen` with deltas into `schedule` and `record`
    rather than in a new capability; a store that will not open draws the day and refuses every
    tick rather than losing one in memory; a day screen does not follow the clock while it is
    being looked at; the date is said as a weekday and a date with "Today" only on today; and
    the day is re-read when the app is shown, so the morning visit lands on the morning. Two
    `CONTEXT.md` edits came out of it — **day screen** as a new term, and **today** amended,
    because it had claimed a today is never kept and a day screen keeps one. Proposed for its
    G2: the running day first, then reading a date back, then moving between days, with the
    store's refusal folded into the first unless the breakdown disagrees.
  - **Not taken**, each with the disposition this pass proposed:
    - **B**, the commitment's lifecycle: B-015, B-020, B-014, B-013, B-021 as Stories reopening
      `commitment` (#26), plus a screen that is not the day screen. Recommended by both earlier
      passes as next and overturned here — the eight day-one commitments are hard-coded in the
      shell, so defining them from the phone buys nothing that cannot already be seen while the
      app cannot record a tick. The owner took it forward in a separate session the same day.
    - **C**, a record that is not a tick: B-001..B-005 and B-018 reopen `record` (#53) and
      rewrite `CONTEXT.md` § *Record*, whose "at most one per commitment per day" B-018
      contradicts. Whoever takes it must merge or separate B-002 and B-018 deliberately. Also
      taken forward in a separate session the same day.
    - **D**, looking back: B-007 and B-011, unclaimed. There is now a store to look back at, but
      nothing has been recorded on a phone until cluster A lands, so it stays.
    - **E**, restore: B-009, a Story against #53. Unblocked for the first time — the store's
      shape was chosen by ADR-1017 — and promoting it amends Epic #1's exclusion list.
    - **F**, quota spans and standing: B-017 and B-025, both blocked on *Week turnover*
      (`docs/open-questions.md`), which nothing yet forces.

- 2026-09-03 — pass over 15 wants, the fourth.
  - **Sweep** — two silences, both confirmed and captured before clustering, and both the same
    lesson as the third pass one Story later: `add-day-screen` (#91) made the app keep a tick and
    the shell still drew nothing but a row's name, so a tap changed nothing a person could see
    (B-026); and the one failure a tick reports was swallowed by a `try?` in the shell, sitting
    in `docs/open-questions.md` as a gap "owed by whichever Story first gives the shell a way to
    say anything" — a want in disguise (B-027). A third silence, what a person does when the
    record cannot be read, was folded into B-009's Open lines rather than minted: restoring from
    a copy is the answer to a corrupt file as much as to a new phone. The day-one week has no
    line unclaimed. Lifecycle verbs: `commitment` all claimed; `record` has create and untick
    shipped, other kinds in cluster C and discard now in B-009; `schedule`'s read-back in words is
    B-021; `day-screen` had create shipped and move in flight, and show-kept was the gap.
    *Week turnover* stays a question, forced by B-025 and nothing else. One discrepancy found:
    the third pass logged cluster C as "taken forward in a separate session the same day", and
    nothing on the tracker or in *Decided* shows it — #53 is closed without comment and
    B-001..B-005 and B-018 are still here. Treated as not taken.
  - **Taken forward** — cluster A, the day screen you can read: B-026 and B-027, grilled and
    taken to `FEAT: day-screen` (#27) at G2, a third round against the same capability. The
    grill settled three things: drawing a row's kept flag is the app shell's and carries no
    requirement, so B-026 is a chore under ADR-1019 rather than a Story (PR #105); kept is a
    dimmed name and a plain checkmark, no colour, no animation; and a refused tick is told on the
    row that was tapped and lasts until the app is shown again or a tick on any row is kept,
    the lifetime a screen without its record already has, every refusal told the same way.
    `CONTEXT.md` § *Day screen* was amended for the last. B-027 → Story #100
    `add-refused-tick-notice`, appended to the chain after #93 rather than reordering the chain
    accepted this morning. Left behind on `day-screen`: B-011 until B-007, B-025 until *Week
    turnover*.
  - **Not taken**, each with the disposition this pass proposed:
    - **B**, a record that is not a tick: B-001..B-005 and B-018 reopen `record` (#53), touch
      `commitment` for the payload kind and `day-screen` for the entry in the row, and rewrite
      `CONTEXT.md` § *Record*. Epic #1 excludes weight, protein, mood, the journal and negative
      habits by name, so it is a second Epic or an amended exclusion list — a session of its
      own. Not started while #26 owes a decomposition and #27 has #92, #93 and #100 waiting.
      Whoever takes it must merge or separate B-002 and B-018 deliberately.
    - **C**, looking back: B-007 and B-011, unclaimed. Unblocked for the first time — #91
      records ticks on a phone — and B-011 still cannot be decided before B-007.
    - **D**, restore: B-009, now also covering a record that cannot be read. A Story against
      #53; Epic #1 excludes "export and restore" by name, so promoting it amends the Epic.
    - **E**, two singletons rather than a cluster: B-014 as a Story against #26 once retiring
      exists and #26's G2 has happened; B-021 as a Story reopening `schedule` (#6).
    - **F**, quota spans and standing: B-017 and B-025, blocked on *Week turnover*, which
      nothing yet forces.

- 2026-09-06 — pass over 19 wants, the fifth.
  - **Sweep** — one silence, confirmed and captured before clustering: B-033, the roster's order,
    the one lifecycle verb on `commitment` nothing had said. Every line of the 2026-09-04 week is
    under a spec and the shell's seed matches it; `record`, `schedule` and `day-screen` have every
    verb claimed by a want or a spec. `docs/open-questions.md` held no want in disguise; two of its
    entries are for that file to fix — the Story-template gap is stale since #136, and the
    row-identity gap is live since #104 and unowned. The five wants the week said to re-judge all
    stand, each with a *Re-judged* line, B-005 too; the kept-from day folded into B-014 as Open.
    PR #135's captures (B-031, B-032, the fold into B-021) were read as part of the file.
  - **Taken forward** — cluster A, a record that is not a tick: B-001, B-002, B-003, B-004, B-018,
    grilled and taken to `FEAT: record` (#53), reopened under Epic #1, amended rather than doubled.
    Three rounds, fourteen questions. Settled: the kind is the fourth part of a commitment, and that
    answers B-029's question too; four kinds — tick, number, note, total; a number is a decimal with
    no unit and an optional range; a total is its additions in order with a required target, kept
    when reached (both against the recommendation); a note is short text; negation is a name;
    entering keeps the day; taking back is the general verb. Six terms and four amendments in
    `CONTEXT.md`. Left behind: B-032 (prefill), B-005 (a name — propose the drop next pass), B-007
    and B-011 (looking back). Proposed for G2: the kind first, then the number, the note, the total,
    the row's entry as a `day-screen` delta, then defining a kind on the commitments screen as a
    `commitment` delta serialised after cluster B's Stories on #26. The fourth part is owed an ADR
    at Story 1's Stage 4.
  - **Not taken**, each with its disposition:
    - **B**, the commitment's lifecycle: B-021, B-031, B-033 as Stories reopening `commitment`
      (#26) — **taken forward in a separate session the same day, by the owner's decision**, with
      B-014 and B-029 held until A's G1 had decided where the kind lives. That is decided now, so
      both may follow in a second breakdown. The next pass verifies this on the tracker and in
      *Decided* before believing it, as the fourth pass had to.
    - **C**, the day screen's reading: B-028 free-standing; B-030 waits on B-029, B-025 on *Week
      turnover*, B-011 on B-007.
    - **D**, looking back: B-007, unclaimed; nothing has been recorded on a phone yet.
    - **E**, restore: B-009. The phone install is runnable since today and its record is one
      deleted app from gone — the strongest reason yet to take it.
    - **F**, quota spans: B-017, blocked on *Week turnover*.

- 2026-09-08 — pass over 16 wants, the sixth.
  - **Sweep** — run first against a stale file and corrected mid-pass: `main`'s `docs/backlog.md`
    held ten wants while four more (B-035..B-038) sat on the open `chore/backlog` PR #155, so the
    sweep was re-run against the branch. That is the second time a pass has had to verify a claim
    about the backlog's own contents before believing it. Three silences found and put to the
    owner; two captured. B-039, nothing reminds you to record a day before it is gone — not
    excluded by Epic #1, and the settled note that makes it urgent is the same one calling nagging
    what disqualifies Apple Reminders. B-040, reaching a day weeks back costs one tap per day
    between. The third was **declined**: `record` has no retire verb at all — `add-roster-removal`'s
    Non-goals say "no tick leaves a record" in as many words — and that is a consequence #145 chose
    deliberately, with nothing in the week asking for it. Day-one week: every line has a spec and
    the shell seeds it; the one partly served is *yuno 5× a week*, whose row says the same thing all
    seven days, which is B-025. Lifecycle verbs: `commitment` all claimed or in flight; `record`
    create and take-back shipped for all four kinds once #141 merged mid-pass, retire declined
    above; `day-screen` had create and move shipped, and its **controls** were the gap.
    `docs/open-questions.md` held no want in disguise — its new entry, the one reader all four kinds
    would share, is a technical decision and unowned.
  - **Taken forward** — cluster A, the day screen's controls: B-028, B-035, B-038, B-040, grilled
    and taken to `FEAT: day-screen` (#27), reopened. Three rounds, eleven questions, no fact sent to
    the owner. Settled: a row for a day that has not arrived is drawn but is not a target, against
    the want's own request for a message; the Today button is hidden on today; the date picker is
    its own control, floored at the earliest kept-from day and open forward, and not a calendar
    grid; the swipe sits beside the chevrons and left goes forward; the calendar's two ends stay
    exactly as #93 left them, said out loud rather than left to look alike. One term landed in
    `CONTEXT.md` — **offered**, product-wide rather than this screen's. One ADR owed, for claiming
    the horizontal swipe. One shipped requirement to amend. Proposed for G2: the offered rule first,
    as one Story over both controls, then the date picker; the chore can land at any time.
  - **Not taken**, each with its disposition:
    - **B**, the commitments form: B-036, B-037. Both delta `commitment` and queue behind #147,
      #168, #148 and #142 (`docs/process.md` §7). Worth taking together — one may make the other
      free, since both move the same section of that screen.
    - **C**, looking back: B-007, B-011. Epic #1 excludes graphs and detail pages by name, and
      B-040's answer deliberately left the calendar grid here rather than taking it.
    - **D**, restore: B-009. **Recommended at the cluster stop and not taken.** It is the only want
      whose absence costs the record rather than comfort, and the phone now holds real ticks,
      numbers and notes.
    - **E**, standing in a quota: B-025, B-017. **Recommended at the cluster stop and not taken.**
      #141 shipped *A total entry says the day's sum and the commitment's target* — "150 of 120" —
      so B-025's form is now argued and past a G4, and what is left of the objection is whether that
      grammar may cross a day boundary, which is *Week turnover*.
    - **F**, entry affordances: B-034; B-032, which Epic #1 excludes by name.
    - **Singleton**: B-005, whose drop the fifth pass told this one to propose. Proposed at the
      cluster stop and **not taken** — the reply named a cluster and not the drop — so it stays a
      want and the seventh pass should propose it again.
