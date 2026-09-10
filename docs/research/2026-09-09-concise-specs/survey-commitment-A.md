# Survey A — `openspec/specs/commitment/spec.md`, requirements 1–18

Range: lines 13–2085 (2,073 lines), plus `## Purpose` (lines 3–9, 61 words — normative-free but
short and accurate; leave it).

## The table

Percentages are of the prose words between the requirement heading and its first `#### Scenario:`:
(a) normative rules, (b) rationale / alternatives / "why", (c) cross-references, exclusions and
restatements of other requirements.

| # | Title (short) | Lines | Prose words | Scen. | a rules | b why | c xref/excl | Verdict | After |
|---|---|---|---|---|---|---|---|---|---|
| 1 | A commitment is name, schedule, kept-from | 13–90 | 444 | 7 | 45% | 40% | 15% | trim | 130 |
| 2 | A name says something | 91–131 | 182 | 4 | 65% | 25% | 10% | trim | 90 |
| 3 | Kind is tick/number/note/total | 132–192 | 420 | 4 | 50% | 35% | 15% | trim | 130 |
| 4 | A range is lowest and highest | 193–240 | 309 | 4 | 60% | 25% | 15% | trim | 120 |
| 5 | A target is a number above zero | 241–283 | 235 | 4 | 60% | 25% | 15% | trim | 95 |
| 6 | Due exactly when the schedule is | 284–333 | 185 | 5 | 80% | 10% | 10% | keep | 120 |
| 7 | Not due before the kept-from day | 334–389 | 256 | 5 | 55% | 35% | 10% | trim | 110 |
| 8 | A roster holds commitments in order | 390–517 | 1034 | 8 | 55% | 25% | 20% | rewrite | 330 |
| 9 | A roster refuses one it already holds | 518–746 | 1315 | 16 | 45% | 35% | 20% | rewrite | 350 |
| 10 | A roster stops keeping, on a day | 747–864 | 601 | 9 | 70% | 20% | 10% | trim | 200 |
| 11 | Which it had not stopped, on a date | 865–992 | 574 | 10 | 65% | 25% | 10% | trim | 180 |
| 12 | A roster store keeps a roster | 993–1382 | 1005 | 31 | 60% | 15% | 25% | rewrite | 330 |
| 13 | A store reads earlier forms | 1383–1537 | 680 | 12 | 65% | 25% | 10% | trim | 230 |
| 14 | Unreadable store is refused | 1538–1588 | 252 | 4 | 70% | 25% | 5% | trim | 110 |
| 15 | Screen lists what its roster keeps | 1589–1765 | 809 | 12 | 55% | 30% | 15% | rewrite | 250 |
| 16 | Screen lists what has been stopped | 1766–1879 | 490 | 8 | 45% | 45% | 10% | trim | 140 |
| 17 | Screen defines a commitment | 1880–2033 | 621 | 11 | 60% | 25% | 15% | trim | 230 |
| 18 | Screen refuses empty name / empty set | 2034–2085 | 200 | 4 | 65% | 25% | 10% | trim | 100 |

Only #6 already meets the 40–150-word target. Eight requirements are over 400 prose words; two are
over 1,000. Fifteen of the eighteen use bold sentences as structure (`**…**` opens a paragraph in
8, 9, 11, 12, 13, 15, 16, 17), which the concise shape forbids.

## 1. Rules at risk — sentences a naive trim would delete

Confirmed mechanism first: scenario titles are test names verbatim (e.g. *removing one of two
entries alike in name removes the one it was asked about* →
`src/DayByDayKit/Tests/DayByDayKitTests/CommitmentsScreenTests.swift`), so anything a scenario
asserts is protected. The danger is rules that no scenario asserts and that read as explanation.

- **#1, line 22–23** — "it cannot know what day it is, because the present moment is not something
  this capability is allowed to consult". The only statement in #1 banning a clock read; it is
  phrased entirely as a reason. Reqs 8, 10, 11 repeat the ban for the roster, nothing repeats it for
  commitment formation.
- **#1, line 41–42** — "a record embeds the whole commitment by value" is the premise the
  `SHALL NOT change` on the kind rests on; it is also the premise ADR-1038 uses for the category.
  Keep the `SHALL NOT change` (line 40); the by-value clause can go to the ADR.
- **#3, line 143–144** — "this is a rule about what can be *formed at all* rather than one about what
  is refused when it is tried, so there is no such thing as a note with a target to write a scenario
  about". Not a behaviour rule but a testability rule: delete it and the next author adds a
  "note with a target is refused" scenario for behaviour that cannot be constructed.
- **#4, line 203–205** — "made where the range is formed so that every caller gets it: a screen
  refusing the same thing in words a person can read is #142's, and it is that refusal surfaced
  rather than a second one". Fixes *where* range validation lives and that the screen must not add a
  second check. Rationale-shaped, load-bearing across capabilities.
- **#4, line 212–214** — "this is stated rather than left to the comparison, because a comparison
  against a value that is not a number answers *true* in one direction and *false* in the other".
  The rule ("A value that is not a number SHALL NOT be an end") survives on line 212; only the
  reason is cuttable. Listed because the sentence reads as one unit.
- **#7, line 347–352** — "it is a floor rather than a phase: the day a commitment is kept from does
  not have to be a day its schedule is due on, and it does not shift the schedule to begin there …
  its own start date and this floor are separate and both apply". Three separate rules inside a
  paragraph that opens as explanation; the interval half is asserted by the scenario at 381, the
  "need not be a due day" half by 367, but the "does not shift the schedule" clause is asserted
  nowhere.
- **#8, line 398–401** — "**moving** is the only thing that ever changes it. A move takes one of
  exactly two things and there is no third: a **commitment** … or a **group**, which takes every
  commitment under one category with it as a block". The definition of what a move is, sitting
  inside the bolded ADR-1037 paragraph.
- **#8, line 424–426** — "**The ban on a position is a ban on a read.** Nothing asks a roster where a
  commitment is, and moving one hands a place **in** rather than reading one out". Narrows the
  MUST NOT on line 418; no scenario can assert an absent read.
- **#8, line 428–432** — "The roster answers it as part of the **groups** it reads its commitments
  back in, and nothing asks it about one commitment on its own". The only statement that the
  category read-back is group-shaped, and it is the last sentence of a paragraph whose first two
  sentences are pure justification.
- **#9, line 556–559** — "Being offered under no category therefore takes the category off. Offering
  it again *without saying a category* … leaves the category alone." Inside the paragraph headed
  "**The offered category wins … and that is the decision**", i.e. the most rationale-looking block
  in the requirement. #16's scenario at 1869 depends on the second half; #17's prose at 1892–1897
  restates the first.
- **#9, line 567–569** — "What was actually done on those days is untouched either way, because that
  is the ticks and no tick moves." The only place in #9 stating that taking up again does not touch
  records; #11 line 890 states it again for the date answer, so this one is recoverable — but only
  if the trimmer notices.
- **#10, line 761–762** — "A removal is a last state: there is nothing a stop could add to it".
  Reads as a reason; it is the ground of the third refusal case, which the scenario at 856 does
  assert. Safe if the bullet at 760 is kept whole.
- **#11, line 872–873** — "a move is dated by nothing and moves no kept-until day". Two rules, in a
  trailing clause.
- **#12, line 1022–1028** — "**A change that leaves the roster exactly as it was SHALL keep nothing
  at the place either, and SHALL still report what the roster reported**". Rule with SHALL, but it
  is embedded in a paragraph whose second half ("a store keeps what a change made, and a change that
  made none has nothing to keep") is the reason; the three examples that follow are what the
  scenarios at 1268, 1319 and 1373 test.
- **#12, line 1046–1049** — "MUST NOT write its commitments grouped: the groups are a reading of the
  roster's one order and are worked out again on every read". A rule about the written form, only
  provable by inspecting the file; no scenario asserts it.
- **#13, line 1414–1415** — "A commitment under no category is said so rather than left unsaid, which
  is what lets the two be told apart at all". States what the current form must contain; the rest of
  the sentence (lines 1415–1418, "decorative", "launder") is ADR-1031's argument verbatim.
- **#15, line 1627–1629** — "which of the two is removed is the one the removal was asked about, and
  never the one the typing picks out". Asserted by the scenario at 1715, but the rule is stated only
  here, in a paragraph that otherwise argues why two indistinguishable entries are accepted.
- **#15, lines 1631–1638** — the paragraph explaining that a scenario title is *now wrong* and kept
  only because `openspec` 1.10.0 refuses a MODIFIED requirement that drops a scenario. Not a rule at
  all, and the one paragraph in the range that must not simply vanish without also dropping the
  scenario at 1678 (see §3) and its test.
- **#16, line 1770–1771** — "A stopped commitment is never moved, so that is the order it was taken
  on in for as long as nobody has moved a commitment past it". The first clause is a rule (moving
  does not apply to stopped commitments); it is dressed as a consequence.
- **#16, line 1779–1781** — "A commitment the roster has stopped keeping goes on being under the
  category it was under, so taking it up again from this list — which asks for nothing — draws it
  back in that category's group". The "asks for nothing" clause is the screen-side rule the scenario
  at 1869 tests.
- **#17, line 1916–1918** — "The two remain distinct in the model and may disagree where something
  other than this screen forms the commitment; this screen offers one date and uses it for both."
  Scopes the preceding bold rule to this screen only. Losing it makes kept-from == interval start a
  model-wide rule, which contradicts #6/#7.

Everything else in the rationale-looking prose of this range is genuinely rationale, restatement or
example.

## 2. Rationale needing a home

| Requirement | Rationale | Home |
|---|---|---|
| 1, 3 | kind is the fourth part, defaults to tick, cannot change; a record embeds the commitment by value | **ADR-1030** (lines 24, 36, 43) — already recorded, drop from spec |
| 1, 9 | a commitment carries no identifier, so two identical ones could not be told apart | **ADR-1023** (line 86) — already recorded |
| 2 | refuse a blank name rather than trim or substitute; which whitespace test | **ADR-1039** — already recorded (lines 12–19, 66) |
| 4, 5 | why a range/target refuses rather than adjusts; decimal targets | Partly **ADR-1032** (decimal numbers) and **ADR-1040/1041** (sums, blank commits). The *refuse-rather-than-adjust* argument and the "target of zero is reached before anything is added" argument are **in no ADR** — either a short new ADR or simply dropped (the SHALL/MUST NOT lines survive without it) |
| 7 | "this is what stops the product inventing a history of failures" | **ADR-1013** — already recorded |
| 8, 15 | the order is the person's; no screen invents an order; groups are the roster's | **ADR-1037** and **ADR-1038** (lines 46–58) — already recorded, both cited in the spec already |
| 9 | the offered category wins; two forms of the ask; no third | **ADR-1038** (line 80–83) — already recorded, almost word for word |
| 9 | taking up again vs refusing (the weighed-and-rejected alternative), and why a re-taken commitment keeps its place | **ADR-1023** (lines 70–87) — already recorded |
| 10 | a day once given does not move | **ADR-1023** (line 70) and **ADR-1013**, both cited |
| 11, 16 | a removed commitment costs a past date nothing; the difference lives on a screen; no list for removed; the way back | **ADR-1035** (Decision, Consequences, Alternatives 101–122) — already recorded |
| 12 | no separate save step; a change is written whole | **ADR-1017**, cross-referenced by ADR-1031 line 52 |
| 12 | a store must not write the groups (same fact twice) | **ADR-1038** line 46–52 covers "the grouping rule exists once"; the *storage* corollary is **not** in an ADR — one sentence to add there, or drop |
| 13 | each form read as the shape it has; decorative-form / laundering argument; form 0 refused | **ADR-1031** (lines 41–80) — already recorded verbatim |
| 14 | refuse rather than empty; an honest error is survivable | Nearest is **ADR-1035** ("a roster emptied by removal reads as a first launch") and **ADR-1027**; the *unreadable-store* case itself is **in no ADR**. Worth one paragraph in ADR-1031, else dropped |
| 15 | why a scenario title is now wrong and is kept | Belongs in the originating change's `design.md` § *Three scenario titles that are now wrong*, which the spec already names. Drop from the spec |
| 16 | the stopped list is not grouped (would double the structure) | **Not in any ADR**. ADR-1038's "flat list" mention is about a different rejected design. Either a line in ADR-1038 or dropped — the SHALL NOT survives alone |
| 18 | a screen may refuse what the engine accepts | **ADR-1028** — already recorded and cited |

Net: of eighteen substantial rationale blocks, **thirteen are already recorded in an ADR** and can be
deleted outright. Four would need one added paragraph in an existing ADR (1031, 1038) or can be
dropped with no loss: the refuse-rather-than-adjust argument (#4/#5), the store-must-not-write-groups
corollary (#12), the unreadable-store argument (#14), and the stopped-list-not-grouped argument
(#16). One (#15's openspec bookkeeping) belongs in `design.md`, not the spec.

## 3. Scenario duplication (pairs within this range)

- **#6, 299 / 306 / 313** — three schedule-shape fixtures of the same delegation rule. Keep 313
  (the interval one, because it also pins the start-date interaction); 299 and 306 add only a
  fixture. Keep 328 (schedule due on no date) — a distinct rule.
- **#7, 374 vs 381** — both "the floor beats the schedule", day-of-month vs every-N-days. Keep 381
  (it distinguishes the interval start date from the floor).
- **#9, 628 vs 636** — "alike in name, different schedule" vs "alike in name and schedule, different
  kept-from day". Same rule, one part swapped. Merge into one scenario with an extra `AND`; keep
  644 (trailing space, carries the exact-name rule) and 671 (kind, plus a refusal check).
- **#9, 652 vs 661** — 661 is 652 plus the place assertion, and subsumes it. Keep 661.
- **#9, 680 vs 692** — 680 (removed → taken up again, in place) vs 692 (removed → kept on every date
  again). 692's assertion is #11's scenario at 933 with removal substituted. Keep 680; drop 692.
- **#11, 924 vs 963** — identical three-commitment fixture, stopped vs removed. Keep 963 (it is the
  one that pins "removal costs a past date nothing"). Likewise **940 vs 973** — pure stop/remove
  twins; merge into one with an `AND`.
- **#12** is the worst: **1085 vs 1201**, **1096 vs 1228**, **1118 vs 1214** are stop/remove twins;
  **1170 / 1239 / 1277 / 1328** are four fixtures of "a change that cannot be kept is refused";
  **1268 / 1319 / 1373** are three fixtures of "a no-op keeps nothing at the place". Keep one twin
  from each pair, one cannot-be-kept scenario (1170, the open case) plus 1239 if the removal path
  differs in code, and one no-op scenario (1268). That is ~6 of 31 droppable on fixture grounds
  alone.
- **#13, 1474/1482 vs 1510/1519** — the same two-direction form-agreement rule for removal and for
  category. Merge each pair's two directions into one scenario with `AND` bullets (2 scenarios
  instead of 4), or keep one field's pair and fold the other into it.
- **#15, 1678 vs 1687** — the spec itself says 1678's title is wrong and that everything it asserts
  is also asserted by 1687. This is the one unambiguous drop-with-its-test in the range: drop 1678.
- **#16, 1803 vs 1848** — both assert the stopped list's order; 1848 is 1803 plus a move. Keep 1848.

Total droppable/mergeable without losing a distinct behaviour: **≈18 of 158 scenarios** (11%).

## 4. Scenario prose

**Zero** scenarios in the range contain a paragraph or sentence outside the WHEN/THEN/AND bullets —
checked programmatically over all 158.

Six scenarios instead carry rationale *inside* a bullet, which the concise shape would also cut:
line 358 ("though its schedule is due on it"), 385 ("though the interval lands on it"), 954
("because the day it is kept from is the commitment's own answer and not the roster's"), 988–990
(a 3-line explanatory clause about offsets, "passed rather than pushed"), 1665–1666 ("although
Monday 31 August 2026 is the day after…"), 1705 ("because the roster is keeping two different
commitments"). Six further bullets that *look* like rationale are real assertions and must stay —
"the error says the content is not a roster store rather than that it is from a later form" at 1460,
1479, 1487, 1516, 1524, 1586 distinguishes two causes and is the point of those tests.

## 5. Totals and recommendation

| | Now | After a concise rewrite |
|---|---|---|
| Lines (13–2085) | 2,073 | ~1,300 |
| Words total | 24,900 | ~16,700 |
| — requirement prose | 9,612 | ~3,145 (−67%) |
| — scenario words | 15,288 | ~13,550 |
| Scenarios | 158 | ~140 |

**Rewrite the range, but not uniformly.** Four requirements (8, 9, 12, 15) hold 4,163 of the 9,612
prose words — 43% — and are the only ones where the rules genuinely have to be re-extracted rather
than trimmed: in each, normative statements are braided into bolded argument paragraphs, and §1
lists eleven rules that a trim aimed at "why" sentences would take with it. The other fourteen are
mechanical trims: thirteen of the eighteen rationale blocks are already recorded in ADR-1013, 1023,
1030, 1031, 1035, 1037, 1038 and 1039, several almost word for word, so deleting them costs nothing
and removes the two-places-to-be-wrong risk the specs themselves keep arguing against. #6 can be
left as it is. Two things must be sequenced deliberately rather than swept: the #15 paragraph about
a scenario title being wrong is only removable together with the scenario at 1678 and its test
(which is exactly what the paragraph says the archive mechanics prevent doing in place), and the
four rationale pieces with no ADR home (#4/#5 refuse-rather-than-adjust, #12 store-must-not-write-
groups, #14 refuse-rather-than-empty, #16 stopped-list-not-grouped) need a paragraph added to
ADR-1031 and ADR-1038 before the prose carrying them is deleted, or an explicit decision to lose the
reasoning. Requirement 12 additionally wants splitting: 31 scenarios and a 25%-restatement prose
block that re-enumerates every roster refusal stated in #9, #10 and the move/category requirements.
