import { describe, expect, it } from 'vitest'
import { blankSwiftComments, swiftTestTitles, unescapeSwiftLiteral } from '../scripts/lib/swift-tests.ts'

// CI check 4 matches a scenario title against an acceptance test title verbatim, and on the
// Swift side that title is read out of source rather than from a test runner — no Swift tool
// reports the @Test display name without going through unpublished internals, and the compiler
// enforces that the display name is a literal. scripts/lib/swift-tests.ts carries the full
// reasoning. What that buys is a parser this check now depends on, so its edges are pinned here.
//
// The fixture shapes below were taken from a real Swift 6.3.3 package, not written from memory:
// `swift test list` and `--xunit-output` both report `dueOnAnchor()`, while the JSON event
// stream reports the display name — which is what proved source parsing was the way to get it.
describe('swiftTestTitles', () => {
  it('reads the display name off a @Test attribute', () => {
    const source = `
      @Test("a commitment every 3 days is due on the anchor day")
      func dueOnAnchor() {}
    `
    expect(swiftTestTitles(source)).toEqual(['a commitment every 3 days is due on the anchor day'])
  })

  it('ignores a @Test with no display name, because it can match no scenario', () => {
    expect(swiftTestTitles('@Test func plainName() {}')).toEqual([])
  })

  it('ignores a @Test whose first argument is a trait rather than a name', () => {
    expect(swiftTestTitles('@Test(.tags(.regression)) func tagged() {}')).toEqual([])
    expect(swiftTestTitles('@Test(arguments: [1, 2]) func parameterised(n: Int) {}')).toEqual([])
  })

  it('keeps the display name when traits follow it', () => {
    expect(swiftTestTitles('@Test("a due commitment", .tags(.rules)) func f() {}')).toEqual(['a due commitment'])
  })

  it('reads a display name a formatter has wrapped onto its own line', () => {
    const source = `
      @Test(
        "a weekly quota of two is unmet after one tick"
      )
      func quota() {}
    `
    expect(swiftTestTitles(source)).toEqual(['a weekly quota of two is unmet after one tick'])
  })

  // A commented-out test is ordinary debris in a red-green loop. If it counted, the gate would
  // pass for a scenario with no running test — the one failure direction this check must not have.
  it('does not count a @Test that is commented out', () => {
    expect(swiftTestTitles('// @Test("a scenario nobody implemented") func f() {}')).toEqual([])
    expect(swiftTestTitles('/* @Test("a scenario nobody implemented") func f() {} */')).toEqual([])
  })

  it('does not count a @Test inside a nested block comment', () => {
    const source = '/* outer /* inner */ @Test("still commented") func f() {} */'
    expect(swiftTestTitles(source)).toEqual([])
  })

  it('still sees the tests around a comment', () => {
    const source = `
      // @Test("commented out while it was failing")
      @Test("a commitment with no rule is never due")
      func neverDue() {}
      /* parked
         @Test("also parked") */
      @Test("a commitment due today is due today")
      func dueToday() {}
    `
    expect(swiftTestTitles(source)).toEqual([
      'a commitment with no rule is never due',
      'a commitment due today is due today',
    ])
  })

  // The mirror image of the comment case: comment markers inside a title are title text.
  it('keeps comment markers that appear inside the title itself', () => {
    expect(swiftTestTitles('@Test("a // b") func f() {}')).toEqual(['a // b'])
    expect(swiftTestTitles('@Test("a /* b */ c") func f() {}')).toEqual(['a /* b */ c'])
  })

  it('reads a title containing an escaped quotation mark', () => {
    expect(swiftTestTitles('@Test("a rule of \\"every 3 days\\" from a fixed start") func f() {}')).toEqual([
      'a rule of "every 3 days" from a fixed start',
    ])
  })

  it('is not derailed by a string literal that contains a lone quote escape', () => {
    const source = `
      let note = "he said \\"no\\" // not a comment"
      @Test("a commitment ticked twice counts once")
      func twice() {}
    `
    expect(swiftTestTitles(source)).toEqual(['a commitment ticked twice counts once'])
  })

  it('is not derailed by a multi-line string literal', () => {
    const source = `
      let banner = """
        contains a " and a // and a /* here
        """
      @Test("a missed day stays missed")
      func missed() {}
    `
    expect(swiftTestTitles(source)).toEqual(['a missed day stays missed'])
  })

  it('is not derailed by a raw string literal', () => {
    const source = `
      let pattern = #"a "quoted" \\#(thing) // here"#
      @Test("a rule bounded to weekdays skips the weekend")
      func weekdays() {}
    `
    expect(swiftTestTitles(source)).toEqual(['a rule bounded to weekdays skips the weekend'])
  })

  // @Suite names the box, not the behaviour. A scenario maps to a test, which is the same
  // distinction Swift Testing's JSON event stream draws as kind "function" versus "suite".
  it('ignores a @Suite display name', () => {
    const source = `
      @Suite("Recurrence rules")
      struct RecurrenceRules {
        @Test("an every-other-day rule is due on the anchor")
        func anchor() {}
      }
    `
    expect(swiftTestTitles(source)).toEqual(['an every-other-day rule is due on the anchor'])
  })

  it('returns titles in source order, including duplicates', () => {
    const source = `
      @Test("second") func b() {}
      @Test("first") func a() {}
      @Test("second") func c() {}
    `
    expect(swiftTestTitles(source)).toEqual(['second', 'first', 'second'])
  })

  it('finds nothing in a Swift file with no tests in it', () => {
    expect(swiftTestTitles('public func isDue(on date: Date) -> Bool { false }')).toEqual([])
  })
})

describe('blankSwiftComments', () => {
  it('preserves length and line structure so offsets still line up', () => {
    const source = 'let a = 1 // trailing\nlet b = 2\n'
    const blanked = blankSwiftComments(source)
    expect(blanked).toHaveLength(source.length)
    expect(blanked.split('\n')).toHaveLength(source.split('\n').length)
    expect(blanked).toBe('let a = 1            \nlet b = 2\n')
  })

  it('leaves string literals untouched', () => {
    expect(blankSwiftComments('let a = "// not a comment"')).toBe('let a = "// not a comment"')
  })

  it('closes a nested block comment only at the outermost delimiter', () => {
    const comment = '/* x /* y */ z */'
    expect(blankSwiftComments(`a${comment}b`)).toBe(`a${' '.repeat(comment.length)}b`)
  })

  it('does not swallow the file when a string literal is unterminated', () => {
    const source = 'let a = "oops\nlet b = 2\n'
    expect(blankSwiftComments(source)).toBe(source)
  })
})

describe('unescapeSwiftLiteral', () => {
  it('resolves an escaped quotation mark', () => {
    expect(unescapeSwiftLiteral('a \\"quoted\\" title')).toBe('a "quoted" title')
  })

  it('resolves a backslash without eating the character after it', () => {
    expect(unescapeSwiftLiteral('a \\\\ b')).toBe('a \\ b')
  })

  it('resolves the control escapes', () => {
    expect(unescapeSwiftLiteral('a\\nb\\tc\\rd')).toBe('a\nb\tc\rd')
  })

  it('resolves a unicode scalar escape', () => {
    expect(unescapeSwiftLiteral('caf\\u{E9}')).toBe('café')
  })

  it('leaves a literal with no escapes alone', () => {
    expect(unescapeSwiftLiteral('a plain scenario title')).toBe('a plain scenario title')
  })
})
