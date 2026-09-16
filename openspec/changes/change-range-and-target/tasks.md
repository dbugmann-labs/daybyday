## 1. Before a box is ticked

**Anything that fails or surprises is a stop and a report, never a workaround** (`AGENTS.md`
rule 5): a rebase conflict in this folder or in `openspec/specs/`, a scenario that cannot be written
as a test without changing its title, a new test that passes before the code it names is written, a
fix that reaches outside the five files § 8.2 names, or any other test in the suite turning red.

Rule 3 governs §§ 3 and 4: take the next unticked box, write the one test named for it, watch it
fail, make it pass, then the next. Every `commitment` test goes in `CommitmentsScreenTests.swift`
and the `look-back` one in `LookBackTests.swift`, each named for its scenario title verbatim.
Section 5 is the only place a shipped test changes, and it names all three.

## 2. The seam

- [x] 2.1 Every member in `design.md` § *The seam* exists with that signature, the two renames carried through every call site in the kit, the tests and the shell, and `swift build` clean before any new test is written

## 3. `commitment` — one test each

- [x] 3.1 a commitments screen says a stopped commitment's range and target cannot be changed either — catches a second flag answering only for the rhythm
- [x] 3.2 a commitment whose range is changed through a commitments screen is kept until yesterday and the new one is taken on today — catches a range change carried over instead of superseded
- [x] 3.3 a target changed through a commitments screen supersedes and leaves every record already made standing — catches additions re-keyed onto the new target
- [x] 3.4 a range added to a number commitment carrying none, and one taken off, each supersede — catches a blank range read as "no change asked"
- [x] 3.5 a name and a range changed in one save put the new name on the superseded commitment and the new range on the one taken on — catches the carry-over target built with the new range
- [x] 3.6 a change refuses a range that is not a range and a target that is not a target — catches the two readings reaching `define` only
- [x] 3.7 changing the range or the target of a stopped commitment is refused — catches the stopped guard reading the rhythm and the day kept from alone
- [x] 3.8 a change of range whose result the roster already holds is refused as a commitment already kept — catches the already-kept guard missing from the new supersede path
- [x] 3.9 a change a stopped commitment does not take is about the range field where only the range differs — catches the placement comparing two things and falling to the foot
- [x] 3.10 a refusal is about the whole change where a range and another of the four differ — catches the first difference found deciding the field

## 4. `look-back` — one test

- [x] 4.1 a look-back chains an era whose range or target differs behind the one it was asked about — catches resemblance still comparing the whole kind

## 5. The three shipped tests that move

- [x] 5.1 `a change that names what is already there changes nothing and refuses nothing` gains the number commitment asked for exactly the range it carries, and still asserts both places byte-for-byte unchanged
- [x] 5.2 `a commitment of the number kind changed through a commitments screen keeps the kind its days take` passes the range it already has and asserts the entry is drawn under its new name
- [x] 5.3 `a commitment of the total kind whose rhythm is changed through a commitments screen keeps its kind and its target` passes the target it already has; no other shipped test changes, and one that needs to is a stop

## 6. The shell (ADR-1019: this Story's immediate consumer, no behaviour the kit does not specify)

- [x] 6.1 `CommitmentsView.swift`'s sheet passes `lowest`, `highest` and `target` to `screen.change` from the fields it already prefills, the kind picker alone staying `.disabled(changing != nil)`
- [x] 6.2 The range row and the target field are disabled by the renamed flag instead, so they take a thumb on a change to a kept commitment and grey on a stopped one, and `design.md` § *What the shell draws* is what the sheet looks like
- [x] 6.3 The words the shell says for *a change a stopped commitment does not take* no longer name the rhythm alone, and `pnpm run verify` passes with the app target building; the UI test bundle is run only as `## The walk` below says

## 7. The records

- [x] 7.1 Confirm `CONTEXT.md` §§ *Era* and *Superseding* still describe what shipped, the 2026-09-16 amendment included; a sentence that turns out wrong is a **stop and a G4 question**, never an edit slipped in
- [x] 7.2 Confirm `git diff --stat origin/main... -- openspec/specs/ docs/adr/` reports nothing (rule 2; no ADR is written — every decision here is this change's own)

## 8. The gates

- [x] 8.1 `openspec validate change-range-and-target --strict` exits 0 and `pnpm run check:scenarios` exits 0
- [x] 8.2 `git diff --stat origin/main` lists only this change folder, `CONTEXT.md`, `CommitmentsScreen.swift`, `CommitmentKind.swift`, `LookBack.swift`, `CommitmentsScreenTests.swift`, `LookBackTests.swift` and `CommitmentsView.swift`
- [x] 8.3 `pnpm run check:budgets` warns about this folder only for the three requirements `design.md` § *The three requirements over their word budget* names
- [x] 8.4 `swift test` in `src/DayByDayKit` passes, and the count it reports is eleven more than a run on `main` reports — both read off runs, never derived by arithmetic
- [ ] 8.5 **The archive handover — `implementer` ticks this in its last commit before the archive**, on the evidence that 2.1–8.4 are ticked and that the instruction below is written here for the janitor to carry out. The janitor runs `/opsx:archive` itself, never a hand-applied version of the sync it prints, then reads the spec diff it produced: `openspec/specs/commitment/spec.md` keeps its requirement count — three requirements gain edited sentences and eight scenarios between them, and the requirement about which field a refusal is about is replaced by the one named for four things, carrying its four scenarios and two new ones; `openspec/specs/look-back/spec.md` gains one scenario and one edited sentence. Nothing else in either spec, and no other spec, moves. `pnpm run checks` runs after the archive commit exists. **Any other drift is a stop and a report, never a hand-edit** — rule 2 denies `openspec/specs/`, and `.claude/settings.json` denies `Edit(/openspec/changes/archive/**)`, so a box left unticked here cannot be reached afterwards.

## The walk

- [ ] W1 *Mood*, a kept number commitment ranging 1 to 10, opened to change: the range row prefilled and taking a thumb, the kind picker beside it greyed
- [ ] W2 *Protein*, a kept total commitment, opened to change: the target field prefilled with 120 and taking a thumb
- [ ] W3 That *Mood* sheet with a lowest of 10 and a highest of 1, *Save* tapped: the refusal told under the range row, the sheet still open
- [ ] W4 *Mood*'s look-back page after its range is narrowed to 1 to 5 and saved: the head still saying the day it was first kept from
- [ ] W5 A stopped number commitment opened to change: the range row greyed beside the frozen rhythm, with nothing said beside it
- [ ] W6 The five pictures posted to the PR with `gh pr comment --attach` before hand-back, ticked on the comment's URL
