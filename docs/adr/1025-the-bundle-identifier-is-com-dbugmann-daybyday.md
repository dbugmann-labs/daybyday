# 1025. The app's bundle identifier is `com.dbugmann.daybyday`

- Status: accepted — the owner's decision on 2026-09-03, taken by the chore that first puts the app
  on a physical phone, and accepted by the chore PR that carries this record
- Date: 2026-09-03
- Deciders: Diego Bugmann

## Context

ADR-1019 created the app target, named it `DayByDay`, and deliberately left the bundle identifier
undecided — the shell it created decides nothing, and a placeholder was enough to launch in a
simulator. `docs/open-questions.md` recorded the gap and named its trigger exactly: *"forced by the
first Story that puts the app on a real phone rather than a simulator."*

That trigger has now fired, from a direction the entry did not anticipate. It is not a Story. The
owner is taking a week of real use on their own phone before any further specification, and
installing on a device is where `com.example.DayByDay` stops being harmless: a placeholder becomes
permanent by being installed once.

**Why it cannot wait for the Story that would otherwise own it.** `DayScreen.recordPlace` puts the
record at `<Application Support>/DayByDay/record.json`, and on iOS that directory sits inside a
container the system keys to the bundle identifier. Changing the identifier after an install does
not move the record or warn about it — it hands the app a different, empty container, and the
ticks from before are still on the device with nothing able to read them. For a product whose whole
promise is a record that survives (`CONTEXT.md` § *Product principles*, **restore, not sync**),
that is the one failure the process exists to prevent, and it is silent.

## Decision

**`com.dbugmann.daybyday`.** Reverse-DNS on `dbugmann`, which is the name the GitHub organisation
`dbugmann-labs` already carries, so the prefix stays true whether or not a domain is ever bought.
Lowercase throughout, unlike the target name, because the identifier is matched case-sensitively by
the system and mixed case in a reverse-DNS string is a source of typos rather than of meaning.

**It is fixed from the first install on a physical device**, which is this chore. Changing it later
is not a rename: it is an abandoned record, and it needs a migration that reads the old container,
which nothing here has. Whoever proposes a change writes that migration first.

## Consequences

- `PRODUCT_BUNDLE_IDENTIFIER` is `com.dbugmann.daybyday` in both build configurations, and the
  `simctl` commands in `docs/running-the-app.md` address the app by it.
- **`DEVELOPMENT_TEAM` is still unset**, and this ADR does not settle signing. There was no
  codesigning identity on the machine when it was written; the owner adds an Apple ID in the Xcode
  GUI and commits what automatic signing writes. `docs/running-the-app.md` § *On your own phone*.
- A free Apple ID expires the build after seven days. The record survives that, because it lives in
  the container rather than in the build — which is the same property this ADR is protecting.
- The App Store is not in scope and this identifier does not commit the product to it. Nothing here
  reserves the name with Apple; if that is ever wanted, it is a separate decision and this
  identifier is what it would reserve.
