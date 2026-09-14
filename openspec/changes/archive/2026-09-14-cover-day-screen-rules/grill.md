# Grill — cover-day-screen-rules

*10 questions over 3 rounds, 2026-09-13.*

Inherited from the seventh grooming pass and from #221's grill, and not re-asked: tests are
accepted green on arrival, and a red one gets the bounded `src/` fix ADR-1047 decision 7 allows;
rules nothing can prove stay in the spec and are recorded; this Story writes its own bullet under
`docs/open-questions.md` § *Known gaps*; one scenario per rule; a rule is *covered* when some
scenario would fail were it broken; a pointer sentence is covered when its target is; a covered
rule may be reworded only as little as keeps it true, with before and after in `design.md`.
ADR-1047 is already amended (#221) and this Story does not touch it.

## Settled — scope

1. **Scope is every testable uncovered rule in `day-screen`, in one Story.** The G2 phrase
   "eight rules over eight requirements" does not hold: the re-derivation found three of the eight
   still uncovered and about 27 further testable finds. *The intent already says "every"; splitting
   would reopen G2 and serialise two Stories on one spec.*
2. **A rule that lists several cases gets one scenario exercising every case the existing
   scenarios leave unproven**, so breaking any single case fails it. *Keeps one rule to one
   scenario, as #221 did for "not due before start".*
3. **The list below is a starting point, not a pin.** `spec-author` re-verifies each entry against
   the definition of *covered*; `design.md` names the existing scenario for any dropped as already
   covered, and the category for any reclassified as unprovable. *Coverage is fact, and the sweep
   ran at mixed confidence.*
4. **`design.md` compresses before it overruns**: one table line per covered rule naming the wrong
   implementation its scenario catches; unprovable rules listed only in the *Known gaps* bullet,
   which `design.md` points to. Any remaining overrun is stated with its size and reason; the Story
   stays one.
5. **Carried requirements are carried as shipped** — no condensing of any already over the prose
   budget; `design.md` names those that were over before this Story. *Condensing is an editorial
   Story's, and mixing it defeats the byte-check on carried blocks.*

## Settled — the handoff's eight and the two it missed

6. **Still uncovered, each gets a scenario:** C5 (a take-back reaches the place on a day holding no
   number — and its note twin, 3766–3767, whose target this is); C7 (neighbour day views at either
   end whatever roster, record, rows and today — **one rule, one scenario** at an end varying all
   four); C8b (the reach not narrowed to commitments *due on some day*; the "still kept" and
   "rows for" halves are covered by 2178/2187).
7. **Already covered, no scenario:** C6 (the day-screen tests at `DayScreenTests.swift:735` and ~10
   others equate `screen.dayView` with a directly formed `DayView`); C8a, reach bounds the picker
   and never the screen (251, 2196, 2206, 2422 fail under a bounded move).
8. **Unprovable, to *Known gaps*:** B8 (way-back answer about the control, not the position) and
   B18 (a caller must not stand a move down; a screen says nothing about whether it can move) —
   *bind a meaning or a caller*; C4 (closing an entry uncommitted ends nothing) — *no seam*, the
   screen is never called, a UI test declined; C2, C8c, C8d, and the "handed one thing" / "handed
   nothing" signatures — *compiler*; the "this package's own English and no locale's" phrases —
   *no seam*; C1 (a non-total row's sum is zero) — *no seam*, `Row.total` is internal and no
   public member reads it.
9. **C3 (two rows that are the same row are both told of) is unreachable** through `DayScreen`:
   the roster refuses a duplicate on every path, including file replay and day one. Recorded in the
   same bullet as unreachable at the seam; not reworded, not flagged separately.

## Settled — the starting list for `spec-author`

10. **Sweep finds, testable at a seam** (spec line numbers as of `6078297`; re-verify per 3):
    moving a screen whose roster is not kept still says so (211); a kept change survives a move,
    return to today or pick (208–210); going back to today reads neither store again and leaves
    `rosterState` alone (291–293); today's day view is formed from the roster's answer on that
    today, with a stopped commitment (290–291, 547–548); an unreadable record is not held in memory
    to be kept later (474); every way a record store refuses to open is answered one way (476); a
    removed commitment under a category is drawn as a stopped one (551–552); an unreadable roster
    takes nothing on and leaves the place (648–649, 762); roster later-version vs unreadable, and no
    other reason told (763–765); no number entry for a future date whatever the day holds (827–828);
    spaces-only entry is a take-back (978); significant digits counted from the first to the last
    non-zero (982–983); a number too large is not fitted (983–984); spaces among the digits refused
    (986); a total row's take-back does not widen `offersAnything` (1717); every change on a
    neighbour day's row — note, addition, number/note/tick take-back, refused value — changes
    nothing, tells nothing and leaves what is told (1948–1955); two total rows differing only in sum
    are different rows (2005–2006); the reach not narrowed to due (2157–2158); reading neighbours
    keeps nothing at either place (2344–2345); a tick taken back is kept at the place (2803); a tick
    does not change `rosterState` (2807–2808); states formed again when shown, reason included
    (2887–2889); a commit on a row not held does not end what is told (3378); an unreadable screen
    tells nothing whatever was committed, a refused value included (3379–3381); `returnedTo` on an
    unreadable roster says so and draws no rows (3498–3499); a later-version record place is left
    as it was after a tick (475); the reach read again on `shown(asOf:)` (2241).
    *A check of the sweep's claim that 18 scenarios had no test found it false — all 373 titles
    match a test — so finds at 648, 763, 827, 978, 2005, 2803, 2887, 3378 and 475 that leaned on it
    are the likeliest to re-verify as covered.*
11. **Sweep finds, unprovable** (same bullet, same groups): time zone, clock and locale clauses
    (21, 397–398, 834, 915, 973, 1108, 2461); consumer or platform meaning (443–446, 727, 730–731,
    1387–1388, 1390–1391, 1720–1721, 1915–1916, 4126–4127); compiler (348; the no-day signatures at
    22, 296, 2240, 2268, 2797–2798, 3589, 3762, 4034; 1538; 1717–1718; 2101–2109; 2580–2581; the
    internal fields at 917–918, 1341, 3722, 3725); meaning, same answer (916, 1336, 2157, 3723,
    975–976, 1181–1182, 2884); no seam (474–475 "anywhere else", 547–548 "when a tick is made", 642,
    1540, 2804, 3597, 3898–3899, 2010–2011, 2462–2464, 3184); universal over inputs (1454, 3041).
    `spec-author` may move any of these to testable if a seam turns out to reach it.

## Terms landed in CONTEXT.md

None. Every answer applied a term the *Covering Story* entry already defines; *unreachable at the
seam* is recorded as a grouping inside the bullet, not as a term.

## Left open

None. Every question the frontier raised was answered, all ten as recommended. The seam, each
scenario's wording and any minimal rewording are `spec-author`'s. One finding outside this Story is
deliberately not taken up here: CI check 4 matches only a change's delta scenarios to tests and
never checks `openspec/specs/**`, so a shipped scenario losing its test would go unnoticed. It
belongs in `docs/open-questions.md` or the backlog, not in this delta.
