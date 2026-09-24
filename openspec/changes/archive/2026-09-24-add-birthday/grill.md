# Grill — add-birthday

*7 questions over 2 rounds, 2026-09-24, two fact agents, no fact sent to the owner. The Feature
grill of the same day settled the boundary — twelve questions, in `docs/backlog.md` § Decided
(2026-09-24, B-059) and `CONTEXT.md` **Birthday** — and this file does not repeat it.*

## Settled

1. **The store holds ticks only.** Whether birthdays are on is the phone's own setting, never
   in the store and never in a copy. *A new phone starts with birthdays off, and a restore never
   causes a permission prompt.*
2. **Several birthdays on one day stand as the calendar hands them.** *The app orders nothing of
   its own, as the day view orders nothing.*
3. **A birthday's words are the calendar's own title for that day's occurrence, verbatim** —
   "Kate Bell's 48th Birthday", or without the ordinal where the calendar has no year. *Nothing
   is parsed out and nothing composed; the name-and-age the owner chose at G1 is what the
   calendar already says, in the phone's language.*
4. **The tick is keyed to the contact's identifier and the day the birthday falls on.** Apple
   documents that identifier as unique on the current device only, so a copy restored on a new
   phone may hold ticks that match nothing there; the spec says so plainly rather than adding a
   second key. *One key, the one that follows renames and deletions as the owner chose at G1.
   Hard to reverse and surprising: an ADR records it.*
5. **A tick whose birthday the calendar no longer hands is kept, unseen.** *Nothing here deletes
   a record but a deliberate act, and a contact put back brings its ticked rows back. The store
   never asks the calendar what to hold.*
6. **No walk and no layout.** The Story stays behind the seam: no diff reaches `src/DayByDay/`.
7. **A store that cannot be read is refused rather than emptied**, as the one-off store is —
   settled by precedent, not asked.

## Facts carried to spec-author

- Measured on the simulator (iOS 26.5 runtime, iOS 27 SDK), not documented by Apple: an
  occurrence from `events(matching:)` on the Birthdays calendar is all-day, yearly, titled with
  the age; the master event reached by `event(withIdentifier:)` carries the birth year in its
  start date; `birthdayContactIdentifier` is readable with calendar access alone. A contact with
  no birth year is a case nobody has measured; Contacts uses year 1604 for it on its side.
- `CNContact.identifier` is documented as uniquely identifying the contact "on the current
  device" only. `calendarItemExternalIdentifier` for a birthday is `gregorian/<contactId>` and
  inherits the same limit.
- `xcrun simctl privacy grant calendar <bundle>` gives `.fullAccess` without a prompt; the
  simulators ship a Birthdays calendar with four seeded contacts. That is Story 2's and 3's
  walk, not this one's.
- The Kit imports Foundation only. The day's birthdays must be *handed* to the seam as values by
  the shell, as the day view is handed its commitments, so the seam is drivable without
  EventKit; the EventKit adapter is Story 2's or 3's shell work.
- Precedent: `add-one-off` (`openspec/changes/archive/2026-09-14-add-one-off/`) — `OneOff`,
  `OneOffs`, `OneOffStore`, `OneOffStoreError`; document version 1; migration "None — additive";
  ADR-1052 took the next free number. The highest ADR on main is 1061.
- `restore`'s spec says "the three places" in four requirements and seventeen scenarios; that is
  #329's to modify, not this Story's.

## Terms landed in CONTEXT.md

None new here. **Birthday** landed at the Feature grill. If the delta names the store's place, the
term is *birthday place*, by analogy with **one-off place**, and `spec-author` lands it.

## Left open

None. Every question the frontier raised was answered; the one fact that could not be verified —
whether a contact identifier survives a new phone — is settled by decision 4 rather than left
to find.
