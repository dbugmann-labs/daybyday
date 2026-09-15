import SwiftUI
import DayByDayKit

/// One commitment seen on its own, over everything since the day it is kept from. Reached by a
/// `NavigationLink` on `CommitmentsView`'s kept or stopped row. Draws `lookBack`'s fields and
/// lines in the order it says them, decides nothing and offers no control — `design.md` § *The
/// shell rides this Story*: the kit already answered every rule a page shows.
struct LookBackView: View {
    let lookBack: LookBack?

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
