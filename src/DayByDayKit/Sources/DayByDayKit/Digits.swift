import Foundation

/// The one place this package decides how many significant digits a decimal holds, and whether a
/// day may take an amount. Internal; `design.md` § *Where the sum cap lives* fixes the rule.
enum Digits {
    /// The count of significant digits `decimal` holds, read off its exact value — leading zeros
    /// in the whole part and trailing zeros in the fraction do not count, and a value of exactly
    /// zero holds none. Read off `decimal`'s own description rather than off any typed text:
    /// `design.md` § *Measured, not recalled*, measurement A is why a sum must be counted this
    /// way and never off a value already rounded or truncated to fit some other bound.
    static func significant(in decimal: Decimal) -> Int {
        var digits = Substring("\(decimal)")
        if digits.first == "-" {
            digits.removeFirst()
        }

        let parts = digits.split(separator: ".", omittingEmptySubsequences: false)
        var whole = parts[0]
        var fraction = parts.count > 1 ? parts[1] : Substring()
        while whole.first == "0" {
            whole.removeFirst()
        }
        while fraction.last == "0" {
            fraction.removeLast()
        }

        return whole.count + fraction.count
    }

    /// Whether a day that has so far taken `soFar` may take `amount` too, judged on the sum
    /// arithmetic gives rather than on the sum the system would then hold — `design.md`
    /// § *Measured, not recalled*, measurement A. `false` when the sum is not a number, when it
    /// holds more than thirty-eight significant digits, or when it does not undo back to `soFar`
    /// and `amount` exactly: the two subtractions are what catch a sum `Decimal` truncated toward
    /// zero while still reporting no error, per measurement B.
    static func canAdd(_ amount: Decimal, to soFar: Decimal) -> Bool {
        let sum = soFar + amount
        guard !sum.isNaN else {
            return false
        }
        guard significant(in: sum) <= 38 else {
            return false
        }
        return (sum - amount) == soFar && (sum - soFar) == amount
    }
}
