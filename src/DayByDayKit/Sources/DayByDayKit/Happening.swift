import Foundation

/// Something that comes to a person rather than something they owe: a name and an identity, and
/// nothing else. ADR-1065; `openspec/changes/add-happening/design.md` § *The seam*.
public struct Happening: Hashable, Sendable {
    public struct Identity: Hashable, Sendable {
        private let value: UUID

        fileprivate init() {
            value = UUID()
        }

        init?(_ uuidString: String) {
            guard let value = UUID(uuidString: uuidString) else {
                return nil
            }
            self.value = value
        }

        var uuidString: String { value.uuidString }
    }

    public let identity: Identity
    public let name: String

    public init?(name: String) {
        guard !Blank.saysNothing(name) else {
            return nil
        }

        self.identity = Identity()
        self.name = name
    }

    init(identity: Identity, name: String) {
        self.identity = identity
        self.name = name
    }

    public static func == (lhs: Happening, rhs: Happening) -> Bool {
        lhs.identity == rhs.identity
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(identity)
    }
}
