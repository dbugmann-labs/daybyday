# Grill — cover-commitment-rules

*18 questions over 4 rounds, 2026-09-13.*

Inherited and not re-asked: one Story, not split into roster side and screen side (reaffirmed before
this grill); tests are accepted green on arrival; a test red on arrival is fixed here and only there,
and G7 checks nothing else moved; one scenario per uncovered rule; a rule may be reworded as little as
keeps it true, before and after in `design.md`; a pointer sentence is covered when its target is; rules
nothing can prove stay in the spec and go into this Story's own *Known gaps* bullet. Lane answers from
`cover-schedule-rules` (#221) and ADR-1047 decision 7.

## Settled — the lane, as this Story widens it

1. **The tests that cannot fail are strengthened in place.** They keep their scenario titles; the
   test body is rewritten, and the THEN reworded only where it does not already name what would
   redden. *Titles are contracts, and these rules already have scenarios; they are just not enforced.*
2. **The three from the brief need mutation proof, and nothing else does.** Those are the four
   *keeps nothing at its place* tests, the stop/remove *every earlier date* pair, and *taken up again
   through a commitments screen*. All three survivals were confirmed 2026-09-13. The implementer runs
   each named mutation in a `git archive` tree and records the diff and the red run in the PR. The
   reviewer re-runs them at G7. *A recorded clearance has been wrong before.*
3. **The other weak tests are strengthened with no mutation.** Screen side: stopped rename (kept-until
   day), no-op change (record place), empty roster (no groups), rhythm change (old one held removed,
   not stopped), and default roster place (the one the screen opens with). Roster side: the store
   *saying nothing about removal* fixture moves to the version the app writes, and *a commitment
   changed through a roster store is read back changed* builds its scenario's three-commitment
   roster. That second test is the only proof the store never writes grouped. Same for any test
   whose scenario clause names a read the seam lacks, and for the store's stop on the last supported
   date, which never asserts what `retire` returned. *The added assertion is visible in the diff.*
4. **A src/ seam is allowed, against the recommendation.** It is for a rule no test can observe from
   outside, and in practice for *keeps nothing at its place*. It comes only after a test-only
   observable fails under the known mutation. The re-derivation found one to try first: a place
   holding an earlier form, which an unwanted write would upgrade. The seam must be internal, reached
   from tests through `@testable`, with no public API and no behaviour change. `design.md` says which
   route was taken, and G7 checks the seam is the only other src/ diff.
5. **The false title is corrected, against the recommendation.** It is *a commitment stopped through
   a commitments screen is kept until the day the screen was handed*; the test asserts the day
   before. The other title the brief's source called false was already renamed by #216. OpenSpec
   1.10.0 refuses a scenario rename inside MODIFIED, at validate and at archive (tried 2026-09-13),
   so the requirement goes REMOVED plus ADDED under a minimally reworded heading, every other
   scenario byte-identical. The body is corrected too if it also misstates the rule. Its test is
   renamed, and ADR-1047 decision 5's record updated.
6. **The widening is recorded by amending ADR-1047 in place**, in this Story's PR, written by
   `spec-author` and read at G4. `CONTEXT.md` § *Covering Story* is amended to match (below).
7. **Rules provable only through a UI test are unprovable here** and go into *Known gaps*. *A seam
   spawns no process.* That covers the change form's controls, a row saying only name and rhythm,
   and showing the app calling `shown(asOf:)`.

## Settled — commitment's list

8. **Re-derived 2026-09-13 against the current spec**, the archived list only a hint: roughly **79
   uncovered rules** (38 roster side, 41 screen side), not 22. `spec-author` re-derives it in the
   delta. These findings must come out the same:
   - **Expected red:** a store holding one commitment twice, the first copy stopped or removed, is
     opened instead of refused (`RosterDocument.formRoster` replays through `Roster.add`). Traced,
     not run. Answer 4 of the inherited lane fixes it.
   - **The brief's 22nd rule is half right:** on an unreadable roster, *take up again* has no
     scenario, but *stop keeping* is covered by the scenario refusing a new commitment.
   - **Archived entries now covered:** the kept-from floor not shifting the phase; changing into a
     duplicate; both range ends blank. *A held commitment offered no kind* is compiler-enforced.
9. **Self-change under a different category: the category applies.** It matches the code and L3349.
   L3355's "left exactly as it was" is reworded minimally, and a different-category scenario added.
10. **Three screen rules proven only on the day screen** (a zero-width space, a number with no digit,
    more than one separator) each get a scenario on the commitments screen. *Nothing on the day screen
    fails if this screen stops using the shared reader.*
11. **"No link" between a superseded or changed commitment and its replacement** (L300, L3451) goes
    into *Known gaps*. *A consequence scenario proves some other rule.*
12. **Four universals get one extreme sample each**, read back through the store: a very long name, a
    large roster, a long category, a non-Latin category.
13. **The three low-value rules are covered anyway**: take-up does not lower the earliest day;
    supersede judges no schedule; the store's unsampled refusal kinds.
14. **Two sentences are reworded minimally**, each with its scenario on the new wording. L3288's
    "name and kind and nothing else" names rhythm in words (ADR-1034). L2809's "taken on by the date"
    loses its kept-from reading (L602, L2806).

## Terms landed in CONTEXT.md

- **Covering Story** — amended: in-place strengthening of weak tests, mutation proof where a survival
  was shown, a conditional internal seam, and correcting a title already recorded false.

## Left open

None. Every question the frontier raised was answered. The seam per rule, each scenario's wording,
the reworded sentences and the ADR-1047 amendment's text are `spec-author`'s. The re-derived lists
were not written into this folder: `docs/open-questions.md` records a second conductor file as an
unresolved breach, so answer 8 carries the findings the delta must reproduce instead.
