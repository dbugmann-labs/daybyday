## Why

A roster kept before a commitment had an identity is folded once, as it is read, and each era the
fold makes is left where the stored roster held the entry it came from. Where one name's entries
were interleaved with another's, that is a roster holding one commitment's eras with another
commitment's entry between them — which this app refuses to read. Nothing shows until the next
roster write puts that shape on disk; the opening after it reads back no commitments at all.

## What Changes

- The eras a fold makes stand together, newest first, each immediately behind the era it gave way
  to, wherever the stored roster held them.
- An era the stored roster held in front of the commitment it belongs to moves behind it, so a
  folded commitment is never read back as stopped and kept at once.
- The commitments a fold makes keep the order the stored roster held the entry each was made from.
- The roster a fold answers with is one this app writes and reads back as it stands.
- What cannot be read as a roster store now names one commitment's eras with another commitment's
  entry standing between them, which the store already refuses.
- A roster kept before a commitment had an identity holding one era twice — an entry that chains to
  one alike in every part — is refused rather than folded into a roster that cannot be read back.
- No screen changes, and nothing at any place is written differently but the order of the entries
  within it.

## Capabilities

### New Capabilities

None — `commitment` already exists.

### Modified Capabilities

- `commitment`: ADDED one requirement — where a fold stands a commitment's eras, the order the
  commitments it makes keep, and that its roster is one this app reads back. MODIFIED one — what
  cannot be read as a roster store names a commitment's eras split apart by another commitment's
  entry, and refuses one era held twice in a roster kept before identities.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/RosterDocument.swift` — how the fold assembles the roster it
  answers with, and the era it refuses
- `src/DayByDayKit/Tests/DayByDayKitTests/RosterStoreTests.swift`
