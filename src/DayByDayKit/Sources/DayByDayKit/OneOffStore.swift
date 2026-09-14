import Foundation

public final class OneOffStore {
    private let place: URL

    public init(at place: URL) throws {
        self.place = place
        self.oneOffs = OneOffs()
    }

    public private(set) var oneOffs: OneOffs

    @discardableResult
    public func add(_ oneOff: OneOff) throws -> Bool {
        false
    }

    @discardableResult
    public func add(_ oneOff: OneOff, doneOn day: CalendarDate) throws -> Bool {
        false
    }

    @discardableResult
    public func tick(_ oneOff: OneOff, on day: CalendarDate) throws -> Bool {
        false
    }

    @discardableResult
    public func takeBack(_ oneOff: OneOff) throws -> Bool {
        false
    }

    @discardableResult
    public func remove(_ oneOff: OneOff) throws -> Bool {
        false
    }
}

public enum OneOffStoreError: Error, Equatable, Sendable {
    case notAStore(at: URL)
    case laterForm(at: URL, version: Int)
    case cannotWrite(at: URL)
}
