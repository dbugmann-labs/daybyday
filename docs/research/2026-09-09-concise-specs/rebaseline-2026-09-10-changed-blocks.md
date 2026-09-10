# Requirement blocks changed since `4e64641`

Generated 2026-09-10 by a block-by-block diff of `openspec/specs/*/spec.md` (heading-normalised, whitespace-insensitive). Line spans are in the current file.

## `record` — 17 requirements now, 170 scenarios

| Kind | Requirement | Lines | Prose words | Scenarios |
|---|---|---|---|---|
| MODIFIED | A store keeps a history at a place, across the app being closed and opened again | 625–977 | 958 | 29 |
| ADDED | A history carries every record of one commitment over to another | 2082–2179 | 440 | 7 |
| ADDED | A store carries every record of one commitment over to another, at its place | 2180–2236 | 255 | 4 |

## `commitment` — 41 requirements now, 406 scenarios

| Kind | Requirement | Lines | Prose words | Scenarios |
|---|---|---|---|---|
| MODIFIED | A commitment is a name, a schedule, and the day it is kept from | 13–101 | 595 | 7 |
| MODIFIED | A roster holds the commitments a person keeps, in the order they were taken on | 401–547 | 1194 | 9 |
| MODIFIED | A roster refuses a commitment it already holds | 548–799 | 1464 | 17 |
| MODIFIED | A roster store keeps a roster at a place, across the app being closed and opened again | 1046–1479 | 1123 | 35 |
| MODIFIED | A roster store that cannot be read is refused rather than emptied | 1635–1703 | 383 | 5 |
| MODIFIED | A commitments screen lists the commitments its roster keeps, in the order they were taken on | 1704–1880 | 809 | 12 |
| MODIFIED | A commitments screen defines a commitment from a name, a rhythm and the day it is kept from | 1995–2298 | 1730 | 18 |
| MODIFIED | A commitments screen tells a commitment it already keeps apart from a roster it could not write | 2426–2490 | 311 | 4 |
| MODIFIED | A commitments screen that cannot read its roster lists nothing and changes nothing | 2755–2840 | 274 | 7 |
| MODIFIED | A commitments screen holds the change it refused and why, one at a time | 2841–3066 | 826 | 16 |
| MODIFIED | What a commitments screen holds about a refused change lasts until the app is shown again or a change is kept | 3067–3273 | 475 | 17 |
| MODIFIED | A commitments screen moves a group among the groups it draws | 4683–4875 | 795 | 10 |
| ADDED | A roster answers the earliest day anything it holds has been kept from | 4876–4962 | 417 | 7 |
| ADDED | A roster changes a commitment it holds for another, in the place it holds it | 4963–5079 | 525 | 8 |
| ADDED | A roster supersedes a commitment it is keeping with another, from a day | 5080–5204 | 521 | 8 |
| ADDED | A commitments screen says what a commitment it is asked to change is made of | 5205–5303 | 531 | 6 |
| ADDED | A commitments screen changes a commitment on either of its lists | 5304–5652 | 1622 | 21 |
| ADDED | A commitments screen offers the categories in use | 5653–5737 | 467 | 5 |
| ADDED | A commitments screen refuses a range that is not a range, and a target that is not a target | 5738–5897 | 663 | 11 |
| REMOVED | A commitments screen says in words the rhythm its form is building | 0–0 | 0 | 0 |
| REMOVED | A commitments screen puts a commitment under a category, and offers the categories in use | 0–0 | 0 | 0 |

## `day-screen` — 48 requirements now, 399 scenarios

| Kind | Requirement | Lines | Prose words | Scenarios |
|---|---|---|---|---|
| MODIFIED | A day screen moves the day it is showing one calendar day either way | 873–982 | 562 | 8 |
| MODIFIED | A day screen goes straight back to the today it was handed | 983–1046 | 253 | 5 |
| MODIFIED | A move with nowhere to go leaves a day screen exactly as it was | 1047–1121 | 656 | 3 |
| MODIFIED | A day screen re-reads its day and its record when the app is shown again | 1425–1613 | 584 | 15 |
| MODIFIED | A day screen that cannot read its roster draws the day and no rows | 1897–1976 | 399 | 5 |
| MODIFIED | What a day screen tells on a row lasts until the app is shown again, a change is kept, or the day it is showing changes | 2208–2450 | 804 | 19 |
| MODIFIED | A day screen reads its roster again when it is returned to | 2640–2768 | 511 | 10 |
| MODIFIED | A day screen says whether it offers the way back to today | 4548–4677 | 576 | 10 |
| ADDED | A day screen says the reach of its day picker | 4777–4932 | 874 | 10 |
| ADDED | A day screen shows a day picked on its day picker | 4933–5079 | 547 | 11 |
| ADDED | A day view says its day as a weekday | 5080–5139 | 371 | 6 |
| ADDED | A day screen says the day it is showing | 5140–5237 | 307 | 10 |
| ADDED | A day screen says the day view of the day before the one it is showing and of the day after | 5238–5452 | 746 | 16 |
| ADDED | A day screen says no day view before the first supported date and none after the last | 5453–5498 | 219 | 3 |
| ADDED | A day screen makes every change on the day it is showing and none on a day either side of it | 5499–5563 | 287 | 4 |
| REMOVED | A day view says its day as a weekday and a date, and says Today on the day it is asked as of | 0–0 | 0 | 0 |
| REMOVED | A day screen says the day it is showing, as of the day it was handed | 0–0 | 0 | 0 |

Totals: ADDED 16, MODIFIED 21, REMOVED 4
