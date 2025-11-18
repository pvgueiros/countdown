import SwiftUI

public struct CountdownRowView: View {
    public let row: DateListViewModel.Row

    public init(row: DateListViewModel.Row) {
        self.row = row
    }

    public var body: some View {
        HStack(spacing: 14) {
            iconContainer

            VStack(alignment: .leading, spacing: 6) {
                Text(row.title)
                    .font(.headline)
                HStack(spacing: 6) {
                    Image(systemName: "calendar")
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(.secondary)
                    Text(row.dateText)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer(minLength: 12)

            VStack(alignment: .trailing, spacing: 6) {
                HStack(spacing: 8) {
                    if row.hasClockIcon {
                        Image(systemName: "clock")
                            .font(.headline.weight(.semibold))
                    }
                    Text(row.daysNumberText)
                        .font(.title2.weight(.bold))
                        .monospacedDigit()
                }
                .foregroundStyle(badgeForeground)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(badgeBackground)
                .clipShape(Capsule())
            }
        }
        .padding(.vertical, 14)
        .frame(minHeight: 88)
        // Make the entire row (including empty space) tappable when wrapped in a Button
        .contentShape(Rectangle())
    }

    private var entryColor: Color {
        Color(hex: row.entryColorHex) ?? .gray
    }

    private var iconContainer: some View {
        let bg = LinearGradient(
            colors: [entryColor.opacity(0.9), entryColor.opacity(0.6)],
            startPoint: .topLeading, endPoint: .bottomTrailing
        )
        return Image(systemName: row.iconSymbolName)
            .font(.system(size: 20, weight: .semibold))
            .foregroundStyle(.white)
            .frame(width: 28, height: 28, alignment: .center)
            .padding(14)
            .background(bg)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.white.opacity(0.15), lineWidth: 1)
            )
            .clipShape(.rect(cornerRadius: 16))
            .shadow(color: entryColor.opacity(0.25), radius: 8, x: 0, y: 4)
    }

    private var badgeBackground: some ShapeStyle {
        let color = Color(hex: row.backgroundColorHex) ?? .gray
        return AnyShapeStyle(color.opacity(0.15))
    }

    private var badgeForeground: some ShapeStyle {
        let color = Color(hex: row.backgroundColorHex) ?? .gray
        return AnyShapeStyle(color)
    }
}

#Preview {
    CountdownRowView(
        row: .init(
            id: UUID(),
            iconSymbolName: "airplane",
            title: "Sample Event",
            dateText: "Jan 1, 2026",
            entryColorHex: "#3366FF",
            daysNumberText: "10",
            backgroundColorHex: "#3366FF",
            hasClockIcon: true
        )
    )
    .padding()
}
