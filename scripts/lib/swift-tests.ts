/**
 * Reading Swift Testing display names out of Swift source, for CI check 4.
 *
 * ## Why this parses source rather than asking the test runner
 *
 * The TypeScript half of check 4 asks vitest for its test titles, on the stated
 * ground that grepping source misreads nesting and template literals. The
 * obvious move was to do the same on the Swift side. It does not work, and the
 * reason is worth writing down so nobody spends the afternoon rediscovering it:
 *
 * - `swift test list` prints *specifier* format — `RulesTests.dueOnAnchor()`.
 *   It is the function's identifier, never the `@Test("...")` display name, so
 *   it can never match a scenario title.
 * - `swift test --xunit-output` writes `name="dueOnAnchor()"` for the same
 *   reason. Also the identifier.
 * - The display name *is* carried by Swift Testing's JSON event stream, but
 *   reaching it means invoking `swiftpm-testing-helper` out of
 *   `usr/libexec/swift/pm/` with `--event-stream-version`, against a `.xctest`
 *   bundle path you have to locate yourself. That is three couplings to
 *   unpublished internals, in a repository whose retrospective §5 exists
 *   because documented commands rotted.
 *
 * What makes source parsing sound here — and unsound in TypeScript — is that
 * the Swift compiler *enforces* the display name is a literal. Feeding `@Test`
 * a `let` constant is a compile error: "expect a compile-time constant
 * literal". There is no interpolation to evaluate and no `describe()` nesting
 * to flatten; the title is a string literal at a fixed position or it does not
 * compile. So the text is the truth, and reading it needs no toolchain.
 *
 * The practical dividend is that check 4 keeps running on the Linux job. It
 * reads `.swift` files as text and never builds them, so enumerating Swift
 * tests costs no macOS runner and no Xcode.
 *
 * The one thing text cannot see is a test that does not compile. That is the
 * `swift test` job's business, not this check's.
 */

/** Directory names never worth walking when looking for Swift sources. */
export const SWIFT_SKIP_DIRS = new Set(['.git', '.build', '.swiftpm', 'DerivedData', 'Pods', 'node_modules'])

/**
 * A `@Test` attribute whose first argument is a string literal, i.e. one that
 * carries a display name. `@Test func f()`, `@Test(.tags(.x))` and
 * `@Test(arguments: [...])` all correctly fail to match: they have no display
 * name, so they are not acceptance tests as far as check 4 is concerned.
 *
 * `\s*` rather than a plain `(` because a long scenario title is exactly the
 * thing a formatter wraps onto its own line.
 */
const TEST_DISPLAY_NAME = /@Test\s*\(\s*"((?:[^"\\]|\\.)*)"/g

/**
 * Display names of every `@Test` in one Swift source file, in source order.
 *
 * Suites are deliberately excluded. `@Suite("...")` names a group, and a
 * scenario maps to a test, never to the box around it — the same distinction
 * the JSON event stream draws with `kind: "function"` versus `kind: "suite"`.
 */
export function swiftTestTitles(source: string): string[] {
  const code = blankSwiftComments(source)
  return [...code.matchAll(TEST_DISPLAY_NAME)].map((m) => unescapeSwiftLiteral(m[1]!))
}

/**
 * Replace the contents of every comment with spaces, leaving string literals
 * and every byte offset alone.
 *
 * This is not tidiness. A commented-out test is ordinary debris in a red-green
 * loop, and `// @Test("...")` left behind would otherwise satisfy the gate for
 * a scenario that has no running test — a false pass on the one check standing
 * between an unimplemented requirement and `main`. Failing loudly is fine here;
 * passing quietly is not.
 */
export function blankSwiftComments(source: string): string {
  const out = [...source]
  const n = source.length
  let i = 0

  const blank = (from: number, to: number): void => {
    for (let k = from; k < to; k++) if (out[k] !== '\n') out[k] = ' '
  }

  while (i < n) {
    if (source.startsWith('//', i)) {
      let j = i
      while (j < n && source[j] !== '\n') j++
      blank(i, j)
      i = j
      continue
    }

    // Block comments nest in Swift, so this counts depth rather than scanning
    // for the first `*/`.
    if (source.startsWith('/*', i)) {
      let depth = 1
      let j = i + 2
      while (j < n && depth > 0) {
        if (source.startsWith('/*', j)) {
          depth++
          j += 2
        } else if (source.startsWith('*/', j)) {
          depth--
          j += 2
        } else j++
      }
      blank(i, j)
      i = j
      continue
    }

    // String literals are skipped, never blanked: `@Test("a // b")` is a title,
    // not a comment.
    if (source[i] === '#') {
      let hashes = 0
      while (source[i + hashes] === '#') hashes++
      if (source[i + hashes] === '"') {
        i = skipRawString(source, i, hashes)
        continue
      }
    }
    if (source.startsWith('"""', i)) {
      i = skipMultilineString(source, i)
      continue
    }
    if (source[i] === '"') {
      i = skipString(source, i)
      continue
    }

    i++
  }

  return out.join('')
}

/** Index just past the closing quote of a single-line string literal. */
function skipString(s: string, start: number): number {
  let i = start + 1
  while (i < s.length) {
    if (s[i] === '\\') {
      i += 2
      continue
    }
    if (s[i] === '"') return i + 1
    // Unterminated. Bail at the newline rather than swallowing the rest of the
    // file; the compiler will have plenty to say about it.
    if (s[i] === '\n') return i
    i++
  }
  return i
}

/** Index just past the closing `"""` of a multi-line string literal. */
function skipMultilineString(s: string, start: number): number {
  let i = start + 3
  while (i < s.length) {
    if (s[i] === '\\') {
      i += 2
      continue
    }
    if (s.startsWith('"""', i)) return i + 3
    i++
  }
  return i
}

/**
 * Index just past the closing delimiter of a raw string, `#"..."#` through
 * `###"""..."""###`. In a raw string an escape is `\` followed by the same
 * number of `#`, so a bare backslash is not an escape.
 */
function skipRawString(s: string, start: number, hashes: number): number {
  const pad = '#'.repeat(hashes)
  let i = start + hashes + 1

  if (s.startsWith('""', i)) {
    const close = `"""${pad}`
    i += 2
    while (i < s.length && !s.startsWith(close, i)) i++
    return Math.min(s.length, i + close.length)
  }

  const close = `"${pad}`
  while (i < s.length) {
    if (s.startsWith(`\\${pad}`, i)) {
      i += hashes + 2
      continue
    }
    if (s.startsWith(close, i)) return i + close.length
    if (s[i] === '\n') return i
    i++
  }
  return i
}

/**
 * Resolve the escapes Swift allows in a string literal, so the title compared
 * against a scenario is the text the runner would print.
 *
 * A scenario title is a sentence, so in practice this is `\"` and little else —
 * but a title containing a quotation mark is the case where getting it wrong
 * produces a mismatch nobody can see by reading the two strings side by side.
 */
export function unescapeSwiftLiteral(raw: string): string {
  return raw.replace(/\\u\{([0-9A-Fa-f]+)\}|\\(.)/g, (_match, hex: string | undefined, ch: string | undefined) => {
    if (hex !== undefined) return String.fromCodePoint(Number.parseInt(hex, 16))
    switch (ch) {
      case 'n':
        return '\n'
      case 't':
        return '\t'
      case 'r':
        return '\r'
      case '0':
        return '\0'
      default:
        return ch ?? ''
    }
  })
}
