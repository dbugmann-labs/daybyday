**Anything that fails or surprises is a stop and a report, never a workaround** (`AGENTS.md` rule 5): a
rebase conflict in this folder or in `openspec/specs/`, a scenario that cannot be written as a test
without changing its title, a test that passes before the code it names is written, a carried test
that has to be edited beyond what 2.2 allows or turns red, or a Kit signature that has to differ from
`design.md` § *The seam*.

Rule 3 governs § 3 and § 4: take the next unticked box, write the one test named for it — the
scenario title verbatim, which `pnpm run check:scenarios` checks — watch it fail, make it pass, then
the next. `PresentIdea` tests go in `PresentIdeaTests.swift`, store tests in
`PresentIdeaStoreTests.swift`, and screen tests in `BirthdaysScreenTests.swift`, every place a
temporary one of the test's own.

## 1. Before a line is written

- [x] 1.1 From the repo root, `pnpm run check:scenarios` reports exactly this change's twenty-three `present-idea` scenarios uncovered and no other

## 2. The seam

- [x] 2.1 `PresentIdea`, `PresentIdeaRefusal`, `PresentIdeaStore`, `PresentIdeaStoreError` and the `BirthdaysScreen` members exist with the signatures in `design.md` § *The seam*, and 3.1 is red before any of them does more than compile
- [x] 2.2 The only edits to carried `BirthdaysScreenTests` are a temporary present-idea place handed to each construction and a contact and `ideasInWords: nil` given to each `Line` built, apart from 4.1; every other carried test passes unedited
- [x] 2.3 `BirthdaysScreen` opens its present-idea place only in `init` and `shown(asOf:)`, writes it only in `addIdea`, and writes no copy

## 3. The twenty-three scenarios of `present-idea` — one test each

- [x] 3.1 a present idea holds its text and its link, each trimmed — catches an untrimmed part, or blank space kept as a text
- [x] 3.2 a present idea whose text and link both say nothing is refused — catches a test for emptiness that a tab passes
- [x] 3.3 a link that names no scheme is kept with https:// in front, and opens that address — catches "http://" put in front, or a host of ASCII letters alone
- [x] 3.4 a link that names http or https is kept exactly as typed — catches a scheme matched in small letters only, or a link lowercased
- [x] 3.5 a link that does not read as a web address is refused, whatever the text — catches `URL(string:) != nil` as the judge
- [x] 3.6 a present-idea store opened where nothing has been kept holds no ideas — catches a missing file read as an error
- [x] 3.7 a present-idea store opened again holds each contact's ideas in the order added, two alike both held — catches a set, or ideas sorted
- [x] 3.8 a present idea that cannot be kept is refused and not held — catches the held value replaced before the write
- [x] 3.9 a present idea added to a contact that says nothing is refused and leaves the place untouched — catches a blank contact written and refused only on the next opening
- [x] 3.10 present-idea stores at different places are independent — catches a place fixed inside the store
- [x] 3.11 content that is not a present-idea store is refused and left as it was — catches a bad file read as empty
- [x] 3.12 a present-idea store written in a later form than this app knows is refused — catches a later form reported as not a store
- [x] 3.13 a present-idea store holding what could not be held is refused — catches a decode that skips the value's own rules
- [x] 3.14 the present-idea place is a file of the app's own under Application Support, the same every time — catches a file name shared with another store
- [x] 3.15 a Birthdays screen line says how many present ideas its contact has, and nothing for none — catches "1 ideas", or "0 ideas"
- [x] 3.16 ideas against a contact the calendar does not hand are kept, and said once it hands that contact — catches unhanded contacts' ideas pruned
- [x] 3.17 an idea added through a Birthdays screen is kept against its line's contact, last, and its count says so at once — catches the count left until the next showing, or a re-ask of the calendar
- [x] 3.18 an add whose text and link both say nothing, or whose link is not a web address, is refused and writes nothing — catches the text kept and the link dropped
- [x] 3.19 an idea a Birthdays screen cannot keep is refused as not kept and not held — catches a failed write counted on the line
- [x] 3.20 what a Birthdays screen tells about a present idea ends when a field is edited, the sheet closes or the screen is shown again — catches a refusal that outlives the sheet
- [x] 3.21 a Birthdays screen that cannot read its present-idea place lists every birthday with no count and leaves the place as it was — catches the birthdays hidden with the ideas, or an add that writes over the file
- [x] 3.22 a present-idea place written by a later version makes a Birthdays screen that says so — catches the later version folded into not kept
- [x] 3.23 a Birthdays screen that could not read its present-idea place reads it again when shown — catches the place read once at `init`

## 4. The scenario of `birthday` this delta changes

- [x] 4.1 a Birthdays screen lists each birthday handed in its span as often as it is handed, and none handed outside it — its carried test's last assertion turned to Kate-2's line differing from Kate's, edited before 2.1 and red until `Line` carries a contact

## 5. The shell (ADR-1019: no rule the Kit does not state)

- [x] 5.1 `ContentView` builds every `BirthdaysScreen` with `BirthdaysScreen.presentIdeaPlace`, and nothing else in it moves
- [x] 5.2 `BirthdaysView` draws the chevron, `ideasInWords` and the not-kept line exactly as `design.md` § *The shell* and § *What the shell draws* say
- [x] 5.3 A new `PresentIdeasView` draws the person's page and the "New idea" sheet exactly as `design.md` § *The shell* says, composing no string but those it names, and decides nothing
- [x] 5.4 `git diff --stat origin/main... -- src/DayByDay/` lists `ContentView.swift`, `BirthdaysView.swift` and `PresentIdeasView.swift` alone; the app target builds for the simulator, and `WalkthroughUITests` passes unedited

## 6. The records

- [x] 6.1 `git diff --stat origin/main... -- openspec/specs/` reports nothing (rule 2)

## 7. The gates and the archive handover

- [x] 7.1 `openspec validate add-present-idea --strict` exits 0, and `pnpm run checks` is clean
- [x] 7.2 `pnpm run verify` green, and `swift test` in `src/DayByDayKit` passing with twenty-three more tests than a run on `origin/main` reports, both read off runs
- [ ] 7.3 **G7** — the reviewer's findings answered, and the PR rebased onto current `main`
- [ ] 7.4 **The archive handover — `implementer` ticks this in its last commit before the archive**, on the evidence that every other box is ticked — W.1–W.4 by the conductor at G7 — and W.5 holds its commit. The janitor runs `/opsx:archive` itself, never a hand-applied version of the sync it prints, then reads the spec diff: `openspec/specs/present-idea/spec.md` is created with nine requirements and twenty-three scenarios, `openspec/specs/birthday/spec.md` changes in those two requirements alone, and no other spec file moves. **Any other drift is a stop and a report, never a hand-edit** — the archive path is denied to every edit, so a box left unticked here cannot be reached afterwards.

## The walk

Every step needs birthdays on, so every step is the phone's (`docs/open-questions.md`: no simulator here gets calendar access). Birthdays are turned on in Settings first.

- [x] W.1 phone: the Birthdays screen, a chevron on every line; a real contact opened — the words as the page's heading, not cut — a text idea and then an idea of the link "amazon.de/xyz" alone added; back on the Birthdays screen the line says "2 ideas" dimmed under the words, and the page lists the two in the order added.
- [x] W.2 phone: *Add* with both fields blank — "Type an idea or a link." under the fields; then the text "Book voucher" with the link "amazon", no dot in its host — "That link is not a web address."; each time the sheet stays open with the fields as typed.
- [x] W.3 phone: the link idea from W.1, typed as "amazon.de/xyz", drawn as "https://amazon.de/xyz" on one line, cut where long; tapped, Safari opens https://amazon.de/xyz.
- [x] W.4 phone: the app closed from the switcher and opened again, back to the Birthdays screen — the line still says "2 ideas", and the page still lists both.
- [x] W.5 **The handover** — no step is the simulator's, so `pnpm run walk` is not run and nothing is posted; before hand-back the implementer ticks this on naming, here, the commit the human installs with `cd <this worktree> && pnpm run phone` to walk W.1–W.4 at G7. The conductor ticks W.1–W.4 on the G7 approval.
