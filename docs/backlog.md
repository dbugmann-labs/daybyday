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
  tested**: *an offset a commitments screen is given is counted over the group a drop landed in and
  not over the roster's own order* and its neighbours are shipped scenarios of the commitments
  screen, reached at `CommitmentsScreen.move(_:toOffset:under:)`. Nothing is owed below the seam —
  what is missing is a gesture that reaches them. This named *a commitment dropped among another
  group's entries is put under that group's category* until 2026-09-12, when #216 dropped that
  scenario as one the keeper above already asserts.
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
- **Re-read 2026-09-15**, at the ninth pass, as the amendment above asked: **leave**, not drop. The
  one-tap argument is gone, but the two Open lines below still price it at an evening per attempt
  with no test, and the iOS 27 API may make it free. Re-decide when the SDK carries it.
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

### B-054 — keep a weekday-set commitment on a day it is not due

*Captured 2026-09-15, from the ninth grooming sweep. The wording is the sweep's; the owner confirmed
it as a gap rather than saying it unprompted.*

> "Keep a weekday-set commitment on a day it is not due — gym is Mon/Wed/Sat, and a Monday that
> slips to Tuesday loses its tick."

- **Trigger** — the gym day that moves by one because of work, weather or a sore leg. Rarely, but
  it is the same event B-052 turned out to be for an every-N-days rhythm: a rhythm kept, late.
- **Touches** — `record`, whose tick is *of a commitment on a calendar date it is due on, and nothing
  else*, and `day-screen`, which draws a row only for what is due, so on the Tuesday there is no
  row to tick. Not `schedule`, unless the answer is a one-time swap of days. The only workaround
  today is the change sheet — change the rhythm to Tue/Wed/Sat, tick, change it back — which is
  two supersedes and a split history, the shape B-052's kept-from move had.
- **Principle** — tested against *five percent of seven things*: **fails** — it deepens a rhythm
  shape that works. Captured anyway because the workaround splits a history the product exists to
  keep whole, and because the weekly quota already exists as the shape for "three times a week, any
  days": the grill may well answer this want by saying gym is a quota, and that is worth deciding
  on the record rather than by nobody asking.
- **Open** — is this a tick on a day the commitment is not due, or that week's Monday moved to
  Tuesday? The first is a record rule; the second is a schedule exception, and the eighth pass
  declined a late row for intervals.
- **Open** — is the weekly quota the answer? Gym as 3× a week loses nothing but the named days, and
  standing (#235) already says where the week stands.
- **Open** — where does the row come from? A day view draws what is due; a Tuesday row for gym is a
  row for something not due, which is the thing *offered* was landed to keep off the screen.

## Decided

One line per entry that has left, newest first. This is the dedup index: `/atlas idea` reads it
before writing a new entry, so a want that was dropped once is not re-argued from scratch three
months later.

- 2026-09-24 — choose a mood from its range instead of typing it (B-034) → `FEAT: day-screen`
  (#27), reopened under Epic #1, with B-032 in the same cluster. The missing half of the 2026-09-06
  mood line: a number whose commitment has a **short range** — whole bounds, eleven values or fewer —
  is **chosen** by one tap on a value and never typed; every other number is typed. One tap over the
  slider the capture named, because the mood line promised one tap and a slider is a drag. Derived
  from the range, not declared; choosing is the only way in, so the row never offers the 5.5 the
  record still takes; an empty day starts with nothing chosen. Recommended as the first Story.
- 2026-09-24 — start a weight entry from the last weight I gave (B-032) → `FEAT: day-screen` (#27),
  with B-034. Epic #1's exclusion amended at G1 to "prefilling an entry other than a typed number
  from the last one". A typed number on a day that holds none starts from its **starting number**:
  the latest number on a date before that day, any era, no horizon — not the latest ever, so a
  back-filled Tuesday starts from Monday. Every typed number, not a weight only, since nothing knows
  a commitment is a weight. Committed unchanged it is recorded; cancelled it records nothing. The
  range hint stays "for an empty field" and goes when the field opens prefilled — the owner's call,
  against the recommendation to say the range whenever the entry is open.
- 2026-09-24 — see the birthdays my calendar already knows, and tick them off (B-059) →
  `FEAT: birthday` (#322) under `EPIC: Birthdays` (#321), a new Epic on the recommendation.
  Grilled at the eleventh pass, twelve questions over three rounds, one fact agent, no fact sent
  to the owner. A birthday is a row on the day screen, never a notification; birthdays only, not
  the day's calendar; the row says the name and the age where the calendar has the year (the
  owner's call against name only); everyone the calendar holds, chosen nowhere in the app; read
  from the phone's birthday calendars through Calendar access, never from Contacts; behind a
  switch on the commitments screen, off until turned on, which also says when access is refused;
  a birthday stays on its day and never follows forward; the tick says what the calendar says
  now, so a renamed contact renames the row and a deleted one takes its ticked row with it (the
  owner's call against keeping the row as ticked); its own group, *Birthdays*, first (the owner's
  call against last); the copy carries birthday ticks; the switch off keeps them and draws
  nothing. Term **Birthday** in `CONTEXT.md`, with **Day view** and **Copy** amended. Carried to
  the first Story's grill as a fact to establish: whether a contact's identifier survives a new
  phone. Left behind by id: B-039, B-054, B-032, B-034, B-041.
- 2026-09-21 — change a commitment and still have one commitment, with one day it is kept from
  (B-058) → `FEAT: commitment` (#26), reopened a fourth time under Epic #1, with B-057 in the same
  cluster. Grilled at the tenth pass, fourteen questions over three rounds, three fact agents, no
  fact sent to the owner. **A commitment gets an identity of its own**, and its eras and every
  record against it hang off that rather than off its value — the first of the four ADRs this
  reverses in place is ADR-1023, with 1030, 1035 and 1055 behind it. Settled: a rename reaches the
  whole commitment, every era and every past day; the sheet shows one *Kept from*, the earliest
  era's, and says nowhere when the current rhythm began; a rhythm changed twice on one day leaves
  one era, because an era nobody kept a day on is not one; the roster refuses a name already in use
  by a kept or stopped commitment, and no longer a value; **the removed state goes** — a commitment
  is kept, stopped or gone, so stopping and resuming is the way to pause one and there is no way
  back from a deletion; a stop ends an era and a resume begins one from the day of the resume, so
  the days between owe nothing and draw no row. The roster on the phone is folded once at the
  upgrade: adjacent eras by name, kind-sort and day fold under one commitment; a removed entry that
  nothing kept or stopped resembles by name and kind is erased with its records (the owner's call,
  against the recommendation to make them stopped); a removed entry that resembles a live one but
  does not chain survives as its own stopped commitment, tidied by hand. Four Stories at G2, the
  same day, from `/to-tickets 26` stopped after its quiz: #303 `give-a-commitment-an-identity`
  first, behind #300; #304 `delete-a-commitment-for-good`, #305 `collapse-a-same-day-rhythm-change`
  and #306 `stop-and-resume-as-eras` each behind #303; #275 and #276 moved behind #303 so the
  total's and the note's look-backs build on eras rather than on the resemblance chain. Left behind
  by id: B-054, B-041, B-032, B-034, B-039.
- 2026-09-21 — delete a commitment for good, with everything it ever recorded (B-057) →
  `FEAT: commitment` (#26), in one cluster with B-058 above, whose identity it needs before
  "everything related" is a thing the app can name. Settled at the same grill: **delete takes
  remove's place** — the trash swipe on either list, the name typed back, the word *delete* — and
  erases the commitment, every era, its roster place and category, and every tick, number, note
  and total against any era, from the phone's stores; the sheet says that the copy in Files follows
  every kept change, so after this nothing is the way back. A roster emptied by deletion stays
  empty: day one is not written back, which costs a marker the roster carries and amends ADR-1027's
  letter. One-offs, which already remove outright, are the precedent. Term **Deleted** in
  `CONTEXT.md`; **Removed** amended to say the state is retired. Story #304
  `delete-a-commitment-for-good`, behind #303.
- 2026-09-21 — read a look-back without seeing where its rhythm changed (B-056) → Story #300
  `say-nothing-where-the-rhythm-changed` under `FEAT: look-back` (#271), ahead of #275 and #276,
  which are now behind it. Captured and groomed in one session, four questions over one round,
  two fact agents. Remove, not hide: the line between eras and the graph's rule leave as REMOVED
  requirements, nine scenarios with them; nothing stands between two eras, the head's newest
  rhythm and earliest kept-from day being the only place a rhythm is said; the reason is clutter.
  The marker had been the designer's recommendation at #272, accepted at that grill and never
  the owner's ask. No new term; `era` and `chain` stay as they are.
- 2026-09-15 — look at one commitment on its own, deliberately and rarely (B-007) →
  `FEAT: look-back` (#271) under `EPIC: Looking back` (#269), a new Epic because #1 excludes
  "graphs and per-area detail pages" by name and is closed. Grilled at the ninth pass in its own
  session, thirteen questions over four rounds, one fact agent, no fact sent to the owner. A page
  per commitment of any kind, not per numeric one; reached from the commitments screen, kept or
  stopped alike; everything since the day kept from, no window; shows and enters nothing. A tick's
  months as kept out of due, "11/12", counted through today or kept-until — the owner's addition to
  the recommended count, held against ADR-1045's "a percentage" and reaffirmed, so ADR-1045 is
  amended; a weekly quota's weeks against its quota, the standing; a number's line; a total's line
  with the target across; a note's words newest first. Term **Look-back** in `CONTEXT.md`. Five
  Stories at G2: #272 `look-back-at-a-tick`, then #273 `-quota`, #274 `-number`, #276 `-note` each
  behind it, and #275 `-total` behind #274. Left behind by id: B-011, B-032.

- 2026-09-15 — see something of a commitment's history on the day screen itself (B-011) → dropped
  at B-007's grill, at the ninth pass. With the look-back page settled, every candidate for the day
  screen — a run, a trend mark, the previous number — is either the streak *nothing congratulates
  you* forbids or the prefill Epic #1 excludes; the weekly quota's standing, shipped in #236, is the
  one glance that survives, and it already exists. The owner had captured this as a decision to be
  made rather than a want, and this is the decision. `EPIC: Looking back` (#269) excludes it by name.
- 2026-09-15 — carry my history to a new phone (B-009) → `FEAT: restore` (#264) under
  `EPIC: Restore` (#263), a new Epic by the owner's decision, on the recommendation: #1's exclusion
  of "export and restore" was a scope statement that still reads true. Grilled at the ninth pass in
  its own session, sixteen questions over four rounds. Restore is a **copy** the app writes — one
  file holding the record, the roster and the one-offs — made by hand and, the owner's call against
  the recommendation, by the app on its own at a **copy place** picked once, on every kept change,
  one file overwritten whole; put back whole from the commitments screen after saying what will go,
  never merged; the broken store is a person's to take out as it stands, and the day screen names
  the way out when a store cannot be read. Apple's own migration was not trusted: nothing Apple
  publishes covers a developer-signed app's container, and a free team gets no iCloud. Terms
  **Copy**, **Copy place**, **Restore** in `CONTEXT.md`, with **Store** and *a day screen without
  its record* amended. Stories #266, #267, #268, #270 at G2. Left behind by id: B-039.

- 2026-09-15 — fill in a commitment on a sheet that fits the phone (B-053), see why something was
  refused, in red, where it went wrong (B-050), and change a number's range or a total's target
  without starting the commitment over (B-043) → `FEAT: commitment` (#26), reopened a third time
  under `EPIC: Daily commitments` (#1) at the ninth pass's G1. Grilled together as cluster A, the
  commitment sheet, in the session that ran the sweep: eight questions over two rounds, one fact
  agent, no fact sent to the owner. Five of B-053's six bullets and B-050's colour are a **shell
  chore** under ADR-1019 that lands first: kind under name, the range on one row, weekday chips
  Monday first, a wheel for the day of the month, a one-row interval, a menu of the categories in
  use with a *New…* item, and red for every refusal. Two Stories follow on the reshaped sheet, both
  owing a walk, accepted at G2 the same day: #261 `place-sheet-refusals`, then #262
  `change-range-and-target`, blocked by it. First, a new commitment starts with all seven weekdays offered — a default is a
  requirement, as the kind's and the day's already are — and a refusal is told under the field it is
  about, at the foot of the form where it is about the whole change; ADR-1019 names a refusal as a
  line the shell may not decide and the one-off entry made "under the field" a requirement of
  `day-screen`. Second, a range or a target can be changed on the sheet and **supersedes** exactly as
  a changed rhythm does, refused on a stopped commitment: B-043's own question is answered supersede,
  because carrying over would refuse a narrowed range and silently un-keep past days under a raised
  target. `CONTEXT.md` **Superseding** amended; no new term.

- 2026-09-14 — be told the true reason a change to a commitment is refused, and keep an every-N-days
  commitment late with its rhythm running on from that day (B-052) → `FEAT: commitment` (#26),
  reopened under `EPIC: Daily commitments` (#1) at the eighth pass's G1. The entry's heading was the
  workaround and not the want: the owner moved the kept-from day to get one four-day gap on a
  three-day rhythm. Three Stories proposed for G2. First, a change that leaves the rhythm alone
  leaves an interval's grid where it was, and a carry-over onto records that already exist is
  refused for that cause. Second, **restarting** an every-N-days commitment from a picked day, on
  the change sheet: a supersede that reads as one commitment on every screen, keeping the
  2026-08-31 fixed-start-date decision. Third, a change saved whole across the record and roster
  places, because a kill between the two writes orphans ticks. The two open questions the entry
  carried are answered: the specified refusal of a later kept-from day stays, and naming the
  blocking day stays B-050's. The owner's phone `record.json` is repaired by hand, outside the
  Stories.

- 2026-09-14 — put a one-off thing on a day and tick it off there (B-049) → `FEAT: one-off` (#239)
  under `EPIC: One-offs` (#238), a new Epic by the owner's decision against the recommendation to
  amend #1. Grilled at the eighth pass in its own session, sixteen questions over four rounds. A
  one-off is a name and a date, not a commitment and not a fifth schedule shape; it stands on one day
  at a time and follows you forward until done (the owner's call against the recommendation); it is
  made, ticked, removed and renamed on the day screen, never re-dated; its store is its own; its rows
  are one headed group, last. Term **One-off** in `CONTEXT.md`, with **Commitment** and **Day view**
  amended. Left behind by id: B-039, B-009.

- 2026-09-14 — know where I stand on a weekly quota, inside its week (B-025) → Story #235
  `add-quota-standing`, reopening `FEAT: record` (#53), and Story #236 `say-standing-in-quota-row`,
  reopening `FEAT: day-screen` (#27), blocked by #235. Grilled at the eighth pass in its own session,
  ten questions over two rounds, and no new Feature: the history answers the count and the row says
  it. The choice the entry's *Principle* line demanded went to the owner, who chose the kept count —
  "1/3x a week", inside the rhythm words, on the day-screen row only — over what the week still asks,
  against the recommendation and told which side of *nothing congratulates you* it sits on. Its first
  *Open* is answered: a **week** is Monday through Sunday for everyone, and an unmet quota leaves
  nothing behind when it turns (`docs/open-questions.md` § *Settled*). Its second too: a met quota's
  row stays, says 3/3 and still offers a tick, and a fourth tick says 4/3. Standing is counted
  through the row's own date. `CONTEXT.md` gained **week** and **standing**; the ADR is owed by #235
  at Stage 4, where ADR-1015 left it.

- 2026-09-14 — **dropped**: meet a quota over a longer span than a week (B-017). Declined at every
  pass from 2026-09-02 to 2026-09-12, each time because nothing on the day-one week asks for a span
  longer than a week, and it failed *five percent of seven things* when it was captured. Dropped
  by the owner at the eighth pass's cluster stop. Re-capture it if a real commitment asks for a
  fortnightly or monthly quota. Its three open questions are where to start: a menu of spans or
  any number of weeks, a calendar month or four weeks, and where a longer span begins. It was
  never decided on its merits, only on nobody asking.

- 2026-09-12 — every schedule rule has a scenario that proves it (B-051) → Story #221
  `cover-schedule-rules`, reopening `FEAT: schedule` (#6), under the umbrella chore #225. First of
  four and the only one unblocked, because it carries the amendment to ADR-1047 that the other
  three inherit: a **covering Story** adds scenarios and the tests for them, changes no behaviour,
  names the seam its tests attach at, and accepts a test that is green the moment it is written.
  ADR-1047 had two lanes and neither fitted — an editorial Story changes no tests, a pruning Story
  says in as many words that no test is added. The list is re-derived at the Story's own grill
  rather than taken from `condense-schedule-spec`'s.

- 2026-09-12 — every record rule has a scenario that proves it (B-045) → Story #222
  `cover-record-rules`, reopening `FEAT: record` (#53), blocked by #221. The entry's own question is
  answered: **one Story each, and no Feature at all.** A Feature anchors on one capability spec and
  these span four, so this repeats the shape #199 used for the eight condensing and pruning
  Stories — an umbrella chore, four Stories, each reopening the Feature that passed G1 long ago.
  Several of its seven rules are absences a WHEN/THEN cannot assert; those stay in the spec and get
  a bullet of their own under `docs/open-questions.md` § *Known gaps*, written by this Story.

- 2026-09-12 — every day-screen rule has a scenario that proves it (B-044) → Story #223
  `cover-day-screen-rules`, reopening `FEAT: day-screen` (#27), blocked by #221. Its other question —
  one Story or one per requirement — is answered one Story: eight rules over eight requirements is
  the second-lightest of the four. Its two untestable-by-construction rules are kept and recorded
  the same way record's absences are.

- 2026-09-12 — every commitment rule has a scenario that proves it (B-046), and a test that cannot
  fail is not a test (B-048) → Story #224 `cover-commitment-rules`, reopening `FEAT: commitment`
  (#26), blocked by #221. Taken as **one Story against the recommendation to split it**: twenty-one
  rules over fourteen requirements, three of them 397, 222 and 220 lines, all carried in full by the
  delta. It is the largest of the four and the one whose list was wrong four times, so the list is
  re-derived from the spec at its grill; a fifth error was found at this pass, that folder's own
  `design.md` saying twenty-two testable while listing twenty-one. B-048's three mutation-blind
  tests ride with it and are **the one place mutation is required** — green on arrival is the rule
  everywhere else, and rewriting a test that cannot fail is worth nothing without proof it now can.
  B-048's own question, whether it merges with B-047, is answered no: the three named tests came
  here and the check stayed there.

- 2026-09-12 — no test outlives the scenario it was written for (B-047) → **a chore**, item 5 of the
  umbrella #225, to land after all four Stories. The reverse coverage check binds CI and its
  allowlist of 117 deliberate orphans is unsettled, while nothing in the four needs it: every
  scenario they add arrives with a matching test, so they never stress the reverse direction. The
  two ambiguous `CommitmentsScreenTests.swift` tests it must classify are also cleaner to judge once
  #224 has re-derived that capability's list.

- 2026-09-12 — act on a commitment with one swipe, and keep the mode for reordering (B-042) →
  **shipped**, `FEAT: commitment` (#26), Story #192 `rework-commitment-row-actions`, merged
  2026-09-10. All four parts landed: swipe actions on both lists, *Edit* renamed to *Reorder*, the
  Category swipe withdrawn along with `CommitmentsScreen.put(_:under:)` behind it, and icons rather
  than words. **The entry was never moved when the Story merged.** Its change folder cites B-042 by
  id four times, so the promotion was real and only the bookkeeping was missed; the seventh pass
  found it still in *Wants* and moved it. B-041, which argues from this row, was already amended on
  2026-09-10 to say the one-tap Category action it rested on is gone.

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
  amends a shipped requirement, *A day screen tells nothing on a row where there was no change to
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

- 2026-09-12 — pass over 19 wants, the seventh.
  - **Sweep** — one silence, confirmed and captured before clustering: **B-051**, the fourth and
    last of the untested-rule lists. `condense-schedule-spec` (#208) left twelve `schedule` rules
    knowingly untested exactly as the other three condensing Stories did, and B-046 predicted the
    fourth list in as many words, but no pass had captured it — so the cluster would have been
    judged on three lists and a straggler. Day-one week: every line has a spec and the shell seeds
    it; the one partly served is still *yuno 5× a week*, which is B-025. Lifecycle verbs: every verb
    on all four capabilities is claimed, shipped, or declined on record; `schedule`'s missing fifth
    shape, a thing due on exactly one date, is B-049. Checked and **not** a gap: a number row and a
    note row draw nothing of the value entered — both grills chose that deliberately, so it is
    decided rather than silent. `docs/open-questions.md` held no want in disguise; its row-identity
    gap is still a Story and still unowned, as the fifth pass said.
  - **Housekeeping** — **B-042 was found still in *Wants* having shipped whole on 2026-09-10** as
    Story #192, cited by id four times in that Story's own change folder. Moved to *Decided* by this
    pass. That is the second bookkeeping miss of its kind and the first where the Story itself named
    the entry, so nothing but the move was missing.
  - **Taken forward** — cluster A, no rule rests on prose alone: B-044, B-045, B-046, B-051, with
    B-047 and B-048. Grilled in three rounds, twelve questions, three facts dispatched and none
    asked of the owner. **No Feature was minted and there was no G1**: a Feature anchors on one
    capability spec and this spans four, so the pass repeated #199's shape — umbrella chore #225,
    four Stories, each reopening the Feature that passed G1 long ago, accepted at G2. Settled: the
    covering Story is a third lane and amends ADR-1047 in place (#221 carries it); tests are
    **accepted green on arrival**, against the recommendation, with B-048's three the single
    exception where mutation is required; rules nothing can prove stay in their specs and each Story
    writes its own bullet under § *Known gaps*, one per capability, so no two branches edit the same
    lines; every list is re-derived at its own grill, because the archived ones were built for
    condensing and commitment's was wrong four times before a fifth error turned up at this pass.
    Order: #221 schedule, then #222 record, #223 day-screen, #224 commitment. `/to-tickets` was not
    used — it reads a Feature issue and there was none, and the grill produced the breakdown it
    exists to produce.
  - **Not taken**, each with the disposition this pass proposed:
    - **B**, the commitments screen: B-050 is a shell chore under ADR-1019 and needs no pass — ask
      for it when it grates. B-043 is a Story reopening `commitment` (#26). B-041 stays until the
      SDK this project builds against carries `reorderable(collectionID:)`.
    - **C**, a one-off on a day: B-049. **The only want in the file that passes *five percent of
      seven things* cleanly**, and the first that the roster cannot express at all. Recommended at
      the cluster stop as the second choice and not taken; it needs a new capability and either a
      second Epic or an amendment to #1's outcome, which is a session of its own.
    - **D**, restore: B-009. **Recommended at the cluster stop for the third pass running and not
      taken.** Still the only want whose absence costs the record rather than comfort.
    - **E**, standing in a quota: B-025, B-017. Blocked on *Week turnover*, which nothing yet forces.
    - **F**, looking back: B-007, B-011. Excluded by Epic #1 by name, so a new Epic.
    - **G**, entry affordances: B-034, and B-032, which Epic #1 also excludes by name.
    - **H**, a reminder: B-039. Unclaimed, and the one want that asks whether this app may nag.

- 2026-09-14 — pass over 13 wants, the eighth.
  - **Sweep** — one silence, confirmed and captured before clustering: **B-052**, the refusal the
    owner hit on the phone that day. It had been recorded in `docs/open-questions.md` § *Known gaps*,
    whose own conclusion was a Story reopening #26, which nothing in that file can ever start, so it
    moved here. Since pass 7 only the four covering Stories (#228, #230, #231, #232) and #219 have
    merged: no behaviour changed, and the tracker holds no open issue. Day-one week: every line has
    a spec, and *yuno 5× a week* is still only partly served, which is B-025. Lifecycle verbs: all
    claimed, shipped or declined. Renaming a category everywhere was declined in
    `add-commitment-category`'s `design.md` Non-goals, so it is not a gap. `docs/open-questions.md`
    held no other want in disguise: row identity is still an unowned Story, and the NaN total is a
    product question.
  - **Dropped** — B-017, at the cluster stop, by the owner.
  - **Taken forward** — **three clusters at once, by the owner's decision, each groomed in its own
    session and worktree**:
    - **A**, commitment changes: B-052 and B-043, grilled in the session that ran this sweep, as
      Stories reopening `FEAT: commitment` (#26). **Outcome:** 10 questions over 3 rounds, with 3
      facts dispatched. The owner said at round 1 that the kept-from move was a workaround: what they
      wanted was an every-N-days commitment kept late, with its rhythm running on from the day it
      was done. That was folded into B-052. **B-043 went back to *Wants*.** Two defects were found
      and confirmed on scratch copies. A **torn save**: records are written before the roster, and
      a kill between the two leaves ticks under a value no entry holds. An **interval's lost grid**:
      any change rebuilds an every-N-days schedule from the kept-from day, so the seeded Nails and
      Lenses refuse even a rename once ticked. Settled: a restart from a picked day, default today,
      on the change sheet, for every N days only. It is a supersede under the hood, with one entry
      and one row on screen. The 2026-08-31 fixed-start-date decision stands. Neither a late row
      nor counting from the last kept day was taken. The owner's phone file gets a distinct refusal
      and is repaired by hand. One term landed in `CONTEXT.md`, **Restarting**. G1 approved
      2026-09-14, reopening #26. Stories proposed for G2, in order: the refusal and grid fix, then
      restart, then the whole save. C's and D's Stories share no capability with these.
    - **D**, standing in a quota: B-025, now alone. Its grill has to settle *Week turnover*
      (`docs/open-questions.md`), which this want is what forces.
    - **C**, a one-off on a day: B-049. It needs a new capability, and either a new Epic or an
      amendment to Epic #1's outcome.

    Each session appends its own dated line recording what its cluster became. **They will meet
    at Stage 4, not before** (`docs/process.md` §7): A deltas `commitment`; D most likely
    `schedule` and `day-screen`; C is undecided and could touch all three. Whichever G2 comes
    second decides what it serialises behind. ADR numbers are claimed against all three open
    branches, not against `main`.
  - **Not taken**, each with the disposition this pass proposed:
    - **B**, restore: B-009. The second choice at the cluster stop, recommended for the fourth pass
      running.
    - **E**, looking back: B-007, B-011. Needs a new Epic.
    - **F**, entry affordances: B-034, B-032. B-001 has shipped, so B-032 is no longer blocked;
      Epic #1 still rules it out by name.
    - **G**, a reminder: B-039.
    - **Singletons**: B-050, a shell chore to ask for when it grates; B-041, waiting for the SDK.

- 2026-09-14 — cluster D of the eighth pass, standing in a quota, groomed in its own session and
  worktree (`chore/groom-quota`) as the line above says it would be.
  - **Sweep** — `origin/main` was still at fd816e1, the commit the eighth pass swept at: nothing had
    changed, and the sweep was one line.
  - **Promoted** — B-025 → Stories #235 `add-quota-standing` (`record`) and #236
    `say-standing-in-quota-row` (`day-screen`, blocked by #235), reopening #53 and #27 and with them
    Epic #1. No new Feature. `/to-tickets` was skipped: the breakdown spans two Features and is two
    sentences, and the owner accepted it at G2 as presented.
  - **Settled at the grill**, ten questions over two rounds: the kept count and not what the week
    still asks, the owner's call against the recommendation; Monday for everyone; nothing recorded at
    week turnover; the day-screen row only; counted as of the row's own date; a met row stays and
    offers a tick; the true count past the quota; the count inside the rhythm words; the term
    *standing*; the history counts and the day view says. *Week turnover* moved to
    `docs/open-questions.md` § *Settled*.
  - **§7 against the other two clusters** — A deltas `commitment`, which neither Story here touches.
    C was undecided when this session closed and may touch `day-screen`; if its G2 lands a day-screen
    Story first, #236 waits behind it and #235 does not.
  - **Not re-judged** — the other ten wants; this session held one cluster by design.

- 2026-09-14 — cluster C of the eighth pass, a one-off on a day, groomed in its own session and
  worktree (`chore/groom-one-off`) as the eighth pass's line says it would be.
  - **Sweep** — `origin/main` was still at fd816e1 when it ran: nothing had changed, and the sweep
    was one line. Cluster D's promotion (#237) landed mid-grill and was re-read at the rebase: B-025
    left *Wants* for #235 and #236, *Week turnover* moved to *Settled*, and neither opened a silence.
  - **Promoted** — B-049 → `FEAT: one-off` (#239), the first Feature under a new Epic,
    `EPIC: One-offs` (#238). New Epic rather than an amended #1 was the owner's decision at the
    grill, against the recommendation: the Epic is titled *Daily commitments* and a one-off is
    defined as not one.
  - **Settled at the grill**, sixteen questions over four rounds, one fact agent, no fact sent to
    the owner: owed *on* its date, not by it; it follows you forward when missed, the owner's call
    against the recommendation; made on the day screen, on any day it can show; called *one-off*;
    a tick only; removed outright when mistaken; stands on exactly one day at a time, so its tick
    records the day it was done; a late row says the date it was owed; a thing of its own in a new
    capability, not a fifth schedule shape — the glossary defines a commitment against it, the
    roster never lets a commitment go, and due-ness is date-only; its own store beside the roster and
    the record; its rows in one group headed *One-offs*, last; a name and a date, no category; a
    rename is in, a re-date is not. Terms: **One-off** landed, **Commitment** and **Day view**
    amended.
  - **Proposed for G2** — the value, the day it stands on and its store first, touching no screen;
    then the day screen draws and ticks the group; then adding and removing from the day screen,
    which meets the row-identity gap in `docs/open-questions.md`; then renaming. One ADR owed at
    Story 1's Stage 4 for *stands on one day at a time*; ADR-1051 was the highest number on every
    branch and worktree, and none was claimed here.
  - **§7 against the other two clusters** — D's G2 landed first: every Story here after the first
    deltas `day-screen`, so it serialises behind #236 `say-standing-in-quota-row`, and Story 1 waits
    on nothing. A deltas `commitment`, which nothing here touches.
  - **Not re-judged** — the other ten wants; this session held one cluster by design.

- 2026-09-15 — pass over 11 wants, the ninth.
  - **Sweep** — one silence, confirmed and captured before clustering: **B-054**, keeping a
    weekday-set commitment on a day it is not due — the weekday-set twin of what B-052 turned out to
    be, with no workaround that does not split a history. Since pass 8 nine Stories merged (#235,
    #236, #242–#244, #247–#249) and `EPIC: One-offs` (#238) closed whole; the tracker holds no open
    issue. Day-one week: every line has a spec, and *yuno 5× a week* is served since #236. Lifecycle
    verbs: `one-off` create, tick, rename and remove shipped, re-date declined at its grill; the other
    four all claimed, shipped or declined on record. `docs/open-questions.md` held no want in
    disguise — #257's record-copy note and row identity are technical, the NaN total a product
    question. Read from `chore/backlog` (PR #259), which held B-053 unmerged.
  - **Housekeeping** — B-050 gains #247's unnamed blocking day as a trigger. B-041 re-read as the
    2026-09-10 amendment asked: leave, not drop.
  - **Taken forward** — **three clusters at once, by the owner's decision, each groomed in its own
    session and worktree**, as the eighth pass did:
    - **A**, the commitment sheet: B-053, B-050, B-043, in the session that ran this sweep
      (`chore/groom-commitment-sheet`). One view, three wants; layout and red refusals look like a
      shell chore under ADR-1019, the all-weekdays default and a range or target change like Stories
      reopening `FEAT: commitment` (#26). The grill decides the shape.
    - **B**, restore: B-009 (`chore/groom-restore`). Recommended at four passes and taken at the
      fifth. Three stores now — record, roster, one-offs — and Epic #1 excludes "export and restore"
      by name, so it amends the Epic or opens one.
    - **D**, looking back: B-007, B-011 (`chore/groom-look-back`). Epic #1 excludes graphs and detail
      pages by name, so a new Epic. B-011 waits on what B-007 is a page *per*.

    Each session appends its own dated line recording what its cluster became. **They meet at
    Stage 4, not before** (`docs/process.md` §7): A deltas `commitment`; B touches the three stores
    and so `record`, `commitment` and `one-off`, or a capability of its own; D is new and may touch
    `day-screen` for B-011. Whichever G2 comes second decides what it serialises behind. ADR numbers
    are claimed against all three open branches, not against `main`.
  - **Not taken**, each with the disposition this pass proposed:
    - **C**, kept on a day it is not due: B-054, captured this pass. Stories against `record` (#53)
      and `day-screen` (#27), or dropped at its grill for "gym is a quota".
    - **E**, entry affordances: B-034, B-032. Epic #1 excludes prefill by name.
    - **F**, a reminder: B-039. Unclaimed, and the one want that asks whether this app may nag.
    - **Singleton**: B-041, leave until the SDK carries `reorderable(collectionID:)`.

- 2026-09-15 — cluster A of the ninth pass, the commitment sheet, groomed in the session that ran
  the sweep, on `chore/groom-commitment-sheet`.
  - **Promoted** — B-053, B-050, B-043 → `FEAT: commitment` (#26), reopened a third time under
    Epic #1. G2 accepted the same day: the shell chore `chore/reshape-commitment-sheet` first, then
    Story #261 `place-sheet-refusals`, then #262 `change-range-and-target`, blocked by #261. The
    weekday default rides #261 rather than a Story of its own. `/to-tickets` was typed and stopped
    after its quiz; the breakdown it produced is the grill's.
  - **Settled at the grill**, eight questions over two rounds: red text under the field, the foot
    of the form for a whole-change refusal; all seven weekdays offered for a new commitment; a
    wheel for the day of the month; a menu with a *New…* item for the category; a changed range or
    target supersedes; the layout is a chore and lands first; the Stories owe the walk.
  - **§7 against the other two clusters** — both Stories delta `commitment`; restore (B) touches
    the three stores and may delta `commitment` for the roster store, so whichever G2 lands second
    serialises behind the first; looking back (D) is a new Epic and shares nothing here.
  - **Not re-judged** — the other wants; this session held one cluster by design.

- 2026-09-15 — cluster B of the ninth pass, restore, groomed in its own session and worktree
  (`chore/groom-restore`) as the ninth pass's line says it would be.
  - **Sweep** — `origin/main` was still at bd85f59, the commit the ninth pass swept at: nothing had
    changed, and the sweep was one line.
  - **Promoted** — B-009 → `FEAT: restore` (#264) under `EPIC: Restore` (#263), a new Epic on the
    recommendation. Capability spec to come at `openspec/specs/restore/spec.md`.
  - **Settled at the grill**, sixteen questions over four rounds, two fact agents, no fact sent to
    the owner: a copy in the app, not Apple's migration and not iCloud; the broken file out as well;
    a new Epic; one file for three stores; replace whole, said first; by hand *and* on the app's own
    (the owner's call against the recommendation); the commitments screen; the words *copy* and
    *restore*; every kept change; a folder picked once; told on the commitments screen only; one file
    overwritten whole, never yesterday; the day screen names the way out; slug `restore`;
    `EPIC: Restore`; nothing on a fresh install. Carried to `spec-author` unverified: whether the
    picker's lasting access to a folder survives a new phone.
  - **Accepted at G2**, from `/to-tickets` stopped after its quiz — four Stories, all `restore`:
    #266 `make-a-copy` first, because the copy's form is the seam every later Story reads; #267
    `restore-from-a-copy` and #268 `copy-on-every-change` after it; #270
    `take-out-an-unreadable-store` after #267. #267 and #268 both open on #266's close and share one
    spec, so the second to reach Stage 4 serialises behind the first (§7), said in #268's body.
  - **§7 against the other two clusters** — A's G2 landed first: #261 and #262 are open under
    `FEAT: commitment` (#26) and both reach the commitments screen, which restore's surface shares, so
    a restore Story touching that screen serialises behind them; `restore` is a capability of its own
    and deltas none of theirs. D's Epic (#269, `EPIC: Looking back`) landed while the Stories here
    were being written; its Stories were not yet on the tracker when this line was written. ADR numbers: 1053 was the
    highest on every branch and worktree, and none was claimed here.
  - **Not re-judged** — the other ten wants; this session held one cluster by design.
- 2026-09-15 — cluster D of the ninth pass, looking back, groomed in its own session and worktree
  (`chore/groom-look-back`) as the line above says it would be.
  - **Sweep** — `origin/main` was still at bd85f59, the commit the ninth pass swept at: nothing had
    changed, and the sweep was one line.
  - **Promoted** — B-007 → `FEAT: look-back` (#271) under `EPIC: Looking back` (#269), a new Epic as
    the seventh, eighth and ninth passes all said: #1 excludes graphs and detail pages by name. Five
    Stories from `/to-tickets 271`, stopped after its quiz: #272 `look-back-at-a-tick` first, then
    #273, #274 and #276 each behind it, #275 behind #274. B-011 dropped at the same grill.
  - **Settled at the grill**, thirteen questions over four rounds, one fact agent: per commitment of
    any kind; from the commitments screen, never the row; stopped ones identical; a narrow Epic;
    kept out of due per month for a tick, the owner's addition to the recommended count; a number's
    line; a total's line with the target across; a note's words newest first; everything since kept
    from, no window; nothing on the day screen; "11/12" reaffirmed against ADR-1045's "a percentage"
    and that ADR amended to say where the line now lies; the slug `look-back`; a quota per week
    against its quota; the month in progress counted through today or kept-until. Term
    **Look-back** landed.
  - **§7 against the other two clusters** — third G2 to land. `look-back` is a new capability; Story
    1's route is expected to be shell work on the commitments view, which already hands out its
    commitments, so nothing serialises behind A's #261 and #262 unless #272's delta reaches
    `commitment`, which is a stop at its G4. B's three stores are not touched. All five Stories delta
    `look-back`, so one at a time and no `archive/` split. ADR-1053 was the highest number on all
    three branches; none was claimed here — the amendment went into ADR-1045.
  - **Two tracker findings from the orchestrator, for a chore** — `docs/agents/issue-tracker.md`
    documents no blocking relationship, while #26's and #271's G2s both use GitHub's native
    dependency endpoints beside the body field; and `feature.yml` has no G2 box for the G2 that
    `docs/process.md` §4 says the orchestrator ticks, so G2 is a comment on #271 as it was on #26.
  - **Not re-judged** — the other nine wants; this session held one cluster by design.
- 2026-09-21 — targeted pass over B-056 (`/atlas backlog B-056`), groomed on `chore/backlog` in
  the session that captured it, `origin/main` at 90fa752.
  - **Sweep** — day-one week: every line has a shipped spec, B-039 and B-054 the only live threads.
    Lifecycle verbs: every create, change and retire shipped or declined on the record, except
    `restore`, which has no way to delete an old copy and no Decided line saying so; put to the
    owner, answered `none` — a copy is a file in Files and deleting it is Files' verb, which the
    known-gaps list already says. `docs/open-questions.md`: nothing that has quietly become a want.
  - **Promoted** — B-056 → #300 `say-nothing-where-the-rhythm-changed` under #271, blocking #275
    and #276; the Decided line above has what the grill settled. Presented at G2 by the conductor
    without `/to-tickets`, one Story under an existing Feature as B-025 was.
  - **Not re-judged** — B-032, B-034, B-039, B-041, B-054; a targeted pass holds one entry.
- 2026-09-21 — pass over 7 wants, the tenth, on `chore/backlog` (PR #301, holding B-057 and B-058
  unmerged), `origin/main` at 1cd589b.
  - **Sweep** — no silence. Main had moved from the same-day targeted pass only by #299 and the B-056
    capture; day-one week every line shipped; lifecycle verbs: the one retire verb the sixth pass
    declined for "nothing asks for it" — deleting a commitment with its history — now has its ask in
    B-057; `docs/open-questions.md` and the specs unchanged since 90fa752.
  - **Taken forward** — **G**, a commitment's identity and its end: B-058, B-057 → `FEAT: commitment`
    (#26) reopened a fourth time under Epic #1; the two Decided lines above hold what the grill
    settled. Recommended because B-058 is the defect the owner hit that day and its answer decides
    B-057's shape. §7: the identity Story's delta reaches `look-back` for the chain, so it serialises
    behind #300 (Stage 4), #275 and #276, all of which delta `look-back`; it also reaches `record`
    and `restore`, which no open Story touches. G2 accepted the same day: #303 `give-a-commitment-
    an-identity` first, blocked by #300; #304 `delete-a-commitment-for-good`, #305
    `collapse-a-same-day-rhythm-change` and #306 `stop-and-resume-as-eras` each blocked by #303; the
    rename and the name refusal fall out of #303. #275 and #276 gained #303 as an upstream, the
    owner's call at this G2. All four delta `commitment`, so one in flight at a time.
  - **Not taken**, each with the disposition this pass proposed:
    - **C**, kept on a day not due: B-054. Unchanged since the ninth pass; Stories against `record`
      and `day-screen`, or "gym is a quota" at its grill. Not this Feature's, though its Stories
      touch `record`.
    - **E**, entry affordances: B-032, B-034. Epic #1 excludes prefill by name and nothing in the
      week is blocked on either; B-032's blocker (#139) has shipped, so it is buildable now.
    - **F**, a reminder: B-039. Unclaimed, and the one want that asks whether this app may nag; it
      needs a sitting of its own.
    - **Singleton**: B-041, leave until the SDK carries `reorderable(collectionID:)`, as 2026-09-15
      decided.
- 2026-09-24 — pass over 6 wants, the eleventh, on `chore/backlog` (PR #320, holding B-059
  unmerged), `origin/main` at 4a8343f.
  - **Sweep** — no silence. Day-one week: every line shipped, B-039 and B-054 the only live
    threads. Lifecycle verbs: `commitment` gained identity, delete, collapse and eras since the
    tenth pass (#308, #313, #317, #319); `one-off` creates, renames and removes; `restore`'s
    delete declined by the owner on 2026-09-21. `docs/open-questions.md`: the one open product
    question (a total's NaN day) is a product decision, not a want, and every known gap is
    technical. `FEAT: commitment` (#26) has every Story closed and is ready to close.
  - **Taken forward** — **H**, birthdays from the calendar: B-059 → `FEAT: birthday` (#322) under
    `EPIC: Birthdays` (#321); the Decided line above holds what the grill settled. Recommended
    because it is the only cluster that makes a new kind of row possible rather than deepening
    one, and because it is the first thing the app reads that is not its own, a boundary worth
    settling once. Proposed for G2: the day's birthdays answered from the phone's birthday
    calendars behind a seam, with the switch's state and the ticks in a store of their own,
    touching no screen; then the day screen draws the *Birthdays* group first and ticks it; then
    the switch on the commitments screen and its refused line; then the copy carries the store.
    §7: `birthday` is a new capability; the day-screen and copy Stories delta `day-screen` and
    `restore`, which no open Story touches — nothing is open on the tracker.
  - **Not taken**, each with the disposition this pass proposed:
    - **E**, entry affordances: B-032, B-034 — `day-screen` Stories, buildable now; Epic #1 excludes
      prefill by name and needs amending at its G1. Handed to a session of its own by the owner,
      to be logged as cluster E of this pass.
    - **C**, kept on a day not due: B-054 — unchanged since the ninth pass.
    - **F**, a reminder: B-039 — unclaimed; H's grill answered its own half of the question (a row,
      not a notification) and left the app-wide one where it was.
    - **Singleton**: B-041, leave — and its "not in the SDK this project builds against" is stale:
      this machine builds with Xcode 27 and the iOS 27 SDK since 2026-09-15 (ADR-1053), so the
      re-read it asks for is due at the next pass.
- 2026-09-24 — cluster E of the eleventh pass, groomed as its own session on
  `chore/groom-entry-affordances` (the eleventh's cluster H, B-059, was open in another session with
  no pass line yet on `chore/backlog` a9315bf), `origin/main` at 4a8343f.
  - **Sweep** — no new silence: every day-one line has a spec; lifecycle verbs as 2026-09-21 left
    them, record retire carried by B-057 and deleting a restore copy answered `none`;
    `docs/open-questions.md` holds no want in disguise.
  - **Taken forward** — **E**, entry affordances: B-034, B-032 → `FEAT: day-screen` (#27) reopened
    under Epic #1, whose exclusion list was amended for prefill. Ten questions over three rounds,
    two fact agents; nine answered as recommended, the range hint against. `CONTEXT.md` gained
    *Short range* and *Starting number* and an amendment to *Number entry*. Challenged at G1 that
    neither weight nor mood is in the day-one week and that both fail *five percent of seven
    things*; approved. First Story recommended: B-034's. Both amend the number entry, so they
    serialise, and both queue behind cluster H if its Stories delta `day-screen`.
  - **Not taken** — B-039, B-041, B-054 with the dispositions of 2026-09-21 unchanged; B-059 is
    cluster H's.
