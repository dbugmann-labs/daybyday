## Context

`proposal.md` § *Why* says what this is for; `grill.md`'s settled answers are the brief.
`openspec/specs/commitment/spec.md` holds 43 requirements and 398 scenarios. The delta carries 25
of them whole — 24 MODIFIED, one REMOVED and ADDED — with 40 new scenarios and eight reworded ones.

Four facts in source decide the approach. `RosterStore.write` is byte-stable, so rewriting an
unchanged roster is byte-identical and the four *keeps nothing at its place* tests cannot see it.
`RosterDocument.formRoster` replays entries through `Roster.add`, which takes a second copy up again
rather than refusing it. `CommitmentsScreen.change` writes the record place before the roster place
and restores nothing when the roster write fails. `CommitmentsScreen.place` is private and defaults
to the real application-support directory, which no test may write to.

## Goals / Non-Goals

**Goals:** every uncovered rule has exactly one scenario that would fail were it broken; every test
grill answers 2–3 name can fail; the false title is corrected; the unprovable rules are recorded;
the lane is stated in ADR-1047.

**Non-Goals:** no rule dropped or added, no scenario dropped, no other capability, no public API.
No `src/` change except a red arrival's fix and a test-only internal seam.

## Decisions

### The seam

No public member is new or changed; tests drive the shipped `Roster`, `RosterStore`, `Commitment` and
`CommitmentsScreen` members. Two internal members may be widened for tests: the first only if route 2
below is taken, the second only on question 2's recommended answer.

```swift
var writeCount: Int { get }
let place: URL
```

### One scenario per uncovered rule, counted by statement

Forty scenarios: 21 on the roster side, 19 on the screen. Each one's `tasks.md` clause names the
wrong implementation it catches. A rule stated over several verbs, states or branches counts once.
Where shipped scenarios sample some of its members, one new scenario takes the rest as ANDs, as
grill answer 13 settled for the store's refusals. Every finding in grill answer 8 comes out the same.
Rejected: one scenario per unsampled member, which would add many tests of the same statement.

### Two reds expected on arrival, each fixed here

- *a roster store holding a commitment again after holding it stopped or removed is refused*.
  Fix: `formRoster` refuses an entry whose commitment the roster already holds, in any state.
- *a change refused at the roster place after its records were carried over leaves the record place
  as it was*. Fix, on question 1's recommended answer: when the roster write fails, `change` carries
  the records back.

### Strengthened in place, and the three proven by mutation

Grill answers 1–3. Titles stay; bodies are rewritten. A THEN changes only where it did not name what
would fail, and each such change is in the diff. Mutations run in a `git archive` tree, and the PR
body holds the diff and the red run:

- **The four no-op tests** (move, category change, group move, change for itself). The mutant is all
  four `if nextRoster != roster` guards removed, as `drop-duplicate-commitment-scenarios` item 12
  records. Route 1: the test seeds the place with the same roster in bytes the store never writes —
  an earlier form for the move, and the current form laid out differently for the other three.
  Route 2, only if a route-1 test survives: `writeCount`. The PR body says which route was taken.
- **The stop and remove *every earlier date* pair.** The mutant is `retire` or `remove` made a no-op
  that still answers `true`. Each THEN gains an AND: nothing on 1 February 2026.
- **The take-up-again test.** The mutant it survives is not recorded in this repository. The
  implementer names one before rewriting the test. Finding none is a stop.

### Rewordings, before and after

Each is the smallest change that keeps the rule true, with its scenario on the new wording:

- *A roster changes a commitment…*: "left exactly as it was and SHALL report" → "left exactly as it
  was but for the category it was offered under, and SHALL report" (grill answer 9).
- *A roster answers the earliest day…*: "the name it was given and the kind its days take and nothing
  else" → "the name it was given, the kind its days take and the rhythm it runs on in words, and
  nothing else" (grill answer 14, ADR-1034).
- *A roster reads … in groups*: "one none of whose commitments had been taken on by the date asked
  about" → "one that had stopped keeping or removed every commitment it holds before the date asked
  about" (grill answer 14).
- *…asks you to confirm…* → *…asks for confirmation…*. The title's "kept until the day the screen was
  handed" becomes "kept until the day before the one the screen was handed"; the body was already
  true (grill answer 5).
- Scenario text, grill answer 3: the no-op change gains a record place, and six THENs each gain one
  AND. Those are the stopped rename (the kept-until day), the rhythm change (nothing stopped), the
  empty screen (no groups), the store stop on the last date (its report) and the pair above.

Twenty carried requirements are pre-budget prose over 150 words, kept whole under ADR-1047 decision 2;
the three reworded here were already over and grow by eight words at most.

### The false title moves by REMOVED plus ADDED

OpenSpec 1.10.0 refuses a scenario rename inside MODIFIED, so the requirement lands last at archive.
Nothing cites its heading; only its test and ADR-1047 decision 5 quote the title.

### Pointer sentences skipped

These defer to another requirement and are covered when it is: the kind "compared as *A roster
refuses…* says"; "as the refusals *A roster refuses…* states"; "as *A roster refuses…* says" (twice);
"as the roster requirements state them"; "by the rule that already governs a commitment neither
list holds"; "as *A commitments screen defines…* says".

### The unprovable rules, for the *Known gaps* entry

- No seam accepts them: the present moment, time zone, locale and clock in every requirement; the
  order of the record write and the roster write; a category kept as a reference to a list; a roster
  store "SHALL NOT be what reaches" a record place.
- The compiler enforces them: a commitment's four parts and nothing else, its kind fixed, no unit on
  a target, both range ends required; a roster's lack of identifier, position and added day; a move's
  two things, no third ask and no second way back; the screen's five fields, a change's four and no
  kind; no interval start date; range and target text taken unjudged; no date to pick; no words a
  person reads; take-up asking nothing.
- They bind a meaning or a consumer: inclusive range ends; one refusal where a range is formed;
  delegation to shapes added later; ticks and records standing, nothing carried by a roster; no link
  to a replacement (grill answer 11); nothing stored for a group; no second category collection;
  `schedule` and the value rules unchanged; the seven refusals numbered nowhere else.
- Only a UI test proves them (grill answer 7): the change form's controls, a row saying only name and
  rhythm, and the app calling `shown(asOf:)`. On question 2's other answer, the default place too.

### The lane is ADR-1047 decision 7, amended in place

Grill answer 6. Decision 7 gains points 7–10 and its heading exception; decision 5 loses the title.

## Risks / Trade-offs

- **A thousand writes in one test** (each `add` rewrites the file) → the file stays under 200 KB. A
  run that is too slow is a stop, never a smaller count.
- **The no-op tests seed a layout the WHEN does not describe** → named above; `reviewer` reads each
  test at G7.
- **A strengthened test red on arrival** → treated as rule 3's red and fixed, never weakened back.
- **A zero-width space typed invisibly into a test** → the test writes it as `"\u{200B}"`.

## Questions for you

1. **A rename refused at the roster place after its records moved.** The rule says nothing is kept at
   either place, but today the records stay moved. Cover it here and fix it by carrying the records
   back, or record it as a known gap?
   - *Recommended:* cover and fix. The rule already ships, and grill answer 1 fixes a red here.
   - *If you say gap:* the second red and its scenario leave the delta, *Refuses a change it cannot
     make* keeps four new scenarios, and the gap joins the *Known gaps* entry.
2. **The place a commitments screen opens with when told none.** No outside observable exists without
   writing to the real directory. Widen the private `place` to internal as a second test-only seam, or
   record the rule as a gap?
   - *Recommended:* widen. It is one keyword and no behaviour change, and grill answer 3 wants the test.
   - *If you say gap:* the seam's second line goes, box 5.5 is dropped, and the rule joins *Known
     gaps*. No scenario text moves either way.

## Open Questions

None beyond § *Questions for you*: `grill.md` § *Left open* is "None.", and the rest is settled above.
