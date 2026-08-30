/**
 * The G4 approval digest — what a `G4: approved` marker is a signature over.
 *
 * The marker on its own records that a human was asked; it does not record *what* they were
 * asked about. A change folder edited after approval — a scenario softened when it turned out
 * to be awkward, a decision rewritten in `design.md` — leaves the gate covering text nobody
 * read, and nothing in the process notices, because check 5 only ever looked for the marker's
 * existence. The digest closes that: the marker carries a fingerprint of the approved files,
 * and check 5 recomputes it at merge time.
 *
 * Two properties it has to have, both of which rule out the obvious alternatives:
 *
 * - **It survives a rebase.** The branch is rebased onto `origin/main` before G4 and again
 *   before G7 (ADR-1003), so a commit sha recorded at approval is orphaned by the time CI
 *   clones the branch. Content, not history.
 * - **It survives the archive.** `/opsx:archive` moves the folder to
 *   `openspec/changes/archive/<date>-<id>/` as a pure rename — verified on
 *   `chore(archive): add-weekday-set-schedule`, where all five files came through as R100 — so
 *   paths are hashed relative to the change folder, never from the repository root.
 *
 * `tasks.md` is excluded, and is the one file `implementer` may legitimately write during a
 * Story (docs/process.md §6). Ticking a box is not amending a requirement. The cost is that
 * *adding* a task after approval is invisible here too; a task list is a work plan, and the
 * requirements are in the delta.
 */
import { createHash } from 'node:crypto'
import { readFileSync, readdirSync } from 'node:fs'
import path from 'node:path'

/** Files inside a change folder that are not part of what G4 approves. */
const NOT_APPROVED = new Set(['tasks.md'])

/** Length of the digest as it is written on the issue. Full sha256 is noise on a comment. */
const DIGEST_CHARS = 12

function sha256(data: Buffer | string): string {
  return createHash('sha256').update(data).digest('hex')
}

/**
 * Every file under a change folder that G4 approves, as paths relative to that folder,
 * separator-normalised and sorted so the listing is identical wherever it is computed.
 */
export function approvedFiles(dir: string): string[] {
  const out: string[] = []
  const walk = (rel: string): void => {
    for (const entry of readdirSync(path.join(dir, rel), { withFileTypes: true })) {
      const child = rel === '' ? entry.name : `${rel}/${entry.name}`
      if (entry.isDirectory()) walk(child)
      else if (!NOT_APPROVED.has(child)) out.push(child)
    }
  }
  walk('')
  return out.sort()
}

/**
 * The fingerprint of a change folder's approved files: a hash over each path and the hash of
 * its contents. Hashing the paths as well as the bytes means a renamed or deleted file moves
 * the digest, which hashing a concatenation of contents would not.
 */
export function changeDigest(dir: string): string {
  const hash = createHash('sha256')
  for (const file of approvedFiles(dir)) {
    hash.update(`${file}\0${sha256(readFileSync(path.join(dir, file)))}\n`)
  }
  return hash.digest('hex').slice(0, DIGEST_CHARS)
}

/**
 * The marker's first line, unchanged from ADR-0014 except that the digest now sits between the
 * word and the attribution — `G4: approved 7f3c9a1b2c3d — authorised by <name>`. One line, so
 * there is no second line to lose to a copy-paste, and `^G4: approved\b` still finds a marker
 * written in the older form.
 *
 * Never write either string on a Story issue for any reason but the approval itself.
 */
const APPROVAL = /^G4: approved\b/m
const DIGEST = /^G4: approved[ \t]+([0-9a-f]{7,64})\b/m

export type IssueComment = { body: string; user: { login: string }; created_at: string }
export type Marker = { by: string; at: string; digest: string | null }

/**
 * Every G4 marker on an issue, oldest first. Plural because re-approval is a second comment:
 * the record of what was approved when is worth more than an edited comment, and check 5
 * accepts the Story if any marker signs the folder as it now stands.
 */
export function findMarkers(comments: IssueComment[]): Marker[] {
  return comments
    .filter((c) => APPROVAL.test(c.body ?? ''))
    .map((c) => ({
      by: c.user.login,
      at: c.created_at,
      digest: DIGEST.exec(c.body)?.[1] ?? null,
    }))
}

/** The marker body a human's decision is recorded as, once they have made it. */
export function markerBody(digest: string, authorisedBy: string): string {
  return `G4: approved ${digest} — authorised by ${authorisedBy}`
}
