**Anything that fails or surprises is a stop and a report, never a workaround** (`AGENTS.md` rule 5): a
rebase conflict in this folder or in `openspec/specs/`, a scenario that cannot be written as a test
without changing its title, a test that passes before the code it names is written, a carried test
that has to be edited or turns red, or a Kit signature that has to differ from `design.md` § *The seam*.

Rule 3 governs §§ 3–5: take the next unticked box, write the one test named for it — the scenario
title verbatim, which `pnpm run check:scenarios` checks — watch it fail, make it pass, then the next.
§ 3 goes in `src/DayByDayKit/Tests/DayByDayKitTests/HappeningTests.swift`, § 4 in
`HappeningStoreTests.swift` beside it, § 5 in `CommitmentsScreenHappeningTests.swift`.

## 1. Before a line is written

- [ ] 1.1 From the repo root, `pnpm run check:scenarios` reports exactly this change's thirty-one scenarios uncovered and no other

## 2. The seam

- [ ] 2.1 `Happening`, `Happenings`, `HappeningStore`, `HappeningStoreError`, `DayScreen.happeningPlace` and the `CommitmentsScreen` members exist with the signatures in `design.md` § *The seam*, and 3.1 is red before any of them does more than compile
- [ ] 2.2 `Happening`'s `==` and `hash(into:)` read the identity alone; `Happenings`' equality reads each happening's identity and name in order
- [ ] 2.3 Names are judged with `Blank.saysNothing(_:)` and `Blank.trimmed(_:).lowercased()`; no second whitespace or case-folding rule is added (ADR-1039)
- [ ] 2.4 The document type is `internal`, version 1, written in held order with `.sortedKeys` and `.atomic`, and read back through `Happening` and `Happenings`' own rules

## 3. The seven scenarios of the value — one test each

- [ ] 3.1 two happenings made separately from one name are two happenings — catches equality over the name
- [ ] 3.2 a happening's name is kept exactly as it was given — catches a trim in the value
- [ ] 3.3 a name that says nothing makes no happening — catches a length check instead of the blank test
- [ ] 3.4 happenings are held in the order they were added, the newest last — catches a sort by name
- [ ] 3.5 adding a happening whose name one held already has is refused and changes nothing — catches an exact-match name check
- [ ] 3.6 a happening renamed keeps its identity and its place — catches a rename as remove-then-add
- [ ] 3.7 renaming a happening onto another's name, to a name that says nothing, or when it is not held, is refused — catches a rename refused by its own name

## 4. The eight scenarios of the store — one test each

- [ ] 4.1 a happening store opened where nothing has been kept holds no happenings — catches an error on an empty place
- [ ] 4.2 a happening store opened again holds the happenings left there, renamed and in their order — catches a fresh identity minted on reading
- [ ] 4.3 a happening change that cannot be kept is refused and not held — catches a store that holds what the disk refused
- [ ] 4.4 a change the happenings refuse leaves the happening store's place untouched — catches a rewrite on a refused change
- [ ] 4.5 happening stores at different places are independent — catches a shared or static place
- [ ] 4.6 content that is not a happening store is refused and left as it was — catches opening empty over what is there
- [ ] 4.7 a happening store written in a later form than this app knows is refused — catches a version read after the body
- [ ] 4.8 a happening store holding what could not be a happening is refused — catches a decoder that skips a bad entry or misses two alike

## 5. The sixteen scenarios of the commitments screen — one test each

- [ ] 5.1 the happening place is a file of the app's own under Application Support, the same every time — catches a place shared with another store
- [ ] 5.2 a commitments screen given no happening place keeps its happenings beside its record place — catches a default to the real Application Support file
- [ ] 5.3 a commitments screen lists the happenings at its happening place in the order they were made — catches a file written on opening
- [ ] 5.4 a happening made through a commitments screen is listed last and kept at its place — catches an untrimmed name
- [ ] 5.5 a commitments screen refuses a happening whose name a listed one has, naming the listed one — catches the typed name quoted instead
- [ ] 5.6 a happening the happening place cannot take is refused as not kept — catches a list refreshed before the write
- [ ] 5.7 making and renaming a happening writes no copy and leaves the other places as they were — catches `keptAChange()` copied from `define`
- [ ] 5.8 a happening renamed through a commitments screen keeps its place in the list — catches a renamed row moved last
- [ ] 5.9 a commitments screen refuses a rename onto a name another listed happening has, naming that one — catches a case-only rename refused
- [ ] 5.10 a rename to the name a happening already has, or of one not listed, asks for no change — catches a no-op that ends the refusal
- [ ] 5.11 what a commitments screen tells about a happening ends when its name is edited, the sheet closes or the app is shown — catches a refusal that outlives its sheet
- [ ] 5.12 what a commitments screen tells about a happening is held apart from a commitment's refusal — catches one refusal value shared by both
- [ ] 5.13 a commitments screen that cannot read its happening place lists none and leaves the place as it was — catches the roster taken down with it
- [ ] 5.14 a happening place written by a later version makes a commitments screen that says so — catches the two causes folded into one
- [ ] 5.15 a commitments screen that could not read its happening place reads it again when the app is shown — catches a place read once at `init`
- [ ] 5.16 a commitments screen that cannot read its roster still makes and renames happenings — catches the happening state read off `rosterState`

## 6. The shell (ADR-1019: no rule the Kit does not state)

- [ ] 6.1 `CommitmentsView` draws the *Happenings* section, its two sheets and its words exactly as `design.md` § *The shell* and § *What the shell draws* say, calling `happeningNameEdited()` on every edit of the field and `happeningSheetClosed()` on every dismissal
- [ ] 6.2 `git diff --stat origin/main... -- src/DayByDay/` lists `CommitmentsView.swift` alone; the app target builds for the simulator, and `WalkthroughUITests` passes unedited

## 7. The records

**ADR-1065, its `docs/adr/README.md` row and the `CONTEXT.md` entries are written by this Story's
proposal commit, not by the implementation.** These boxes confirm rather than write.

- [ ] 7.1 Confirm ADR-1065 and `CONTEXT.md` § *Happening*, § *Happening store*, § *Happening place* and the 2026-10-02 amendment to § *Commitments screen* describe what shipped; a sentence that turns out wrong is a stop and a G4 question
- [ ] 7.2 Confirm ADR-1065 is still the only record numbered 1065 on `origin/main` after the last rebase; a clash is a stop and a report, never a renumber by the implementer
- [ ] 7.3 `git diff --stat origin/main... -- openspec/specs/` reports nothing (rule 2)

## 8. The gates and the archive handover

- [ ] 8.1 `openspec validate add-happening --strict` exits 0, and `pnpm run checks` is clean
- [ ] 8.2 `pnpm run verify` green, and `swift test` in `src/DayByDayKit` passing with thirty-one more tests than a run on `origin/main` reports, both read off runs
- [ ] 8.3 **G7** — the reviewer's findings answered, and the PR rebased onto current `main`
- [ ] 8.4 **The archive handover — `implementer` ticks this in its last commit before the archive**, on the evidence that every other box is ticked and the walk comment's URL is in W.6. The janitor runs `/opsx:archive` itself, never a hand-applied version of the sync it prints, then reads the spec diff: `openspec/specs/happening/spec.md` is created with this delta's ten requirements, its thirty-one scenarios and its Purpose, and no other spec file moves. **Any other drift is a stop and a report, never a hand-edit** — the archive path is denied to every edit, so a box left unticked here cannot be reached afterwards.

## The walk

A fresh install, the commitments screen opened from the day screen's list symbol.

- [ ] W.1 The commitments screen scrolled to its foot — *Happenings* heading, "No happenings yet." above *New happening* in the accent, below *Stopped*.
- [ ] W.2 *New happening* tapped and "Augenm" typed — the sheet titled New happening with Cancel and Add, the keyboard up.
- [ ] W.3 "Augenmigräne" and then "Kopfweh" added — the section listing Augenmigräne, Kopfweh, then *New happening*; no empty line.
- [ ] W.4 *New happening* tapped, "kopfweh" typed and Add tapped — the sheet still open, `A happening called "Kopfweh" already exists.` in red under the field.
- [ ] W.5 Kopfweh swiped right, the pencil tapped, renamed "Spannungskopfweh" and saved — the section listing Augenmigräne then Spannungskopfweh.
- [ ] W.6 **The handover** — W.1–W.5, taken on the final build, are posted to the PR with `pnpm run walk -- --post-only <pr>`, never `gh pr comment --attach`, before hand-back, and this box is ticked on that comment's URL.
