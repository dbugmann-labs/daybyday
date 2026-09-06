# Grill — add-commitments-screen

*12 questions over 4 rounds, 2026-09-04. Story #104, the last of `FEAT: commitment` (#26)'s four.*

Three of the twelve were parked here by name before this grill ran: `add-roster-retirement`'s
design left "whether stopping confirms first and how something stopped is taken up again" to #104,
and `add-roster-store`'s left the stale-roster bug it predicted would "land in #104 as a mystery".
Those are questions 4, 3 and 9 below.

## Settled

1. **A row says the commitment's name and nothing else**, in the order the roster took it on.
   *Asked twice. The first time I said the screen could not say more, which was wrong — this
   screen lives behind the seam in `DayByDayKit`, where `Commitment.schedule` and
   `CalendarDate`'s components are readable and `DayView.title` already renders a date from
   exactly there. Re-asked on the corrected facts and the answer held: saying a rhythm in words
   is a requirement about how a schedule is **said**, which belongs to
   `openspec/specs/schedule/spec.md` whoever reads it, and G1 put B-021 out of this Feature.
   A kit-side screen inventing its own wording would be that requirement written in the wrong
   capability.*

2. **Two commitments alike in name but not in rhythm read identically, and that is accepted.**
   *The roster refuses only an exact duplicate, so "Gym" on Mon/Wed and "Gym" on Tue/Thu are two
   legal rows a person cannot tell apart. The rows are stable — the roster's order is the order
   they were taken on — and the alternative was a screen refusing a name the engine allows, which
   would forbid "Vitamins" on two rhythms.*

3. **The form offers all four rhythms** — a weekday set, a day of the month, every N days, and a
   weekly quota. *Five percent of seven things: a thin version of every rhythm beats a deep
   version of one, and the day-one week already contains an every-N-days commitment the app would
   otherwise list and be unable to create.*

4. **The form refuses a weekday set with no days in it**, which the engine accepts and
   `ScheduleTests` pins as due on nothing. *A commitment due on no day is one you never see
   again. The engine's permissiveness is a rule about what a schedule value may be, not about
   what a screen should offer to make — and this is the first place in the product where a
   screen refuses something the engine allows.*

5. **The form asks for the day the commitment is kept from, defaulting to the screen's today, and
   accepts any date the calendar supports** — the future included. *Decided against the
   recommendation, which was to take today with no field on the grounds that question 6 had
   already made the take-up path cheap. The owner wants to be able to say they have kept
   something since June. No bound of the screen's own: "I start the gym on Monday" is a real
   thing to want, and refusing the future would make the screen consult what day it is in order
   to judge an input.*

6. **For an every-N-days rhythm, the day it is kept from is also the schedule's start date.**
   *One date picker rather than two. `CONTEXT.md` § *Start date* keeps them distinct in the model
   and says they can disagree, and that distinction stays available to day one's hard-coded list
   and to a later Story — but two date fields on one phone form, differing in a way nobody
   intended, buys less than it costs. The rhythm lands on the day you started keeping it and
   every N days after.*

7. **The screen shows what you have stopped keeping, separately from what you keep, and offers to
   keep it again in one tap.** *G1's answer that stopped commitments are "hidden" holds for the
   list of what you keep; this is a second list beside it. Without it the roster's take-up-again
   rule is unreachable from the phone — you would have to retype the name, rebuild the rhythm and
   match the kept-from day exactly — and `add-roster-store`'s design named "a person who stops all
   eight commitments sees an empty day for ever, with no way back" as a risk belonging here. It
   is closed by this answer.*

8. **Stopping asks you to confirm first.** *Decided against the recommendation, which was that
   question 7 had made a mis-tap cost one tap to undo. Taken as the owner's preference: a stop
   writes to the roster and a confirmation before it is what they want.*

9. **A commitment is kept until the screen's today when you stop it.** *Inherited rather than
   asked: `add-roster-retirement`'s design already settled that "no screen in this Feature offers
   to pick a date anyway", and this screen holds a today and no other day.*

10. **A duplicate and a store that cannot be written are told apart, in different words.** *The
    day screen collapses its refusals into one message on the grounds that "a tick refused on a
    record that could be read has no cause a person can act on differently" (ADR-1021). That
    reasoning does not carry here: a commitment you already keep is your own doing and you can
    change the name or the rhythm, while a disk that will not write leaves you nothing to do.
    Breaking the one-message pattern is deliberate and the reason is the reason the pattern
    exists.*

11. **This Story deltas `day-screen` as well as `commitment`, so a roster changed here is seen
    without the app being backgrounded.** *`DayScreen.shown(asOf:)` re-reads both stores and the
    shell calls it only from `scenePhase == .active`; moving between two screens in one session
    does not fire that, so a commitment defined here would not reach the day screen until the app
    was backgrounded and brought back. `add-roster-store`'s design predicted this in as many
    words. Two capabilities in one change is a known shape — `add-screen-date` (#92) did it.*

12. **The shell wiring that reaches the screen rides this Story's branch.** *Decided against the
    recommendation, which was a `chore/` branch after the archive. ADR-1019 makes the app shell a
    chore with no G4 precisely so that a no-requirement change does not sit inside a signed change
    folder, and this deviates from it knowingly: the owner wants the Story usable at G7 rather
    than after a second branch. `spec-author` owes ADR-1019 an amendment recording the exception
    and what triggers a return to the rule.*

## Terms landed in CONTEXT.md

- **Commitments screen** — the list of what a person keeps, the form that defines a new one, and
  the way to stop keeping one; and, beside the first list, what they have stopped.

## Left open

Two, both `spec-author`'s to settle in `design.md` rather than the human's — neither is a
preference and both are answered by reasoning about the delta, which is where the conductor's
line falls:

- **Whether the commitments screen shares one `RosterStore` with the day screen or opens its own
  at the same place**, and therefore what the seam is: a new type beside `DayScreen`, or
  `DayScreen` widened. `RosterStore` is a class holding its roster in memory, and `CONTEXT.md`
  § *Store* already says two handles on one place are two views of one file, so both work; which
  one settled answer 11 needs is a design question.
- **The mechanism by which the day screen re-reads on being returned to.** Answer 11 fixes the
  behaviour and not the shape. `shown(asOf:)` exists and does exactly this work; whether it is
  reused, renamed or joined by a sibling is `design.md`'s.

Two ADRs are owed and named here so they are not missed: the amendment to ADR-1019 that answer 12
requires, and a new one for answer 4 — the first time a screen in this product refuses something
the engine accepts.

Nothing else is open. Every question the frontier raised over four rounds was answered, and the
frontier was empty at the close.
