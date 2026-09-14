## Context

`proposal.md` § *Why* says what this is for; `grill.md`'s settled answers are the brief.
`openspec/specs/commitment/spec.md` holds 42 requirements and 398 scenarios. The delta carries 31
of them whole — 30 MODIFIED, one REMOVED and ADDED — with 93 new scenarios and eight reworded ones.

Five facts in source decide the approach. `RosterStore.write` is byte-stable, so rewriting an
unchanged roster is byte-identical and no byte check sees it. `RosterDocument.formRoster` replays
entries through `Roster.add`, which takes a second copy up again rather than refusing it.
`CommitmentsScreen.change` writes the record place before the roster place and restores nothing when
the roster write fails. `CommitmentsScreen.place` is private and defaults to the real
application-support directory, which no test may write to. `RosterStore` and `CommitmentRecord` have
one guard per verb and per refusal reason, and `CommitmentsScreen.change` has three branches.

## Goals / Non-Goals

**Goals:** every uncovered rule has exactly one scenario of its own that would fail were it broken;
every test grill answers 2–3 name can fail; the false title is corrected; the unprovable rules are
recorded; the lane is stated in ADR-1047.

**Non-Goals:** no rule dropped or added, no scenario dropped, no other capability, no public API.
No `src/` change except the reds' fixes and the two test-only internal members below.

## Decisions

### The seam

No public member is new or changed; tests drive the shipped `Roster`, `RosterStore`, `Commitment` and
`CommitmentsScreen` members. `place` on `CommitmentsScreen` becomes internal, read through `@testable`
by box 4.5 (question 2, settled). `writeCount` on `RosterStore` is added only if route 2 is taken.

```swift
let place: URL
var writeCount: Int { get }
```

### One scenario per rule, never shared

Ninety-six scenarios, 49 on the roster side and 47 on the screen. Each `tasks.md` clause names the
wrong implementation it catches. Each verb, refusal kind and branch with its own guard in source is
its own rule and gets its own scenario, and so is each item a requirement's prose enumerates. ANDs
vary only the fixture of one rule. Every finding in grill answer 8 comes out the same. Judged
against the fidelity list and not added: *MUST NOT sort … by a day* is covered by *commitments on
every schedule shape are read back as the same commitments*, which a stable sort on the kept-from
day fails. *SHALL ask its roster no date* is not covered by *a commitments screen does not list a
commitment its roster has stopped keeping*, whose stop falls before the screen's day, so it gets its
own scenario with a stop after that day. The large-roster sample stays at a thousand, since each
`add` rewrites the whole file.

### Three reds expected on arrival, each fixed here

- *a roster store holding a commitment again after holding it stopped or removed is refused*.
  Fix: `formRoster` refuses an entry whose commitment the roster already holds, in any state.
- *a change refused at the roster place after its records were carried over leaves the record place
  as it was*, and *a name and a rhythm changed in one save and refused at the roster place leave the
  record place as it was*. Fix (question 1, settled): when the roster write fails, `change` carries
  the records back in both branches.

### Migration

None — no build wrote a repeated entry: since its first persisted version (`a117347`) `Roster.add` takes a stopped commitment up again.

### Strengthened in place, and the three proven by mutation

Grill answers 1–3. Titles stay; bodies are rewritten. A scenario's text changes only where it did not
name what would fail. Mutations run in a `git archive` tree, and the PR body holds the diff and the
red run:

- **The four no-op tests.** Mutant: all four `if nextRoster != roster` guards removed
  (`drop-duplicate-commitment-scenarios` grill item 12). Route 1: the test seeds the place with the
  same roster in bytes the store never writes — an earlier form for the move, the current form laid
  out differently for the other three. Route 2, only if a route-1 test survives: `writeCount`.
- **The stop and remove *every earlier date* pair.** Mutant: `retire` or `remove` a no-op answering
  `true`. Each THEN gains an AND: nothing on 1 February 2026.
- **The take-up-again test.** Mutant: `Roster.addTakingUpAgain` removes the entry and inserts it at
  index 0, confirmed 2026-09-13. The test stays green because "Gym" is taken on first, so its WHEN and
  THEN now take on "Journaling" first.

Route 1 also gives a byte check its failing case in the ten store-refusal scenarios, and in *a change
that carries nothing over writes nothing at the record place*.

### Rewordings, before and after

- *A roster changes a commitment…*: "left exactly as it was and SHALL report" → "left exactly as it
  was but for the category it was offered under, and SHALL report" (grill answer 9).
- *A roster answers the earliest day…*: "the name it was given and the kind its days take and nothing
  else" → "the name it was given, the kind its days take and the rhythm it runs on in words, and
  nothing else" (grill answer 14, ADR-1034).
- *A roster reads … in groups*: "one none of whose commitments had been taken on by the date asked
  about" → "one that had stopped keeping or removed every commitment it holds before the date asked
  about" (grill answer 14).
- *…asks you to confirm…* → *…asks for confirmation…*; the title's "kept until the day the screen was
  handed" → "kept until the day before the one the screen was handed". The body was already true.
- Scenario text, grill answer 3: the no-op change gains a record place; six THENs gain one AND (the
  stopped rename, the rhythm change, the empty screen, the store stop on the last date, the pair); the
  take-up-again test's fixture order is swapped.

Twenty-four carried requirements are pre-budget prose over 150 words, kept whole under ADR-1047
decision 2; the three reworded here were already over and grow by eight words at most.

### The false title moves by REMOVED plus ADDED

OpenSpec 1.10.0 refuses a scenario rename inside MODIFIED, so the requirement lands last at archive.
Nothing cites its heading; only its test and ADR-1047 decision 5 quote the title.

### Pointer sentences skipped

Covered when their target is: the kind "compared as *A roster refuses…* says"; "as the refusals *A
roster refuses…* states"; "as *A roster refuses…* says" (twice); "as the roster requirements state
them"; "by the rule that already governs a commitment neither list holds"; "as *A commitments screen
defines…* says".

### The unprovable rules, for the *Known gaps* entry

- No seam accepts them: the present moment, time zone, locale and clock in every requirement; a
  category kept as a reference to a list; a roster store "SHALL NOT be what reaches" a record place.
  *The record place SHALL be written before the roster place* is not here: *a change a commitments
  screen could not carry over at the record place leaves the roster place as it was* proves it.
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
  rhythm, and the app calling `shown(asOf:)`.

### The lane is ADR-1047 decision 7, amended in place

Grill answer 6. Decision 7 gains points 7–10 and its heading exception; decision 5 loses the title.

## Risks / Trade-offs

- **A thousand writes in one test** → the file stays under 200 KB. A run that is too slow is a stop,
  never a smaller count.
- **Route 1 seeds a layout the WHEN does not describe** → named above; `reviewer` reads each test.
- **A strengthened test red on arrival** → treated as rule 3's red and fixed, never weakened back.
- **Carrying records back can itself fail** → the change is still refused; the reds' tests pin only
  the path where the record place stays writable.
- **A zero-width space typed invisibly into a test** → the test writes it as `"\u{200B}"`.

## Open Questions

None. `grill.md` § *Left open* is "None.", and the residual round is settled. Question 1: cover the
refused rename and fix `change` to carry records back. Question 2: make the default place internal,
read only by tests.
