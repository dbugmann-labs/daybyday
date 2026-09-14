## Why

A commitment on a weekly quota is due every day (ADR-1015), so its row says the same thing on the
seventh night as on the first and a person cannot tell from the day screen how much of the week is
already behind them. ADR-1015 left that to "a capability that can see ticks", and left where a week
begins undecided until the first Story that counts within one. This is that Story: the history
gains one answer, and `say-standing-in-quota-row` (#236) is blocked on it.

## What Changes

- A history answers a commitment's **standing**: how many days of one week it was kept, through a date.
- The week is Monday through the following Sunday, on every phone, whatever its calendar setting.
- The count runs from that Monday through the date it is asked of, inclusive, and no day after it.
- The answer is by date and never by when a record was entered.
- The count is never capped: a fourth kept day against a quota of three is a standing of four.
- A day counts exactly where the history already answers that commitment kept on it, whatever the
  kind of record that keeps it.
- Every commitment is answered, whatever its schedule; the answer consults no schedule.
- A week reaching past either end of the supported calendar counts the days of it that exist.
- Nothing happens when a week turns: no miss is recorded, nothing carries over, the next starts at zero.
- ADR-1050 records the three decisions ADR-1015 deferred; ADR-1015 is amended to cite it.
- No change to what is stored, to any screen, or to any other answer a history gives.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `record`: ADDED — a history answers a commitment's standing in the week of a calendar date.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/History.swift` — the new answer and the week it is counted over.
- `src/DayByDayKit/Tests/DayByDayKitTests/RecordTests.swift` — the acceptance tests.
- `docs/adr/1050-a-week-is-monday-to-sunday-and-the-history-counts-it.md` — new.
- `docs/adr/1015-a-weekly-quota-is-due-every-day.md` — amended where it deferred the question.
- No store, no document, no screen and no shell file is touched.
