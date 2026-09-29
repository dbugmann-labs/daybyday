# 1064. The app has an icon: a stack of days with a check cut into today's

- Status: accepted — the owner's proposal P10 on 2026-09-29, taken as a chore under ADR-1019;
  this record is written by `chore/app-icon`
- Date: 2026-09-29
- Deciders: Diego Bugmann

## Context

The app target had no asset catalog and no icon of any kind. On the home screen DayByDay was the
blank tile iOS draws for an app that names none, and every control that takes a tint took the
system blue every default app takes. For a product whose argument is restraint — `CONTEXT.md`
§ *Product principles* — that read as unfinished rather than quiet: the phone is where the five
daily visits start, and the tile is the first thing each one touches.

The target is iOS 26 and Xcode 27 is installed, so the icon can be one **Icon Composer** package
(`.icon`): layered artwork the system renders itself in every appearance — default, dark, tinted
and clear — where an asset catalog icon needs a hand-made image per appearance. Apple's article
*Creating your app icon using Icon Composer* says the package goes in the target and the App Icon
set name must equal its file name without `.icon`, and that it replaces an icon asset catalog; at
a deployment target of 26 no fallback `AppIcon.appiconset` is owed. `src/DayByDay/DayByDay/` is a
synchronized folder, so a package placed there joins the target with no project edit beyond the
one build setting that names it.

## Decision

**The icon is a stack of days**: three offset rounded leaves, the front one today's, and a single
check cut into the front leaf. The check is the record — the same mark a kept row carries — and
not a reward: there is one of it, it is not coloured, and nothing about it counts. **No calendar
grid, no ring, no flame.** A grid says *month planner*, a ring says *close your ring*, and a flame
says *streak*, which is the one thing `CONTEXT.md` § *Nothing congratulates you* exists to refuse.

- **It is one Icon Composer package, `src/DayByDay/DayByDay/AppIcon.icon`, and never four hand-made
  variants.** The leaves are plain white and the system recolours them per appearance; the dark,
  tinted and clear looks cost no artwork of their own. The project names it once per app
  configuration, `ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon`, the line Xcode's own template
  writes.
- **The check is a hole in the front leaf's own path, filled even-odd, not a stroked shape.** Icon
  Composer's `ictool` renders a stroked SVG path as nothing, so a stroke would be an icon with no
  check.
- **The ground is ink**, a dark greyed blue, a linear gradient from `#4A5F7E` to `#232F42`. The
  back and middle leaves sit at 28% and 55% opacity; the front one alone is glass.
- **The icon does not tint the app.** The controls keep the system blue: an accent of the app's
  own was built in the icon's colour and set aside, and a person choosing one in Settings is want
  B-069.
- **It is judged on the phone.** `ictool` renders every appearance on this Mac, but the simulator
  shows only the default tile: switched to dark, its home screen keeps every icon light. The dark,
  tinted and clear home screens are seen only on a phone.

## Consequences

- **The home screen shows DayByDay as itself** in every appearance the system offers, from one
  package.
- **Changing the icon is an edit to `AppIcon.icon`**, in Icon Composer or by hand against the
  template Xcode ships under `Icon Composer Icon.xctemplate`, and `ictool` renders the result from
  the command line for a walk.
- **The project gains one setting per app configuration** and no asset catalog. An accent colour,
  if B-069 is ever built, adds a catalog beside the package rather than replacing it.

## Alternatives considered

**An asset catalog `AppIcon.appiconset` with one 1024 image per appearance.** Rejected: four
images to keep in step by hand, for a target where the system can render all four from one.

**A calendar page, or a ring filling as the day is kept.** Rejected: the first is every calendar
app's tile, and the second is a progress score — a completion ring is the mechanic
*Nothing congratulates you* refuses, drawn on the home screen.

**Another ground colour.** The proposal's slate teal (`#3B7D82`) was built first and the owner set it
aside on 2026-09-29, choosing ink from a shortlist of five rendered with `ictool`: slate teal, ink,
plum, brass and graphite. Ink is quiet, and it sits comfortably beside the system blue the controls
keep. Graphite's dark icon nearly lost the check. Greens, reds and oranges were never candidates,
because each already means something in the app.

**The icon's colour as the app's accent.** Built on this branch in slate teal and then in ink, as
an `AccentColor` set tinting every control, and set aside by the owner on 2026-09-29, happy with
neither. The controls keep the system blue, and choosing an accent from the shortlist in Settings
is captured as want B-069 rather than built here, because a choice the app keeps is a setting and
ADR-1019 keeps those out of a shell chore.
