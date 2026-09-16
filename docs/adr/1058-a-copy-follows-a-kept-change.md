# 1058. A copy follows a change the person kept, and never refuses one

- Status: accepted — written while the delta of `copy-on-every-change` (#268) was being written, on
  the grill's settled answers 4, 5 and 10; approved at that Story's G4
- Date: 2026-09-16
- Deciders: Diego Bugmann

## Context

The **copy place** is a folder picked once, and the app writes a mirror there on its own. A mirror
is worth having only if it is at most one change behind, so something has to decide which of the
app's writes earns a copy and what happens when the copy cannot be made.

There is no single choke point to hang that off. Each of the three stores has its own private
writer, and a restore in progress and a save in progress write raw bytes beside them. Some of those
writes are not the person's at all: undoing a torn save or a torn restore when the app opens,
carrying an orphaned record back to its one possible source, and taking on the day-one commitments
where the roster place holds nothing. And a folder outside the app can be gone, unwritable, or have
had its access taken away at any moment, which a store under Application Support never is.

## Decision

**A copy at the copy place follows a change the person kept, and nothing else. It is a consequence
of that change and never a condition of it.**

- **A kept change is every write the app makes for a change the person made**, from either screen:
  a tick, a number, a note, a total, a one-off added, renamed, removed or ticked, a commitment
  defined, changed, restarted, stopped, removed, taken up again or moved, and a restore confirmed.
  One change writes exactly one copy, however many places it reached.
- **A write the person did not ask for writes no copy.** A repair puts back what the copy already
  mirrors, so a copy taken from one is a copy the person cannot account for.
- **The change is kept first and answered as it would be with no copy place at all.** A copy that
  cannot be made refuses nothing, and the caller cannot tell the difference.
- **A failure is reported, not raised.** The copy place holds why and the moment it first could
  not, and the commitments screen says both beside the last copy that succeeded. The next kept
  change tries again on its own; nothing retries on a timer.
- **Only an attempt finds out.** Neither screen reads the folder in order to draw the line.

## Consequences

- Every screen that keeps a change calls one thing after it, at every site that keeps one. The
  delta names all twenty sites in a single requirement so a missed one fails a scenario.
- The mirror can be arbitrarily stale while the person makes no change, and the line says since when
  rather than pretending otherwise.
- A folder written on every tick, one file overwritten whole. Nothing batches or delays.
- Rejected: hanging the copy off the three stores' writers, which would mirror an open-time repair
  and copy twice for a change that writes two places. Also rejected: refusing a change whose copy
  failed, which would make an unreachable folder stop the app working.
