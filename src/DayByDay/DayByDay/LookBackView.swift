import SwiftUI
import DayByDayKit

/// One commitment seen on its own, over everything since the day it is kept from. Reached by a
/// `NavigationLink` on `CommitmentsView`'s kept or stopped row. Draws `lookBack`'s fields and
/// lines in the order it says them, decides nothing and offers no control — `design.md` § *The
/// shell rides this Story*: the kit already answered every rule a page shows.
///
/// **Layout is Option B of the G7 proposal** (PR #280): a hand-drawn `ScrollView` and `Grid`
/// rather than the platform `List` the rest of the shell is built from, so the whole — the one
/// summary figure this screen has — can read as a scoreboard rather than another row. No seam
/// string here is composed, split or reworded; every card and row draws exactly what `LookBack`
/// hands it.
///
/// Holds `screen` and `commitment` rather than an already-formed `LookBack`, so the day-by-day
/// walk `screen.lookBack(at:)` sits behind `body` and runs once per body pass — read into a
/// local at the top of `body` rather than through the computed property at every use — never
/// while `CommitmentsView`'s row is merely constructed, eagerly, on every redraw of every row on
/// both its lists. G7 finding 2 on #272.
struct LookBackView: View {
    let screen: CommitmentsScreen
    let commitment: Commitment

    private var lookBack: LookBack? { screen.lookBack(at: commitment) }

    var body: some View {
        let lookBack = lookBack
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                if let lookBack {
                    head(lookBack)
                    cards(lookBack)
                    months(lookBack)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(lookBack?.name ?? "")
    }

    @ViewBuilder
    private func head(_ lookBack: LookBack) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(lookBack.name)
                .font(.largeTitle.bold())
            Text(lookBack.rhythmInWords)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    @ViewBuilder
    private func cards(_ lookBack: LookBack) -> some View {
        HStack(spacing: 12) {
            card(label: "Kept from") {
                Text(lookBack.keptFromInWords)
            }
            card(label: "Kept until") {
                if let keptUntilInWords = lookBack.keptUntilInWords {
                    Text(keptUntilInWords)
                } else {
                    Text("—")
                        .foregroundStyle(.secondary)
                }
            }
        }

        if let whole = lookBack.whole {
            card(label: "The whole") {
                Text(whole)
                    .font(.title.monospacedDigit())
            }
        }
    }

    @ViewBuilder
    private func card<Content: View>(label: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.background, in: RoundedRectangle(cornerRadius: 12))
    }

    @ViewBuilder
    private func months(_ lookBack: LookBack) -> some View {
        if lookBack.lines.isEmpty {
            Text("Nothing is counted here yet.")
        } else {
            Text("Months")
                .font(.headline)
            Grid(alignment: .leading, horizontalSpacing: 12, verticalSpacing: 6) {
                ForEach(Array(lookBack.lines.enumerated()), id: \.offset) { _, line in
                    lookBackLine(line)
                }
            }
        }
    }

    @ViewBuilder
    private func lookBackLine(_ line: LookBack.Line) -> some View {
        switch line {
        case .month(let inWords, let fraction):
            GridRow {
                Text(inWords)
                Text(fraction ?? "")
                    .monospacedDigit()
                    .gridColumnAlignment(.trailing)
            }
            GridRow {
                Divider()
                    .gridCellColumns(2)
            }
        case .rhythmChanged(let inWords, let from):
            GridRow {
                VStack(spacing: 6) {
                    doubleRule
                    Text("\(inWords) · \(from)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    doubleRule
                }
                .frame(maxWidth: .infinity)
                .gridCellColumns(2)
            }
        }
    }

    private var doubleRule: some View {
        VStack(spacing: 2) {
            Divider()
            Divider()
        }
    }
}
