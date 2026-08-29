# 1001. DayByDay is built in Swift and SwiftUI, native to iPhone

- Status: accepted
- Date: 2026-08-29
- Deciders: Diego Bugmann

## Context

`EPIC: Daily commitments` (#1) defines DayByDay as an iPhone app: define the commitments you
owe yourself and the rhythm each one runs on, then open the app on any day and tick off what
that day asks for. Feature definition is the next step, and a Feature is a capability spec —
which means the language the specs describe behaviour in has to be settled before the first
one is written.

ADR 0008 chose TypeScript on Node 24 for this repository's own machinery and deliberately left
the platform open, on the stated ground that **the platform decision can be deferred until the
first story that renders a user-facing view.** That point has arrived. Deferring further would
mean writing capability specs without knowing what a seam looks like.

Four constraints did the deciding, and they are unusually lopsided:

**One platform.** DayByDay is for the repo owner's own phone. A second platform may never
exist, so every cross-platform argument is paying now for an option that will probably never
be exercised.

**Solo, four to eight hours a week.** Time is the binding constraint. Money is not — the whole
budget is 20 CHF a month and largely unspent — and performance is not, because the data set is
one person's commitments.

**Small, offline, durable.** Recurring commitments, a date-driven due-or-not rule, a list
screen with tap-to-tick, an edit screen. No networking, no backend, no account. The record of
what was ticked has to survive; `docs/parking-lot.md` records that a gap a few days old must be
reconstructable, which is the requirement that disqualified browser storage outright.

**HealthKit matters later.** Weight and dietary protein are native HealthKit types, named in
the Epic's "not in this Epic" list — deferred, not abandoned.

The full comparison, with sources, is `docs/research/2026-08-29-ios-stack.md`. The facts this
decision rests on were re-verified on the day it was taken; where they have moved since the
research note was recorded, the numbers below are the current ones.

## Decision

**DayByDay is written in Swift with SwiftUI, as a native iPhone app.** New unit tests use Swift
Testing; XCTest stays available for the UI and performance cases it still owns.

The rule engine — *is this commitment due on this date* — is pure logic and lives in a Swift
Package with no UI dependency, driven from the terminal by `swift test`. That package's
exported entry point is the seam acceptance tests attach to: an ordinary function call, no
process to spawn, no global stream to capture. It is the cleanest seam any of the candidates
offered, and it is the shape the pipeline in `AGENTS.md` is built around.

**The Apple Developer Program membership is treated as mandatory, at 99 USD per membership
year.** The free tier's provisioning profiles expire seven days from issuance, along with its
App IDs and registered test devices, so the app simply stops launching. For something opened
several times a day that is fatal, not an inconvenience. This is a budget line, not an option
to weigh later.

Two questions this decision deliberately leaves open, because neither blocks Feature
definition and both are cheaper to answer with a real requirement in hand:

- **SwiftData or GRDB.** SwiftData looks adequate for a data set this small and GRDB is the
  escape hatch if it is not. Nothing here commits to either.
- **How `scripts/check-scenario-coverage.ts` enumerates Swift test names.** The mechanism is
  undecided; that the check must keep working is not.

## Consequences

- **The language is new to the owner** — realistically 20–40 hours before fluency, four to
  seven weeks of the weekly budget. This is the entire price of the decision, and it is paid
  once. Expect the first Stories to run long for reasons that have nothing to do with their
  size.
- **The toolchain is already on the machine and costs nothing to set up.** Verified today:
  macOS 26.6.2 on Apple silicon, Xcode 26.6, Swift 6.3.3. Xcode 26.6 requires macOS Tahoe 26.2
  or later, so this machine is over the line rather than at it. Nothing needs Homebrew, which
  matters because Homebrew is unusable on this account.
- **No version is pinned here.** Xcode 27 with Swift 6.4 is in beta, so the floor will move on
  Apple's schedule and not on ours. Pinning a toolchain in an ADR is how the register turns
  into a trap; the operative versions belong in `AGENTS.md` where they are expected to move.
- **One check in this repository is coupled to the language, and only one.** Five of the six
  merge-time checks read git history, the GitHub API and markdown under `openspec/`, and
  survive untouched — `check-scenario-coverage.ts` is the only script that mentions vitest at
  all. It enumerates acceptance-test titles by shelling out to vitest and must learn to list
  Swift test names instead. ADR 0005 is unaffected: scenarios still drive tests one-to-one,
  and the titles still have to match verbatim.
- **CI grows a macOS job** for the `verify` step, alongside the Linux job that runs the checks.
  Standard GitHub-hosted runners, macOS included, are free and unlimited on public
  repositories — a second dividend from ADR 0007. Larger runners are billed even on a public
  repo, so this job stays on a standard runner.
- **HealthKit is a first-party API call rather than a bridge**, whenever weight and protein
  arrive. That was the deciding factor against every cross-platform option.
- **Cross-platform is closed off in practice.** Reversing this means rewriting the UI; only the
  rule engine, a date predicate of a few hundred lines, would survive. Accepted knowingly: the
  second platform is hypothetical and the rewrite would be small.
- **ADR 0008 stands.** TypeScript on Node 24 keeps running this repository's own tooling — the
  checks, the graph, the CI scripts. Two languages now live here, doing unrelated jobs. Whether
  the Node tooling stays long-term is not decided by this ADR.

## Alternatives considered

**Expo / React Native** — the serious alternative, and the closest call. It reuses the owner's
existing TypeScript, reuses much of this repository's tooling, and is the fastest route to a
working screen on a real phone; it would have saved most of the 20–40 hours. Rejected because
the saving is one-off and the costs are permanent: a layer of indirection under every screen
for the life of the app, and a third-party dependency for HealthKit, which is the one integration
the product is known to want. Trading a fixed learning cost for an unbounded maintenance cost is
the wrong side of that trade when the schedule is four to eight hours a week for years.

**Kotlin Multiplatform with Compose Multiplatform** — rejected, but not for being immature.
Compose Multiplatform for iOS has been stable since 1.8.0 in May 2025 and runs in production at
scale. It is rejected because its entire value is sharing logic across platforms and there is
one platform, and the logic there would be to share is a date predicate of a few hundred lines.
HealthKit would still be a Swift bridge. It is a good answer to a question this project is not
asking.

**A home-screen PWA** — rejected on a stated requirement, not on the usual folklore. The
familiar objections are stale: home-screen web apps are exempt from Safari's seven-day
script-storage cap and have supported push since iOS 16.4. It fails because its data lives in
browser storage that Safari can evict, and a durable record of what was ticked is the entire
point of the product. It would also have been the only option that avoided the 99 USD.
