# Grill — shorten-day-title

*13 questions over 5 rounds, 2026-09-09. Story #182.*

The Story arrived asking for a shorter day title — "Today · Wed 9 Sept 2026" in place of
"Today · Wednesday 9 September 2026". It leaves asking for something larger: the day title
becomes a weekday and nothing else, and the date is drawn by the day picker that already sits
in that row.

## Settled

1. **Shortening the words, not fixing the layout.** The want came from a wrap recorded at
   `add-day-picker`'s close (`openspec/changes/archive/2026-09-09-add-day-picker/tasks.md:172`,
   handed to this Story by name at `:239`) — a fourth control joined the title's `HStack` and the
   title no longer fit one line. *A shell-only fix was put as the cheaper alternative and
   declined: its options are an ellipsis or shrunk text, both of which make the row worse rather
   than shorter.*

2. **The day title becomes the weekday and nothing else** — "Wed". No day of the month, no month,
   no year, no *Today*. *The date is said by the day picker instead, which the owner asked for
   after seeing it already renders "9 Sep 2026" in that same row.*

3. **The weekday is three letters** — Mon, Tue, Wed, Thu, Fri, Sat, Sun. *One abbreviation rule
   across the app: `schedule` already produces "Mon, Wed, Sat" from `ScheduleWords.swift:10-31`,
   and "Wednesday" standing alone was the alternative considered.*

4. **The word *Today* is dropped from the title entirely.** *The Today button is drawn only where
   the screen offers the way back — `ContentView.swift:162` guards it on `offersGoingBackToToday`,
   hiding rather than disabling it — so the row already distinguishes the two states without a
   word inside the date. This retires a preference #92's grill settled on 2026-09-03.*

5. **The day picker moves between the chevrons and becomes what says the date.** *Shell only;
   the picker's reach requirement is untouched, and the spec already says what is drawn for the
   picker is the caller's.*

6. **The device's locale therefore decides the date's words, and that is accepted.** *Put
   explicitly as ADR-1022's premise — "a day title that changed with the phone would be a
   sentence no scenario could state" — and taken with the cost named: after this, nothing the app
   owns can state which date is showing, so no scenario, test or screenshot asserts it. The
   weekday stays the app's own English; the date does not. A compact `DatePicker` cannot be made
   to say the weekday itself — `DatePickerComponents` offers only `date` and `hourAndMinute` on
   iOS, no initializer takes a format, `DatePickerStyleConfiguration` exposes no text hook, and
   `UIDatePicker.h:18-19` documents the date-only mode as month/day/year — which is why something
   in the kit still has to say it.*

7. **Nothing keeps a full-date form.** *The full-date answer is deleted rather than retained as a
   VoiceOver label or drawn nowhere; the picker announces its own date, so accessibility is
   served by the control that shows it.*

8. **The term *day title* survives.** *What it holds changed; the role — what a day view says its
   day is, and so what a day screen says the day it is showing is — did not, and the term runs
   through ADR-1022, ADR-1034, ADR-1036 and roughly fourteen archived change folders that cannot
   be edited.*

9. **The change id stays `shorten-day-title`.** *Understated rather than wrong: the title is
   shortened, to one word. Renaming would cost the issue, the branch, the worktree and the graph
   before any spec exists.*

10. **Two round-one answers were superseded and are recorded as such.** The month list
    (Jan–Aug, **Sept**, Oct–Dec) and *keep the year always* were both answered before the picker
    was known to be taking the date, and the title now carries neither a month nor a year. *A
    finding about this grill: the form of the date was asked a round before the question of who
    says the date at all. Neither answer reaches the delta.*

## Consequences for `spec-author`, not decisions

- The day title no longer depends on the day it is asked as of, so the `asOf` argument on the
  day view's title and the day screen's pass-through has no remaining reader. Whether the
  signature loses it is a design call, not one the grill took.
- `day-screen/spec.md` quotes a day title 64 times, across requirements about ticking, notices,
  entries and the roster as well as the two that define it; `DayViewTests.swift` and
  `DayScreenTests.swift` hold 79 literal assertions between them. Every one moves. The delta is
  large and wholly mechanical.
- ADR-1022 holds the decision that changes here, so it is **amended in place** — `docs/adr/README.md`'s
  rule — rather than superseded by a new ADR.

## Terms landed in CONTEXT.md

No new term was coined; three existing entries are made wrong by this change and must be amended
with the delta. Naming them here rather than editing them, because they are the delta's wording
and `spec-author` writes that:

- **Day title** (`CONTEXT.md:1029`) — currently "the day said as a weekday, a day of the month, a
  month and a year — 'Monday 31 August 2026' — with *Today* said in front of it". Becomes the
  weekday alone.
- **Today** (`CONTEXT.md:708`) — cites "whether the day title says *Today*" as an example of a
  question asked *as of* a day. No longer true of the title.
- **Day picker** (`CONTEXT.md:754-763`) — says the picker sits beside the chevrons and the Today
  button "and never the **day title**". It now sits where the day title's date was.

## Left open

- **The picker becomes a tap target in the middle of a row #184 will make draggable.**
  `add-adjacent-day-views` (#184) is blocked on this Story and pages the day under the finger;
  a compact `DatePicker` between the chevrons is a gesture conflict waiting for it. Left open
  deliberately: it is #184's to settle, and nothing here constrains how.
- **Whether the row still lays out well once the picker is its centre** is a shell observation
  under ADR-1019, confirmed in the simulator at implementation rather than decided here. If the
  short title still shares that row badly, that is a further chore and not a respec.
