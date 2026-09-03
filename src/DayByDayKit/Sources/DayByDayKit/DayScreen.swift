import Foundation

/// The day view a person is looking at, and the record it is read from and kept at. See
/// `openspec/specs/day-screen/spec.md` for the behaviour contract and this change's `design.md`
/// § *The seam* for why the surface is shaped this way.
@MainActor
@Observable
public final class DayScreen {
    /// What a day screen is doing with the record at its place.
    public enum RecordState: Equatable, Sendable {
        /// The record was read, and a tick made on this screen is kept.
        case kept
        /// The record could not be read, for a reason a person cannot act on differently.
        case unreadable
        /// The record was written by a later version of DayByDay. It is whole; the app is what is
        /// behind, and what is at the place must not be replaced.
        case writtenByALaterVersion
    }

    private let commitments: [Commitment]
    private let place: URL
    private var today: CalendarDate
    private var store: RecordStore?

    /// The place a day screen keeps its record when it is not told another.
    public static var recordPlace: URL {
        fatalError("not implemented")
    }

    /// Opens on `today`, reading the record kept at `place`.
    public init(
        of commitments: [Commitment],
        asOf today: CalendarDate,
        keeping place: URL = DayScreen.recordPlace
    ) {
        self.commitments = commitments
        self.today = today
        self.place = place

        if let store = try? RecordStore(at: place) {
            self.store = store
            self.recordState = .kept
            self.dayView = DayView(of: commitments, on: today, in: store.history)
        } else {
            self.store = nil
            self.recordState = .unreadable
            self.dayView = DayView(of: commitments, on: today, in: History())
        }
    }

    /// The day view the person is looking at, as the record stood when it was last read.
    public private(set) var dayView: DayView

    /// Anything but `.kept` means the day is drawn from no record at all and no tick is taken.
    public private(set) var recordState: RecordState

    /// Makes the tick `row` offers, or takes it back where `row` says its commitment is kept, and
    /// keeps the change before `dayView` says so. Does nothing when `row` is not one this screen's
    /// day view holds, or when this screen is not keeping a record. Throws when the change could
    /// not be kept, leaving `dayView` as it was.
    public func tick(_ row: DayView.Row) throws {
        fatalError("not implemented")
    }

    /// The app has been shown on `today`: the day view and the record are read again.
    public func shown(asOf today: CalendarDate) {
        fatalError("not implemented")
    }
}
