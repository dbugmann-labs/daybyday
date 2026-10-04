## Why

Happenings and their occurrences are kept in a fifth store that nothing protecting the other four
reaches: a copy leaves them behind, a restore leaves the phone's in place, a take-out does not hand
their file out, and a happening change writes no copy at the copy place. A phone restored from a
copy loses every happening. This Story carries the fifth store as the other four are carried.

## What Changes

- A copy holds every happening, stopped or not, and every occurrence.
- Unreadable or later-version happenings refuse a copy whole, named last, and stop the copy place.
- A copy made before copies held happenings holds none; one whose happenings do not fit together is damaged.
- A restore puts the copy's happenings back, whole or not at all, and counts happenings and stopped ones.
- A commitments screen that restored a copy lists the copy's happenings and awaits nothing about one.
- A torn restore is undone at the happening place too.
- A copy place given no happening place reads it beside its record place.
- Every happening or occurrence change a person keeps writes a copy at the copy place.
- A take-out hands out the happenings' file, is offered while they cannot be read, and names them.
- A day screen that cannot read its happenings says a copy can be restored.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `restore`: ADDED — a copy's happenings, where the copy place keeps them, reading them from a copy,
  what a restore says of them, a restore of them, a torn restore at the happening place, and a
  happening change's copy. RENAMED and MODIFIED — what a take-out is. MODIFIED — the take-out's
  offer, its answer and its refusal; the day screen's restore line.
- `happening`: MODIFIED — a happening made, renamed, stopped, resumed or deleted no longer writes
  no copy.
- `day-screen`: MODIFIED — an occurrence noted, changed or taken back no longer writes no copy; a
  day screen that cannot read its happenings no longer withholds the restore line.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/` — the copy and its written form, the copy place, the
  restore in progress, the happening store, the commitments screen and the day screen.
- `src/DayByDayKit/Tests/DayByDayKitTests/` — new tests; four carried tests retitled with their
  copy assertions dropped, one carried assertion dropped, and two exhaustive switches given a case.
- `src/DayByDay/DayByDay/SettingsView.swift` — the happenings' line wherever a store is named, and
  the happening counts on the restore sheet.
- `CONTEXT.md` — *Happening place*.
