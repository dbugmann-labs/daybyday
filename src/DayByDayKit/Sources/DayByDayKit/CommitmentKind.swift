import Foundation

extension Commitment {
    public enum Kind: Hashable, Sendable {
        case tick
        case number(range: Range?)
        case note
        case total(target: Target)
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
