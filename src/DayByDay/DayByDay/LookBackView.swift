import SwiftUI
import DayByDayKit

/// One commitment seen on its own, over everything since the day it is kept from. Reached by a
/// `NavigationLink` on `CommitmentsView`'s kept or stopped row. Draws `lookBack`'s fields and
/// lines in the order it says them, decides nothing and offers no control — `design.md` § *The
/// shell rides this Story*: the kit already answered every rule a page shows.
///
/// **Layout is Option B of the G7 proposal** (PR #280), amended by the `look-back-layout` shell
/// chore: the name had been said twice, once in the navigation bar and again as a `.largeTitle`
/// in the body, and the two half-width "Kept from"/"Kept until" cards wrapped a date like
/// "15 September 2026" onto a second line (walk W.3 on PR #280). The bar now carries the name
/// alone, as a large title that collapses to the inline title as the months scroll
/// (`.navigationBarTitleDisplayMode(.large)`), and the body's first line is the rhythm. The two
/// dates read as two rows of one card instead, label left and value right, wide enough that no
/// date wraps; a commitment still kept draws only the "Kept from" row rather than a "—" that
/// would say nothing. The "Months" heading and the `Grid` now carry the same horizontal inset as
/// the cards' own inner padding, so the month names and the card labels share a left edge and
/// the fractions share the cards' right edge. Still a hand-drawn `ScrollView` and `Grid` rather
/// than the platform `List` the rest of the shell is built from, so the whole — the one summary
/// figure this screen has — can read as a scoreboard rather than another row. The rhythm-change
/// line is the one composition among these seam strings: it joins the rhythm and its day with a
/// middle dot. Every other card and row draws exactly what `LookBack` hands it.
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
        .navigationBarTitleDisplayMode(.large)
    }

    @ViewBuilder
    private func head(_ lookBack: LookBack) -> some View {
        Text(lookBack.rhythmInWords)
            .font(.subheadline)
            .foregroundStyle(.secondary)
    }

    @ViewBuilder
    private func cards(_ lookBack: LookBack) -> some View {
        datesCard(lookBack)

        if let whole = lookBack.whole {
            card(label: "The whole") {
                Text(whole)
                    .font(.title.monospacedDigit())
            }
        }
    }

    /// "Kept from", and "Kept until" beneath it only where the commitment is no longer kept —
    /// `design.md` § *The shell rides this Story*. One card, not two: a date like
    /// "15 September 2026" does not fit a half-width card on one line.
    @ViewBuilder
    private func datesCard(_ lookBack: LookBack) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            dateRow(label: "Kept from", value: lookBack.keptFromInWords)
            if let keptUntilInWords = lookBack.keptUntilInWords {
                Divider()
                dateRow(label: "Kept until", value: keptUntilInWords)
            }
        }
        .padding()
        .background(.background, in: RoundedRectangle(cornerRadius: 12))
    }

    @ViewBuilder
    private func dateRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
            Spacer()
            Text(value)
        }
        .padding(.vertical, 6)
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
            // The extra `.padding(.horizontal)` below matches the cards' own inner padding, so
            // the month names and the rhythm-change line align with the cards' text rather than
            // the page's own edge.
            Text("Months")
                .font(.headline)
                .padding(.horizontal)
            Grid(alignment: .leading, horizontalSpacing: 12, verticalSpacing: 6) {
                ForEach(Array(lookBack.lines.enumerated()), id: \.offset) { _, line in
                    lookBackLine(line)
                }
            }
            .padding(.horizontal)
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
