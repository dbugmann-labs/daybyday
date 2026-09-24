import EventKit
import DayByDayKit

/// The adapter between the phone's own calendar permission and the Kit's `CalendarAccess` —
/// `openspec/changes/turn-birthdays-on/design.md` § *The phone's five answers reach the Kit
/// unjudged*: every `EKAuthorizationStatus` maps onto the case of the same meaning, and
/// `@unknown default` onto `.denied`. Which of these count as a refusal is judged in
/// `BirthdaySwitch`, in the Kit, not here.
func currentCalendarAccess() -> CalendarAccess {
    switch EKEventStore.authorizationStatus(for: .event) {
    case .notDetermined:
        return .notAsked
    case .fullAccess:
        return .full
    case .writeOnly:
        return .writeOnly
    case .denied:
        return .denied
    case .restricted:
        return .restricted
    @unknown default:
        return .denied
    }
}

/// Asks the phone for full calendar access — `EKEventStore.requestFullAccessToEvents()`, whose
/// thrown error is ignored: `BirthdaySwitch.turnOn()` reads `currentCalendarAccess()` again once
/// this returns, so nothing here needs to say why an ask failed.
func askForCalendarAccess() async {
    _ = try? await EKEventStore().requestFullAccessToEvents()
}
