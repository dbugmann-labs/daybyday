import Foundation

/// The one reading of a typed decimal in this package: blank, a number, or a value that is not a
/// number. Package-internal, beside `Blank` and `Digits`; both a day screen's number entry and a
/// commitments screen's range and target fields call `read(_:)` and get the same three answers to
/// the same text, so the two surfaces can never come to disagree about whether `1e2` or `0,5` is a
/// number. See `add-kind-to-commitments-screen`'s `design.md` § *One reading of a typed number* for
/// why this moved out of `DayScreen`, and #139's `design.md` § *Context* for why `Decimal(string:)`
/// is never handed the text a person typed.
enum TypedNumber {
    /// What `read(_:)` reads a text as.
    enum CommittedText {
        case number(Decimal)
        case takeBack
        case notANumber
    }

    /// Reads `text` in this capability's own way and consulting no locale. `Decimal(string:)` is a
    /// *prefix* parser, not a validator — #139's `design.md` § *Context* measures five ways it
    /// silently reads a value nobody typed — so the shape of what was typed is checked in full
    /// before `Decimal(string:)` is ever called, and the parse is then given a text this reading
    /// built and never the text a person typed: the same number can be spelled in a way
    /// `Decimal(string:)` holds and in another it refuses, so the parse is asked about the one
    /// spelling this reading already knows says the value exactly.
    static func read(_ text: String) -> CommittedText {
        let trimmed = Blank.trimmed(text)
        guard !trimmed.isEmpty else {
            return .takeBack
        }

        var digits = trimmed[...]
        var sign = ""
        if digits.first == "-" {
            sign = "-"
            digits.removeFirst()
        }

        var digitCount = 0
        var separatorCount = 0
        for character in digits {
            if character.isASCII, character.isNumber {
                digitCount += 1
            } else if character == "." || character == "," {
                separatorCount += 1
            } else {
                return .notANumber
            }
        }

        let (written, significantDigits) = Self.writtenOut(digits)
        guard digitCount >= 1, separatorCount <= 1, significantDigits <= 38 else {
            return .notANumber
        }
        guard significantDigits > 0 else {
            return .number(0)
        }

        guard let number = Decimal(string: sign + written) else {
            return .notANumber
        }
        return .number(number)
    }

    /// Writes `digits` out in the one spelling `read(_:)` asks `Decimal(string:)` about — text
    /// already proved to hold nothing but digits and at most one separator, with any leading `-`
    /// already removed — and gives back the count of significant digits that spelling holds: the
    /// whole part with its leading zeros dropped, a full stop where a `.` or `,` was typed, the
    /// fraction with its trailing zeros dropped, and no separator where nothing is left after it.
    /// The count is `Digits.stripped(whole:fraction:)`'s, read off that same stripping and not
    /// off `digits` directly, because a leading zero the whole part loses can still open the
    /// fraction (`"0.08"` holds one significant digit, not two) — `Digits` is where this counting
    /// is decided, so this and `Digits.significant(in:)` cannot drift apart on what a significant
    /// digit is.
    ///
    /// #139's `design.md` § *A number this system cannot keep exactly is not a number here*: a
    /// count above thirty-eight is a value that is not a number, and a count of zero is answered
    /// as `.number(0)` without `read(_:)` ever calling `Decimal(string:)` — a shortcut now rather
    /// than a guard, since every such text is written out as `"0"` here too, and no longer the
    /// only defence against a `nil` that once meant something else: a value at any magnitude can
    /// be refused for how it was spelled rather than for what it is worth, which is why the parse
    /// is never asked about the text as typed.
    static func writtenOut(_ digits: Substring) -> (text: String, significantDigits: Int) {
        let parts = String(digits).replacingOccurrences(of: ",", with: ".")
            .split(separator: ".", omittingEmptySubsequences: false)
        let stripped = Digits.stripped(
            whole: parts[0], fraction: parts.count > 1 ? parts[1] : Substring())
        guard stripped.significantDigits > 0 else {
            return ("0", 0)
        }

        let head = stripped.whole.isEmpty ? "0" : String(stripped.whole)
        let text = stripped.fraction.isEmpty ? head : head + "." + String(stripped.fraction)
        return (text, stripped.significantDigits)
    }
}
