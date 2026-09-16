# Grill — look-back-at-a-tick

*13 questions over 3 rounds, 2026-09-15 — on top of the 13 the Feature grill of B-007 settled the
same day, which are carried in here because this Story is the first to read them.*

Story #272, under `FEAT: look-back` (#271), `EPIC: Looking back` (#269). Intent: from any
commitment on the commitments screen, kept or stopped, open a page that shows and enters nothing,
and on it list a tick commitment's calendar months newest first as kept days out of due days,
counted through today or the day it was kept until. #273, #274 and #276 are blocked on it because
it establishes the page; every Story of this Feature deltas `look-back`, so they run one at a time.

## Settled

**From the Feature grill of B-007 (13 questions, 4 rounds, same day).** Durable in `CONTEXT.md`
§ *Look-back*, `docs/backlog.md` § *Decided* (B-007, B-011) and the 2026-09-15 amendment of
ADR-1045: a page per commitment of any kind; reached from the commitments screen, never the day
screen's row; stopped ones identical; everything since kept from, no window; shows and enters
nothing; a tick's months as kept out of due, "11/12", counted through today or kept-until, so a
month in progress owes nothing yet; newest first; never a percentage and nothing of it on the day
screen; a weekly quota's weeks against its quota are #273's.

**From this grill.**

1. **Every entry opens the page, whatever the kind.** A quota, number, note or total commitment's
   page opens in this Story and lists nothing yet; the four later Stories fill it. *The route and
   the page are what those Stories wait on; an entry that opens for some kinds and not others is a
   rule nobody asked for.*
2. **A calendar month with no due day is listed**, so the list runs unbroken from kept-from to the
   last counted day — an every-40-days rhythm can leave one. *The list is calendar time read
   downward; a skipped month looks like a defect.*
3. **The head says the name, the rhythm in words and the dates**: the day kept from, and kept
   until where the commitment is stopped. *The page is the one place dates are worth reading, and
   it enters nothing, so nothing competes for the top.* With eras (6), the rhythm is the newest
   era's and kept-from is the earliest era's.
4. **A whole line beside the months** — one fraction across everything since kept-from, "120/140".
   **The owner's call, against the recommendation, asked twice** (Q4, then Q7 with ADR-1045's
   amendment quoted: "per month or per week") and reaffirmed. Decided; not to be re-argued in the
   delta. `spec-author` amends ADR-1045 to say where the whole stands and why. It is counted by the
   same rule as a month — through today or kept-until — and is never a percentage.
5. **The door is the entry's tap, restored**, on the kept list and the stopped list alike; Edit
   stays on the leading swipe, Stop, Remove and Resume on the trailing one. *The tap was taken away
   at `rework-commitment-row-actions` (2026-09-10) because it opened Edit, which mutates; a tap
   that only looks is what a tap on a list entry under a navigation stack means.* This reverses
   that grill's "the swipe is the only door" for looking, not for acting.
6. **The page chains a commitment's eras** — the spans cut by a rhythm change or an interval
   restart, each of which supersedes: the old commitment held removed with a kept-until, the new
   one kept from the next day. **The owner's call, against the recommendation** to accept the era
   boundary here and capture chaining as a want. Decided.
7. **The chain is inferred, not recorded.** Behind a commitment stands the removed commitment of
   the same name and the same kind whose kept-until is the day before this one's kept-from; and
   behind that one, the same again. *A superseded commitment is held on disk exactly as one the
   person removed — no link, no identifier, adjacency guaranteed only at the moment of the act
   (`openspec/specs/commitment/spec.md` § "A roster supersedes…") — and the specs already carry
   one resemblance test, the orphan carry-back. A recorded link is a `commitment` delta, a fifth
   roster form with a migration, and serialising with #261 and #262.* Two edges accepted with the
   decision: a commitment removed and defined again the same day under the same name and kind
   reads as one chain; a later correction of a kept-from day breaks a chain. Stays in `look-back`.
8. **A line where the rhythm changed**, in words, sits between the months at the day the newer era
   is kept from. *A reader who sees the due counts shift with no word for it sees a defect.*
9. **A quota era's months are listed saying nothing yet** — no fraction — as a whole quota page
   lists nothing (1). *A quota is due every day; "11/30" is the wrong answer and #273 has the right
   one.*
10. **The whole says nothing yet where any era of the chain is a quota.** *Same reason as 9.*
11. **The walk — five pictures, no `phone:` line.** The commitments screen with an entry as the
    door; a kept tick's page with several months and the month in progress; a stopped tick's page
    with kept-until in the head; a non-tick commitment's page listing nothing; a page whose list
    crosses a rhythm change. Every step is a tap or a push a simulator drives.

**Consequences the facts settle, not asked because no preference is involved.**

- Due on a day is `Commitment.isDue(on:)` of the era that holds the day — the schedule and the
  kept-from floor, kind never entering. Kept is `History.isKept(_:on:)`. Kept is never more than
  due: a tick refuses a day the commitment is not due on, a kept-from moved later is refused where
  it would leave a recorded day not due, and a rhythm change moves no record. So no fraction
  exceeds its whole.
- Counting runs through today for a kept commitment and through kept-until, inclusive, for a
  stopped one; a tick made on the day of stopping stands after kept-until and is not counted. A
  commitment kept from a day after today has no month and a whole of nothing due — how that
  reads is `design.md`'s. A commitment taken up again holds no kept-until, and the days between
  read as kept once more with no record on them: those months show what `CONTEXT.md` § *Kept
  until* already calls the price. The page reflects it and invents nothing.
- Today is the one the commitments screen is already handed (`CommitmentsScreen(asOf:)`), never
  a clock read in the kit (ADR-1004).
- A removed commitment is on neither list and has no page; a chain is reached from its newest
  era only. A superseded era taken up again in place is kept, not removed, so the chain stops
  there. A restart supersedes "alike in name, interval and kind", so it chains as a rhythm change
  does, and its line (8) says the new start.
- A day-of-month rhythm in a short month is due on the last day (ADR-1051); an every-N-days
  rhythm's start date and the kept-from floor both apply. No pause, skip or holiday exists in
  the model; one-offs are outside the roster and the record and never enter.
- The month is said in the app's own words, locale-independent, as the day title says its month
  and year (ADR-1022); no month name exists in the kit today. The words are `design.md`'s.
- `CalendarDate.daysInMonth`, `adding(days:)` and `days(until:)` are internal today; whether the
  seam is a new value in `look-back`'s own module or a public member somewhere is `design.md`'s.
  Reading a roster's removed commitments and their kept-until days for (7) must not become a
  `commitment` requirement: the ninth pass said a `commitment` delta on this Story is a stop at
  G4, because #261 and #262 are in flight on that capability.
- ADR-1047's budgets apply; a change altering a persisted type owes `### Migration`, and this
  Story alters none.

**ADR.** Decision 7 is hard to reverse (a recorded link later means a roster form the chain
would have to be re-read from), surprising without context (why resemblance and not a link) and a
real trade-off; write one ADR for it, under `docs/adr/README.md`'s numbering rule — check
`git log --all` for the next number before taking it. Decision 4 is an amendment to ADR-1045,
not a new ADR.

## Terms landed in CONTEXT.md

**The conductor named these; `spec-author` lands them**, as `add-note-record`'s grill settled.

- **Era** — new. One commitment's span of being kept from one rhythm: from its kept-from through
  its kept-until, or through today while it is kept. A rhythm change or an interval restart ends
  one era and begins the next by supersession, and the roster holds no link between them; a
  look-back reads them as one chain by resemblance — same name, same kind, kept-until the day
  before the next kept-from.
- **Look-back** — amended. Reached by the entry's tap; lists every calendar month unbroken, a
  line in words where the rhythm changed, and one whole line across everything since kept-from,
  the owner's call held against ADR-1045 and reaffirmed; a page of any other kind, and a quota
  era's months, list nothing yet until their Stories.
- **Commitments screen** — amended. An entry's tap opens that commitment's look-back, kept or
  stopped; the swipes stay the doors for acting.

## Left open

None. Every question the frontier raised was answered, the two edges of inferring a chain were
accepted with the decision that chose it, and every other edge the facts turned up is a
consequence of a decision already made rather than a preference. What is #273's — a quota's
weeks — is named under 1, 9 and 10 so it is not silently decided here.
