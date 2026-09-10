## 1. Before a box is ticked

**Anything that fails or surprises is a stop and a report, never a workaround** (`AGENTS.md`
rule 5): `openspec validate` refusing the split, the archiver refusing a scenario, a rebase
conflict in this folder or in `openspec/specs/`.

**Every box in § 2 asks the same three things of one requirement**, and is ticked only when all
three hold: every *Rules at risk* sentence the surveys list for it is a SHALL/MUST sentence in the
rewritten prose; every scenario under it is byte-for-byte what it is today, title and body; and its
prose is 40–150 words, or is one of the seventeen `design.md` § *Overruns the budget* lists with the
reason it carries. A clause after a heading is the trap that requirement carries and nothing
more — the three things are still what the tick means.

**Where each requirement's *Rules at risk* list is**, all under
`docs/research/2026-09-09-concise-specs/`: `survey-day-screen-A.md` for boxes 2.1–2.20, under its
own numbers 1–16 and 19–22; `survey-day-screen-B.md` for boxes 2.21–2.41, under its numbers 23–43;
and `survey-2026-09-10-day-screen.md` for boxes 2.9, 2.10, 2.11, 2.16, 2.20, 2.22, 2.24, 2.40 and
2.42–2.48, under its blocks 1–15. The third supersedes the other two wherever they overlap.

## 2. `day-screen` — one box per requirement, in spec order

- [x] 2.1 *A day view is the commitments due on a date, each with whether it is kept*
- [x] 2.2 *A row offers the tick that keeps its commitment, and refuses one for a day that has not arrived*
- [x] 2.3 *A row is a commitment's line on a date* — **splits in two**, identity and contents against what a row gives back including the rhythm; every scenario title goes verbatim to the half it belongs to
- [x] 2.4 *A day view is in the order it was handed its commitments*
- [x] 2.5 *A day view is a value* — the rule that a group with nothing due produces no group is stated here and nowhere else
- [x] 2.6 *A day view moves to the day before it and the day after it*
- [x] 2.7 *A move is one calendar day, and never more*
- [x] 2.8 *There is no day before the first supported date and none after the last*
- [x] 2.9 *A day screen moves the day it is showing one calendar day either way* — keep the sentence forbidding a stop at the earliest day a commitment is kept from; 2.42 defers to it by name
- [x] 2.10 *A day screen goes straight back to the today it was handed*
- [x] 2.11 *A move with nowhere to go leaves a day screen exactly as it was* — states the pair about a caller not standing a move down, which 2.47 states a second time today and now cross-references
- [x] 2.12 *A day screen holds the day view of the day it was handed, formed from the record kept at its place*
- [x] 2.13 *A day screen makes and takes back the tick a row offers, and keeps it before the day view says so*
- [x] 2.14 *A day screen keeps its record at a place that survives the app being closed* — the `Application Support` justification is ADR-1017's and goes from here and from 2.19 alike; the normative tail stays in both
- [x] 2.15 *A day screen that cannot read its record draws the day and keeps nothing*
- [x] 2.16 *A day screen re-reads its day and its record when the app is shown again* — holds the only statement of when a roster read again that holds nothing takes on the commitments the screen was handed
- [x] 2.17 *A day screen draws the commitments its roster had not stopped keeping on the day it is showing* — defers 2.5's group rule in one clause; do not restate it and do not drop it
- [x] 2.18 *A day screen takes on the commitments it was handed when its roster holds nothing at all*
- [x] 2.19 *A day screen keeps its roster at its own place, beside its record* — see 2.14
- [x] 2.20 *A day screen that cannot read its roster draws the day and no rows*
- [x] 2.21 *A day screen tells on the row that was tapped that a change could not be kept*
- [x] 2.22 *What a day screen tells on a row lasts until the app is shown again, a change is kept, or the day it is showing changes* — the rule keys on the day **changing** and never on the gesture; 2.43 derives from it
- [x] 2.23 *A day screen tells nothing on a row where there was no tick to refuse*
- [x] 2.24 *A day screen reads its roster again when it is returned to* — `add-commitment-editing` (#148) reversed the rule survey B recorded here: rewrite from the current sentence, and leave the false scenario title unrenamed
- [x] 2.25 *A row offers the number entry its commitment takes, and offers none for a day that has not arrived* — states for the family that a row offers at most one entry kind; 2.29 and 2.33 cross-reference it
- [x] 2.26 *A number entry says the range its commitment takes and the number the day already holds* — the hint's en dash stays as a normative sentence and its "why" goes
- [x] 2.27 *A day screen enters the number a row's entry takes, and keeps it before the day view says so* — states for the family the eight behaviours the three entries share; 2.31 and 2.36 cross-reference them
- [x] 2.28 *A day screen reads what an entry is committed with as a number, as a take-back, or as neither* — keep the enumeration of what is not a number: it is a scenario's fixture list and the only statement that a digit outside the ten is refused
- [x] 2.29 *A row offers the note entry its commitment takes, and offers none for a day that has not arrived* — see 2.25
- [x] 2.30 *A note entry says the note the day already holds, and says nothing else*
- [x] 2.31 *A day screen enters the note a row's entry takes, and keeps it before the day view says so* — see 2.27
- [x] 2.32 *A day screen reads what is committed in a note entry as a note or as a take-back*
- [x] 2.33 *A row offers the total entry its commitment takes, and offers none for a day that has not arrived* — see 2.25
- [x] 2.34 *A total entry says the day's sum and the commitment's target, and says nothing else* — the field-is-not-prefilled rule stays as a SHALL; its argument is ADR-1041's
- [x] 2.35 *A row offers taking back its day's last addition, and offers none where the day holds none*
- [x] 2.36 *A day screen adds what is committed in a row's total entry, and keeps it before the day view says so* — see 2.27
- [x] 2.37 *A day screen reads what is committed in a total entry as an amount to add, as nothing at all, or as a value it refuses* — keep the one clause deferring to 2.28: it is the whole of the total's number grammar
- [x] 2.38 *A day screen takes back the last addition a row offers, and keeps it before the day view says so*
- [x] 2.39 *A day view draws its rows in the groups it was handed, and draws no group with nothing due*
- [x] 2.40 *A day screen says whether it offers the way back to today* — keep the sentence that the answer is about the control and not the position, which 2.45 depends on; its argument is ADR-1045's
- [x] 2.41 *A row says whether it offers anything at all*
- [x] 2.42 *A day screen says the reach of its day picker* — **splits in two**; the floor's rationale is ADR-1048's, and the sentence deferring the screen's unboundedness to 2.9 stays
- [x] 2.43 *A day screen shows a day picked on its day picker*
- [x] 2.44 *A day view says its day as a weekday* — keep "and nothing else": no day of the month, no month, no year, no word in front
- [x] 2.45 *A day screen says the day it is showing*
- [x] 2.46 *A day screen says the day view of the day before the one it is showing and of the day after* — **splits in two**; keep the non-regression clause and "whichever happened later"
- [x] 2.47 *A day screen says no day view before the first supported date and none after the last* — cross-references 2.11 in one clause rather than stating its pair a second time
- [x] 2.48 *A day screen makes every change on the day it is showing and none on a day either side of it* — keep the link to the inherited rule that a row the day view does not hold changes nothing

## 3. The gates

- [x] 3.1 `openspec validate condense-day-screen-spec --strict` exits 0.
- [x] 3.2 `pnpm run check:scenarios` exits 0 — every scenario title in the delta still names a test
      that exists, which is what "byte-for-byte" means mechanically.
- [x] 3.3 `pnpm run check:budgets` reports no requirement over 150 words except the seventeen
      `design.md` § *Overruns the budget, and why each one is over* lists, and no artifact over its
      own budget.
- [x] 3.4 `swift test` in `src/DayByDayKit` passes and reports the same number of tests as it does
      on `main` — read off both runs, never derived — because this Story touches no test file.
- [x] 3.5 **The archive handover — `implementer` ticks this in its last commit before the archive**,
      on the evidence that 3.1–3.4 are ticked and that the instruction below is written here for the
      janitor to carry out. The janitor runs `/opsx:archive`, then reads the spec diff it produced:
      `openspec/specs/day-screen/spec.md` must differ in requirement prose only, with every
      `#### Scenario:` title and body unchanged, and with the three split requirements gone from
      their old places and their six replacements at the end of the file. **Any other drift is a
      stop and a report, never a hand-edit** — rule 2 denies `openspec/specs/`, and
      `.claude/settings.json` denies `Edit(/openspec/changes/archive/**)`, so a box left unticked
      here cannot be reached afterwards.
