# 1054. A copy is the values, in a form of its own, and it knows when it was made

- Status: accepted — three answers by the owner at the Story grill of `make-a-copy` (#266) on
  2026-09-15, every one on the recommendation; this record is written by that Story and approved at
  its G4
- Date: 2026-09-15
- Deciders: Diego Bugmann

## Context

`FEAT: restore` (#264) is four Stories: the copy a person asks for, putting one back (#267), the
last-copy line (#268) and the copy place the app writes at on its own (#269). All four read one
file, and the first of them decides what is in it. A fifth, `take-out-an-unreadable-store` (#270),
deliberately does the opposite of what is decided here.

Three things about that file were open, and none of them is cheap to change once a copy is sitting
in somebody's Files: **what it holds**, **what it says about itself**, and **what the phone calls
it**. The three stores on disk are hand-written versioned JSON at three forms that move
independently, a change writes the record place before the roster place and can leave a save in
progress between them (ADR-1049), and nothing in the app has ever recorded a time of day — the only
clock read is `today()`, at the edge (ADR-1004).

## Decision

**A copy is the three values as the app reads them, in a form of its own, carrying the moment it
was made, in a file of DayByDay's own kind.**

- **The values, not the files.** A copy is formed by reading the record, the roster and the
  one-offs the way the app reads them when it opens: a save in progress undone first, each store
  read up into the shape the engine holds, then written out in the form that store writes now. A
  copy of an earlier-form store is a current-form copy, and a torn save never leaves the phone.
- **Whole or not at all.** A store that cannot be read refuses the copy and the refusal names which
  store. A record without its roster is numbers with no names, so there is no partial copy; the way
  an unreadable file leaves the phone is #270's take-out, which is the bytes exactly as they lie.
- **It carries its own form.** One number, independent of the three stores' forms, so a later
  version can tell which shape it is reading before it reads it — the same envelope-first rule each
  store already follows.
- **It knows when it was made.** A copy carries a **moment** — a calendar date, an hour and a
  minute — handed in at the edge as `today()` is. It is the first timestamp in the model, it lives
  in a copy and never in a store, and it is what lets #267 say which copy it is putting back and
  what the file is named for. No name and no device: a name is whoever holds the file's to change.
- **Its own kind, `.daybyday`.** Declared by the app target as an exported type conforming to
  `public.json`. Files then shows a copy as DayByDay's, and #267's picker can offer copies alone —
  a plain `.json` would make it offer every JSON on the phone.

## Consequences

- Every later `restore` Story reads this form rather than deciding one, and a change to it is a
  change to a file already on people's phones: the form number is the only lane for that.
- A copy is bigger and slower to write than the three files copied, and it needs every store to be
  readable. Both were accepted deliberately: a copy exists to be put back.
- The moment brings a time of day into the model for the first time. It is confined to a copy;
  no store gains one, and the kit still reads no clock and knows no time zone.
- A copy of three empty stores is a copy, and putting it back empties the phone. That is what it
  says on the tin, and the delta gives it no special case.
