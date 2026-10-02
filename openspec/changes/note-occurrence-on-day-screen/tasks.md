**Anything that fails or surprises is a stop and a report, never a workaround** (`AGENTS.md` rule 5): a
rebase conflict in this folder or in `openspec/specs/`, a scenario that cannot be written as a test
without changing its title, a test that passes before the code it names is written, a carried test
that has to be edited or turns red other than the one fixture 2.4 names, or a Kit signature that has
to differ from `design.md` § *The seam*.

Rule 3 governs §§ 3–4: take the next unticked box, write the one test named for it — the scenario
title verbatim, which `pnpm run check:scenarios` checks — watch it fail, make it pass, then the next.
§ 3 goes in `src/DayByDayKit/Tests/DayByDayKitTests/OccurrenceTests.swift`, § 4 in
`DayScreenHappeningTests.swift` beside it.

## 1. Before a line is written

- [ ] 1.1 From the repo root, `pnpm run check:scenarios` reports exactly this change's twenty-three scenarios uncovered and no other

## 2. The seam

- [ ] 2.1 `TimeOfDay`, `Occurrence`, the `Happenings`, `HappeningStore`, `DayView` and `DayScreen` members exist with the signatures in `design.md` § *The seam*, and 3.1 is red before any of them does more than compile
- [ ] 2.2 `Happenings`' equality and hash read its occurrences in order as well as its happenings; `Occurrence` synthesises both over all four fields
- [ ] 2.3 `HappeningDocument` writes form 2 with `.sortedKeys` and `.atomic`, reads form 1 as no occurrences, and re-forms every occurrence through `Happenings.note` and `TimeOfDay(hour:minute:)`; notes are judged with `Blank` alone (ADR-1039)
- [ ] 2.4 The one sanctioned carried-test edit: `CommitmentsScreenHappeningTests`' later-form fixture writes `HappeningDocument.currentVersion + 1` instead of the literal `2`, and nothing else in that test moves
- [ ] 2.5 `DayScreen` opens the happening place at `init`, at `shown(asOf:)` and on both paths of `returnedTo(from:)`, beside the record place where none is given; it is not added to `readPlaces`, `RestoreInProgress` or `saysACopyCanBeRestored`

## 3. The nine scenarios of `happening` — one test each

- [ ] 3.1 an occurrence holds its happening, its day, its time and its note as given — catches a trim in the value
- [ ] 3.2 a note that says nothing is no note, and a time outside the clock is no time — catches an empty-string check instead of the blank test
- [ ] 3.3 occurrences are held in the order noted, and two alike are both held — catches a set
- [ ] 3.4 an occurrence of a happening not held is refused and changes nothing — catches a note with no membership check
- [ ] 3.5 a happening renamed keeps its occurrences — catches occurrences keyed by name
- [ ] 3.6 a happening store opened again holds the occurrences noted there, in their order — catches occurrences left out of the document
- [ ] 3.7 an occurrence the happening store cannot keep is refused and not held — catches the held value replaced before the write
- [ ] 3.8 a happening store in its first form is read as holding no occurrences — catches form 1 refused or rewritten on opening
- [ ] 3.9 a happening store holding an occurrence that could not be one is refused — catches a decoder that skips a bad occurrence

## 4. The fourteen scenarios of `day-screen` — one test each

- [ ] 4.1 a day screen lists the happenings beside its record place in the order they were made — catches a default to the real Application Support file
- [ ] 4.2 a day screen returned to or shown again reads its happening place afresh — catches a place read once at `init`
- [ ] 4.3 a day screen offers noting a happening on today and a past day, and not on a later day — catches `offersNotingAHappening` true on every day
- [ ] 4.4 a day screen that lists no happening offers no noting, whatever its other places hold — catches the offer gated on `recordState`
- [ ] 4.5 an occurrence's time starts at now on today and at none on a past day — catches the comparison made against the screen's today
- [ ] 4.6 an occurrence noted on today is kept at the happening place and drawn on the day — catches an untrimmed note or a second one dropped
- [ ] 4.7 an occurrence noted with no time holds its day alone, on a past day and on today — catches the time required on today
- [ ] 4.8 noting an occurrence writes no copy, leaves the other places as they were and ends a notice — catches `keptAChange()` copied from the one-offs
- [ ] 4.9 an occurrence at a time later than now, or on a day that has not come, is refused as not yet come — catches `>=` where `>` is meant
- [ ] 4.10 an occurrence the happening place cannot take is refused as not kept — catches a day view re-formed before the write
- [ ] 4.11 a happening row says its times earliest first, then each occurrence with no time — catches the noted order kept
- [ ] 4.12 a day view holds rows only for the happenings that came, in the order they were made — catches rows ordered by first time, or an adjacent day without them
- [ ] 4.13 a day screen that cannot read its happening place lists none and leaves the place as it was — catches the restore line turned on
- [ ] 4.14 a happening place written by a later version makes a day screen that says so — catches the two causes folded into one

## 5. The shell (ADR-1019: no rule the Kit does not state)

- [ ] 5.1 `ContentView` draws the bolt, its menu, the note sheet, the happening card and the two store-card lines exactly as `design.md` § *The shell* and § *What the shell draws* say, handing `momentNow()` to `startingTime` and `note`
- [ ] 5.2 `everySourceOfTheListWasRead` and the "Nothing is due on this day." condition are unchanged and read no happening state
- [ ] 5.3 `git diff --stat origin/main... -- src/DayByDay/` lists `ContentView.swift` alone; the app target builds for the simulator, and `WalkthroughUITests` passes unedited

## 6. The records

**The `CONTEXT.md` entries are written by this Story's proposal commit, not by the implementation.**

- [ ] 6.1 Confirm `CONTEXT.md` § *Time of day*, § *Happening row* and the 2026-10-02 amendments to § *Happening* and § *Happening store* describe what shipped; a sentence that turns out wrong is a stop and a G4 question
- [ ] 6.2 `git diff --stat origin/main... -- openspec/specs/` reports nothing (rule 2)

## 7. The gates and the archive handover

- [ ] 7.1 `openspec validate note-occurrence-on-day-screen --strict` exits 0, and `pnpm run checks` is clean
- [ ] 7.2 `pnpm run verify` green, and `swift test` in `src/DayByDayKit` passing with twenty-three more tests than a run on `origin/main` reports, both read off runs
- [ ] 7.3 **G7** — the reviewer's findings answered, and the PR rebased onto current `main`
- [ ] 7.4 **The archive handover — `implementer` ticks this in its last commit before the archive**, on the evidence that every other box is ticked and the walk comment's URL is in W.10. The janitor runs `/opsx:archive` itself, never a hand-applied version of the sync it prints, then reads the spec diff: `openspec/specs/happening/spec.md` gains this delta's three requirements and nine scenarios, `openspec/specs/day-screen/spec.md` its seven requirements and fourteen scenarios, and no other spec file moves. **Any other drift is a stop and a report, never a hand-edit** — the archive path is denied to every edit, so a box left unticked here cannot be reached afterwards.

## The walk

A fresh install; "Augenmigräne", "Kopfweh" and "Schlecht geschlafen" made on the commitments screen first.

- [ ] W.1 Today, returned to from the commitments screen — the bolt right of the "New one-off" field at the foot.
- [ ] W.2 The bolt tapped — the menu above it reading Augenmigräne, Kopfweh, Schlecht geschlafen, top to bottom.
- [ ] W.3 Kopfweh picked on today — the sheet titled Kopfweh with Cancel and Save, "Time" showing the current time with its clear button, the note field.
- [ ] W.4 Today after Kopfweh noted at an earlier time (09:10 where the clock is past it) and once with the time cleared — the card at the foot reads "Kopfweh · 09:10, no time".
- [ ] W.5 A past day, Kopfweh picked — the sheet's "Time" row reading "No time".
- [ ] W.6 A future day — no bolt, the "New one-off" field running full width.
- [ ] W.7 `happenings.json` replaced by bytes that are not a store, the app shown again — the store card's line "The happenings could not be read." and no bolt.
- [ ] W.8 phone: on today, clear the sheet's time, set one with the time picker, clear it again, then Save — the row says "no time" for it.
- [ ] W.9 phone: type a note of two lines with the keyboard up — both lines and the Save button stay in view.
- [ ] W.10 **The handover** — W.1–W.7, taken on the final build, are posted to the PR with `pnpm run walk -- --post-only <pr>`, never `gh pr comment --attach`, before hand-back, and this box is ticked on that comment's URL.
