import SwiftUI
import DayByDayKit

/// One commitment seen on its own, over everything since the day it is kept from. Reached by a
/// `NavigationLink` on `CommitmentsView`'s kept or stopped row. Draws `lookBack`'s fields and
/// lines in the order it says them, decides nothing and offers no control — `design.md` § *The
/// shell rides this Story*: the kit already answered every rule a page shows.
///
/// Holds `screen` and `commitment` rather than an already-formed `LookBack`, so the day-by-day
/// walk `screen.lookBack(at:)` runs sits behind `body` and only runs once this page is actually
/// drawn — never while `CommitmentsView`'s row is merely constructed, eagerly, on every redraw of
/// every row on both its lists. G7 finding 2 on #272.
struct LookBackView: View {
    let screen: CommitmentsScreen
    let commitment: Commitment

    private var lookBack: LookBack? { screen.lookBack(at: commitment) }

    var body: some View {
        List {
            if let lookBack {
                Section {
                    Text(lookBack.name)
                    Text(lookBack.rhythmInWords)
                    Text(lookBack.keptFromInWords)
                    if let keptUntilInWords = lookBack.keptUntilInWords {
                        Text(keptUntilInWords)
                    }
                    if let whole = lookBack.whole {
                        Text(whole)
                    }
                }
                ForEach(Array(lookBack.lines.enumerated()), id: \.offset) { _, line in
                    lookBackLine(line)
                }
            }
        }
        .navigationTitle(lookBack?.name ?? "")
    }

    @ViewBuilder
    private func lookBackLine(_ line: LookBack.Line) -> some View {
        switch line {
        case .month(let inWords, let fraction):
            if let fraction {
                Text("\(inWords) \(fraction)")
            } else {
                Text(inWords)
            }
        case .rhythmChanged(let inWords, let from):
            Text("\(inWords) — \(from)")
        }
    }
}
