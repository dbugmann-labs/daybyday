import Foundation

extension Commitment {
    public enum Kind: Hashable, Sendable {
        case tick
        case number(range: Range?)
        case note
        case total(target: Target)

        /// Whether `self` and `other` are the same one of the four kinds — tick, number, note or
        /// total — whatever range or target either carries. `openspec/changes/
        /// change-range-and-target/design.md` § *Resemblance on the kind's sort*.
        func isOfTheSameSort(as other: Kind) -> Bool {
            switch (self, other) {
            case (.tick, .tick), (.number, .number), (.note, .note), (.total, .total):
                return true
            default:
                return false
            }
        }
    }

    public struct Range: Hashable, Sendable {
        public let lowest: Decimal
        public let highest: Decimal

        public init?(lowest: Decimal, highest: Decimal) {
            guard !lowest.isNaN, !highest.isNaN, lowest <= highest else {
                return nil
            }

            self.lowest = lowest
            self.highest = highest
        }
    }

    public struct Target: Hashable, Sendable {
        public let amount: Decimal

        public init?(_ amount: Decimal) {
            guard amount > 0 else {
                return nil
            }

            self.amount = amount
        }
    }
}
