# Survey A — `openspec/specs/day-screen/spec.md`, requirements 1–22 (lines 12–2138)

Range: `### Requirement:` #1 (line 12) through #22 (lines 2059–2138). Stops before
`A day screen tells on the row that was tapped that a change could not be kept` (line 2139).
Scenario format is uniform: `- **WHEN** / **THEN** / **AND**` bullets, no exceptions in this range.

## Per-requirement table

Prose split = (a) normative / (b) rationale, alternatives, "why" / (c) cross-refs, exclusions,
restatements of other requirements.

| # | Title (short) | Lines | Prose w | Scen | a/b/c | Verdict | After |
|---|---|---|---|---|---|---|---|
| 1 | day view = commitments due, each with kept | 12–152 | 421 | 13 | 60/28/12 | trim | 150 |
| 2 | row offers the tick, refuses a day not arrived | 153–316 | 794 | 12 | 38/47/15 | rewrite | 150 |
| 3 | a row is a commitment's line on a date | 317–513 | 1149 | 14 | 38/47/15 | rewrite | 170* |
| 4 | day view is in the order handed | 514–566 | 210 | 5 | 65/30/5 | trim | 110 |
| 5 | a day view is a value | 567–666 | 558 | 7 | 48/34/18 | rewrite | 140 |
| 6 | day view moves a day either way | 667–754 | 362 | 6 | 60/28/12 | trim | 120 |
| 7 | a move is one calendar day | 755–814 | 201 | 5 | 72/23/5 | trim | 130 |
| 8 | no day before 1583, none after 9999 | 815–872 | 205 | 4 | 58/32/10 | trim | 110 |
| 9 | day screen moves one day either way | 873–982 | 562 | 8 | 55/28/17 | rewrite | 150 |
| 10 | day screen goes straight back to today | 983–1046 | 253 | 5 | 62/22/16 | trim | 120 |
| 11 | a move with nowhere to go leaves it as it was | 1047–1109 | 450 | 3 | 38/44/18 | rewrite | 110 |
| 12 | day screen holds the day view of the day handed | 1110–1178 | 499 | 4 | 58/25/17 | rewrite | 150 |
| 13 | screen makes/takes back the tick, keeps first | 1179–1288 | 433 | 9 | 65/20/15 | trim | 150 |
| 14 | record place survives the app closing | 1289–1322 | 177 | 3 | 70/25/5 | trim | 110 |
| 15 | unreadable record: draw the day, keep nothing | 1323–1412 | 414 | 7 | 55/35/10 | trim | 130 |
| 16 | re-read day and record when app is shown again | 1413–1548 | 584 | 10 | 60/25/15 | trim | 150 |
| 17 | day title: weekday, date, "Today" | 1549–1692 | 351 | 15 | 68/22/10 | trim | 140 |
| 18 | screen says the day it is showing | 1693–1775 | 293 | 8 | 58/25/17 | trim | 110 |
| 19 | screen draws what its roster had not stopped | 1776–1911 | 727 | 8 | 45/35/20 | rewrite | 160 |
| 20 | screen takes on handed commitments on empty roster | 1912–2015 | 405 | 7 | 60/30/10 | trim | 140 |
| 21 | roster place, beside the record | 2016–2058 | 227 | 4 | 62/28/10 | trim | 110 |
| 22 | unreadable roster: draw the day, no rows | 2059–2138 | 399 | 5 | 58/30/12 | trim | 140 |

\* #3 cannot reach 150 honestly: it carries row identity, what a row holds per kind, what a row
gives back, and the rhythm rule. The concise shape wants it split into two requirements
(identity+contents, and what a row gives back incl. the rhythm), ~110 words each.

## 1. Rules at risk (sentences a naive trim would lose)

**Req 1.** L21–23 "Whether a commitment is due on the date is the `commitment` capability's answer,
asked of the commitment itself rather than of the schedule it carries" — the only statement of the
rule tested by *a commitment whose schedule is due but which is kept from a later day has no row*
(L90). L32 "the day view SHALL NOT count, total or rank anything". L37 "a history is asked about
each commitment in turn and is never enumerated" — mechanism behind L98's scenario and req 5's
identity rule.

**Req 2.** L162–165 "A row asked as of its own date SHALL offer the tick … and so SHALL a row whose
date is earlier, however much earlier" (scenarios L205, L249). L170–172 "The row itself is unchanged
and stays in the day view" — scenario L304 asserts the row exists and offers nothing. L179–181 "a
row asked twice as of two different days answers each on its own" (scenario L266). L185–187 "Adding
it to the history … makes a day view formed again … say the row is kept; taking it back makes a day
view formed again say it is not" (scenarios L214, L222) — reads as gloss on the SHALL before it, but
it is the round-trip contract.

**Req 3.** L329–332 "Two rows of one number commitment on one date holding different numbers are
therefore different rows … different notes are different rows" (L453, L471) — buried in the
paragraph opening "The third of the three is one thing rather than three". L337–338 "two rows … whose
days hold different additions summing alike SHALL be **the same row**" (L505). L350–351 "A row of any
kind but a total holds a sum of **zero**, and holds it as a sum rather than as nothing at all" — no
scenario, implementations depend on it. L369–370 "Each is given out only inside the entry a row
offers" — the rule that keeps number/note/sum off a row's face; sits between two rationale
sentences. L377–378 "The words SHALL be the ones the `schedule` capability says … and this capability
SHALL compose none of them". L390–391 "the words are read off the commitment the row already holds,
so two rows agreeing on the three things above agree on the rhythm they say" — without it, adding
the rhythm reads as a fourth identity part and L394–410 break.

**Req 4.** L519 "it MUST NOT move a row that has been ticked" (L544) — tail of a sentence whose rest
is rationale. L526 "handing the same commitment to a day view twice SHALL give two rows" (L559),
inside the deduplication argument.

**Req 5.** L578–581 "Two day views holding the same rows in the same order under different groupings
are two day views" (L648) — inside a bold, rationale-styled paragraph. **L589–590 "a group none of
whose commitments is due on the date produces no group, so a day view handed it is the same day view
as one that was not"** (L657) — the paragraph explicitly frames this as following from other
requirements, and req 19 L1788 defers the rule *back here* ("that is the day view's own rule"), so
trimming both leaves the rule stated nowhere. Sharpest risk in the range. L599–600 "Ticking a history
after a day view was formed from it MUST NOT change that day view" (L639).

**Req 6.** L678–679 "The commitments and the history a move is handed MAY be different ones, and the
day view given back SHALL then be of those" (L725). L687–688 "a row offers no tick when its date is
later than the day it is asked as of" — labelled "not restated here" yet scenario L735 asserts it at
this level. L690–691 "Moving SHALL leave the day view moved from unchanged" (L744).

**Req 8.** L822 "Nothing SHALL be given rather than the same day view handed back" — first sentence
of an otherwise droppable paragraph. L828–829 "the same day view moved the other way SHALL move
normally, and every day view of any other date SHALL move both ways" (L850, L862).

**Req 9.** L888–889 "Every question a day screen asks as of a day SHALL still be asked as of that
today — which tick a row offers, and whether the day it says is said as today" — reqs 13 and 18 both
lean on it. L901–903 "It SHALL form the day view from the record as the screen last read it — the
reading done when the app was shown, together with every change kept on the screen since" (L956;
req 19 refers back). L906–907 "a day screen that is not keeping one of them SHALL move like any other
and go on saying so" (L974).

**Req 10.** L988–990 "it reads neither the record nor the roster again, it leaves what the screen
says about either of them alone, and it moves the day being shown and never the today" (L1038) —
framed as "a move like any other", i.e. exactly what a restatement-trim deletes. L992 "The day it
goes back to SHALL be the today the screen was last handed" (L1030).

**Req 11.** L1054–1056 "The screen SHALL go on showing the day it was showing, holding the day view
it was holding and saying what it was saying about its record, and it MUST NOT report that the move
had nowhere to go" (L1080, L1090). L1061 "A day screen SHALL NOT say whether it can move either way"
— a negative rule with no scenario; the bold paragraph after it is deletable but this sentence is
not. L1067 "A day screen does say whether it offers the way back to today" is a *later*
requirement's rule appearing here — drop it as a cross-reference, not as a rule.

**Req 12.** L1115–1116 "The commitments it is opened from are the ones it takes on when its roster
holds nothing at all, and are not a list it draws" — the hinge req 20 depends on. L1132–1134 "it
SHALL begin as that same today, and it SHALL be the one a move changes … a day screen MUST NOT keep
only one of them" — reqs 9, 13, 16, 18 all rest on this. L1138–1141 "SHALL hold the day it is showing
until it is moved or the app is shown again … The today SHALL be replaced only when the app is shown
again" (L929, L1159, req 16).

**Req 13.** L1186–1187 "asked as of the today the screen was handed and never as of the day it is
showing" (L1280). L1199–1201 "A change that could not be kept SHALL be refused, SHALL be reported to
the caller rather than passed over, and SHALL leave the day view exactly as it was" (L1249; req 23
builds on the reporting). L1204–1205 "Making one or taking one back MUST NOT write to the roster's
place, and MUST NOT change what the screen says about its roster" (scenario L1858, in req 19).

**Req 14/21.** L1295 / L2022 "and it SHALL be one file"; L2030 "it SHALL NOT be the place the day
screen keeps its record at" (scenario L2052) — each ends a sentence whose opening is justification.

**Req 15.** L1330–1332 "A tick made on it MUST NOT be shown as kept, MUST NOT be held in memory to
be kept later, and MUST NOT be kept anywhere else" (L1388). L1335–1338 "It SHALL leave what is at
the place exactly as it was … and every way a store can refuse to open SHALL be answered in that one
way" — the sentence continues "That is the `record` capability's own refusal carried through rather
than a second rule", which invites deleting the whole sentence. L1343 "It MUST NOT tell any other
reason apart, and MUST NOT say a record was written by a later version when it was refused for any
other reason."

**Req 16.** L1427 "That comparison SHALL be made against the today the screen held before it was
told, and against nothing kept for the purpose" (L1652, L1663). L1439–1441 "What it says about the
record SHALL be formed again … the reason included". **L1448–1449 "A roster read again that holds
nothing at all SHALL have the commitments the screen was handed taken on into it"** — the only
statement of that timing rule, and scenario L1995 (req 20) tests it. L1452–1453 "Nothing else of a
day screen SHALL survive being shown again: the commitments it was handed, the two places … and the
day it is showing are all it carries across."

**Req 17.** L1553 "it MUST NOT depend on the rows the day view holds" (L1636). L1565–1566 "The names
of the weekdays and of the months SHALL be this capability's own — the English names, fixed here —
and MUST NOT be taken from the device's language, region, locale or calendar preferences."

**Req 18.** L1700–1701 "The date it says SHALL follow the day the screen is showing, and the word
'Today' SHALL follow the today" (L1741, L1769). L1706–1708 "it says the same day until it is moved or
the app is shown again — a tick made on it MUST NOT change what it says the day is" (L1755).

**Req 19.** L1791–1793 the six moments — "when the screen is opened, when it is moved, when it is
sent back to today, when the app is shown again, when the screen is returned to, and when a tick is
made" — an enumerated rule reqs 9, 10, 13, 16 and 26 all rely on. L1797–1801 "A commitment the roster
has removed has exactly the same rows … a day screen SHALL NOT tell the two apart in any way — not
in whether the row is drawn, not in what the row says, not in what the row offers, and not in the
group it is drawn in" (L1867). L1806–1808 "The roster a day screen asks is the one read at that place
when the app was last shown or the screen was last returned to, whichever happened later, together
with any change the screen has kept since" (L1847) — "whichever happened later" is load-bearing for
req 26.

**Req 20.** L1919–1921 "A roster every one of whose commitments has been stopped **or removed** still
holds them, so it is not a roster holding nothing and MUST NOT be written over" (L1965, L2004).
L1936–1939 the two failure rules (unreadable roster → take nothing on, leave the place; readable but
unkeepable → roster holding nothing, no rows, says it is not keeping a roster) (L1976, L1985).

**Req 22.** L2066 "not written over with the commitments it was handed" — the intersection with
req 20. L2078–2081 "What a day screen says about its roster SHALL be read off the roster's place and
what it says about its record off the record's, and neither SHALL be read off the other. A day
screen may be keeping one and not the other, in either combination" (L2117, L2127).

## 2. Rationale needing a home

Already recorded — delete from the spec:
- Answering *a date* rather than the present moment; the 1583/9999 ends (reqs 1, 2, 6, 7, 8, 11, 12,
  17) → **ADR-1004**.
- The past being writable back to the day a commitment is kept from (req 2) → **ADR-1013**; the
  kept-until side (req 19) → **ADR-1023**.
- A non-tick kind offering nothing (req 2, L167–175) → **ADR-1030**.
- Weekly quota due every day (req 2, scenario L295) → **ADR-1015**.
- A total row holding the sum and not the additions (req 3, L337–344) → **ADR-1040**, with the
  take-back argument in **ADR-1033**.
- Rhythm words being the `schedule` capability's (req 3, L377–381) → **ADR-1034**.
- Order being the person's, so the day view invents none (req 4, L520–522) → **ADR-1037**.
- Groups being the roster's (reqs 5 L578–581, 19 L1784–1789, L1818–1826) → **ADR-1038**.
- Screen-vs-value refusal asymmetry (reqs 8 L822–824, 11 L1056–1059) → **ADR-1028**.
- Chevrons vs the way back to today (req 11, L1066–1073, ~110 words) → `CONTEXT.md` § *Offered*
  (line 567) plus **ADR-1042/1043/1045**. Pure boundary-drawing; delete outright.
- Keeping the day you moved to; the phone-down-overnight story (reqs 12, 16 L1420–1425) →
  **ADR-1026**.
- `Application Support`, not caches or temp, one file (reqs 14 L1297–1300, 21 L2024–2027 — the same
  paragraph twice) → **ADR-1017**.
- Later-version vs merely-unreadable (req 15 L1344–1350, ~90 words; req 22 L2074–2076) →
  **ADR-1021** (req 22 already cites it; req 15 restates the argument in full). Store refusal shapes
  → **ADR-1031**, cause a person can act on → **ADR-1036**.
- Day one written into an empty roster; stopped-or-removed still holds (req 20 L1925–1929) →
  **ADR-1027** and **ADR-1035**, both already cited in the prose.

No ADR found — needs one, or drop:
- "Every row SHALL say its rhythm … not only where two rows would otherwise read alike" (req 3,
  L383–388). ADR-1034 covers the *words*, not the decision to show them always. Keep the SHALL,
  and either write an ADR or drop the argument.
- A day view being a value/snapshot rather than a window (req 5, L583–586, L599–602). Nothing under
  `docs/adr/` records it; `design.md` material at most. Keep the two SHALLs, drop the argument.
- "A row that could be untapped but not tapped would be two rules where the product has one"
  (req 2, L195–196) — droppable.
- "A note is the one record long enough that drawing it in a list would change what the list is
  for" (req 3, L373–375) — the strongest un-homed product argument in the range; worth one ADR
  paragraph if it is wanted at all, otherwise drop.

## 3. Scenario duplication (same behaviour, fixture change only)

- **Req 2**: L241 *a row for a date later … offers no tick* vs **L285** *every row of a day view
  whose date has not arrived offers no tick* — same refusal, more rows. Keep L241 (and L258, which
  adds the kept-state rule); drop L285.
- **Req 3**: L462 *…same number are the same row* and L480 *…same note are the same row* are L394
  (*same row when all three agree*) with a number/note fixture. Keep L394, L453, L471, L488, L497,
  L505; drop L462 and L480.
- **Req 3**: L428 *says its rhythm whether or not kept* and L437 *a row for a day that has not
  arrived says its rhythm* are both L418 with a fixture change; the "always" rule justifies keeping
  one. Keep L437 (it also covers offering nothing); drop L428.
- **Req 17**: L1585 *a day before … says the date and not Today* vs L1591 *a day after … says the
  date and not Today* — one rule, two directions. Merge into one scenario with two THENs.
- **Req 19**: L1867 *a stopped commitment* vs L1897 *a removed commitment* — identical assertions,
  stopped→removed. Keep both: the indistinguishability is itself the rule (ADR-1035).
- **Req 20**: L1965 *all stopped takes nothing on* vs L2004 *all removed takes nothing on* — same
  pair, same argument. Keep both, same reason.
- **Reqs 14/21** (3+3 place scenarios) and **reqs 15/22** (record/roster refusal sets) are structural
  twins across requirements, not within one. Keep both; state the shared *prose* once.

## 4. Scenario prose

**0 of 162 scenarios** contain prose outside the WHEN/THEN/AND bullets. Every scenario in the range
is bullets-only (continuation lines are wrapped bullets). Nothing to do here.

## 5. Totals and recommendation

| | Now | After |
|---|---|---|
| Lines (12–2138) | 2127 | ~1750 |
| Words total | 26,645 | ~19,300 |
| — requirement prose | 9,674 | ~2,950 (−70%) |
| — scenarios | 16,601 | ~16,000 (−4 scenarios) |
| — headings | 370 | 370 |
| Scenarios | 162 | 157 (4 dropped, 1 merge) |

**Rewrite the whole range, requirement by requirement, in two passes.** The scenarios are in good
shape — bullets only, titles usable as-is, and only four are genuine fixture-duplicates — so the
entire saving is in the prose, where roughly 3,400 words are rationale that six or more ADRs already
record (1004, 1013, 1017, 1021, 1026, 1027, 1028, 1030, 1033, 1034, 1035, 1037, 1038) and another
~1,500 are cross-references and restatements of neighbouring requirements. The danger is that this
spec habitually states a rule *inside* its own justification: reqs 2, 3, 5, 9, 11, 12 and 19 each
hide at least one tested SHALL in a paragraph that opens as an argument, and req 5 L589 / req 19
L1788 point the same rule at each other, so a two-agent parallel trim would delete it twice. Do the
seven `rewrite` requirements (2, 3, 5, 9, 11, 12, 19 — 4,529 prose words, 47% of the range) by
extracting rules to a checklist against the scenario titles first, then trimming; the fifteen `trim`
requirements can be cut paragraph-wise, keeping every sentence listed in §1. Two structural fixes
belong in the same pass: **five scenarios at L1641–1692 sit under req 17 (the day-title requirement)
but test req 16's "app is shown again" behaviour** and should move; and the `Application Support`
justification paragraph is duplicated verbatim between reqs 14 and 21.
