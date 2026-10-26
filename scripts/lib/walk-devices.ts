/**
 * The walk's simulators, and the pruning that keeps them from outliving their worktrees.
 *
 * Every worktree walks on a device of its own, `DayByDay walk <worktree directory>`
 * (`scripts/walk.ts`). The janitor deletes it at Stage 9, and the walk itself deletes any whose
 * worktree is gone — but the janitor's line is the third of three in one step, and on #435 it ran
 * the first two and dropped it, and no walk ran for days after, so the device sat booted
 * until the owner noticed on 2026-10-26. A cleanup that waits on someone remembering it, or on
 * the next walk, is not one. So the pruning lives here and `pnpm run status` runs it too, which
 * every session begins with.
 *
 * It deletes only a device that carries the prefix and whose name matches no worktree directory,
 * so a stock simulator, and the device of any tree still checked out, is never touched.
 */
import { execFileSync, spawnSync } from 'node:child_process'
import path from 'node:path'

// The prefix is how a walk tells its own devices from the stock ones.
export const DEVICE_PREFIX = 'DayByDay walk '

export type Device = { name: string; udid: string; state: string; deviceTypeIdentifier: string }

/** The walk devices whose worktree directory is no longer in `git worktree list`. */
export function staleWalkDevices<D extends { name: string }>(devices: readonly D[], worktreeDirs: ReadonlySet<string>): D[] {
  return devices.filter((d) => d.name.startsWith(DEVICE_PREFIX) && !worktreeDirs.has(d.name.slice(DEVICE_PREFIX.length)))
}

/** Directory names of every worktree of this repository, the main clone's included. */
export function worktreeDirs(porcelain: string): Set<string> {
  return new Set(
    porcelain
      .split('\n')
      .filter((line) => line.startsWith('worktree '))
      .map((line) => path.basename(line.slice('worktree '.length))),
  )
}

/**
 * Deletes every stale walk device and returns their names. Returns nothing where `xcrun` is
 * absent or fails — a Linux runner, a machine without Xcode — because a missing simulator list
 * means there is nothing of ours to prune, not that anything is wrong.
 */
export function pruneWalkDevices(): string[] {
  let listed: Record<string, Device[]>
  let porcelain: string
  try {
    listed = JSON.parse(
      execFileSync('xcrun', ['simctl', 'list', 'devices', '--json'], { encoding: 'utf8', stdio: ['ignore', 'pipe', 'ignore'] }),
    ).devices
    porcelain = execFileSync('git', ['worktree', 'list', '--porcelain'], { encoding: 'utf8' })
  } catch {
    return []
  }
  const stale = staleWalkDevices(Object.values(listed).flat(), worktreeDirs(porcelain))
  for (const device of stale) spawnSync('xcrun', ['simctl', 'delete', device.udid], { stdio: 'ignore' })
  return stale.map((d) => d.name)
}
