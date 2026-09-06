# CI gate demo — disposable

This file exists to prove one thing and will be deleted with the PR that carries it: that the
`swift` job's UI smoke step **skips** when a change reaches neither `src/DayByDay/`,
`src/DayByDayKit/Sources/` nor `.github/workflows/ci.yml`.

Expected on this PR: the step *does this change reach the app?* prints

```
Reaches neither the shell, the kit's sources, nor this workflow.
```

and `xcodebuild test — the app shell draws` is skipped, leaving the `swift` job at roughly the
90 seconds it took before ADR-1029.

This PR is not for merging.
