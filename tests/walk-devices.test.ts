import { describe, expect, it } from 'vitest'
import { staleWalkDevices, worktreeDirs } from '../scripts/lib/walk-devices.ts'

// `pnpm run status` and every walk delete the simulators this selects, without asking. The one
// property worth pinning is what it must never select: a stock simulator, or the device of a
// worktree still checked out — the main clone's included, since a walk from the repo root makes
// `DayByDay walk daybyday`.
const porcelain = `worktree /Users/me/Coding/daybyday
HEAD 83b72ee
branch refs/heads/main

worktree /Users/me/Coding/daybyday-add-version-command
HEAD 0d014b6
branch refs/heads/story/12-add-version-command
`

describe('staleWalkDevices', () => {
  it('selects only walk devices whose worktree is gone', () => {
    const devices = [
      { name: 'iPhone 17 Pro' },
      { name: 'DayByDay walk daybyday' },
      { name: 'DayByDay walk daybyday-add-version-command' },
      { name: 'DayByDay walk daybyday-shift-a-day-across-weeks' },
    ]
    expect(staleWalkDevices(devices, worktreeDirs(porcelain)).map((d) => d.name)).toEqual([
      'DayByDay walk daybyday-shift-a-day-across-weeks',
    ])
  })
})
