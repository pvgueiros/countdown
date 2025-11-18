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
            .font(.title3.weight(.semibold))
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
        // If the badge background is gray (past), use the system primary color for optimal contrast.
        if row.backgroundColorHex == DateListViewModel.Row.grayBackgroundColorHex {
            return AnyShapeStyle(Color.primary)
        }
        // For colored backgrounds (today/future), adjust the entry color to ensure sufficient contrast
        // on a light-tinted background by darkening very light colors.
        let adjusted = adjustedForegroundColor(for: row.backgroundColorHex)
        return AnyShapeStyle(adjusted)
    }

    // MARK: - Contrast Helpers

    /// Returns a color suitable for foreground text based on the provided base hex.
    /// Light colors are darkened to preserve contrast against a light-tinted background.
    private func adjustedForegroundColor(for hex: String) -> Color {
        guard let (r, g, b) = rgb(fromHex: hex) else {
            return .gray
        }
        // Perceived brightness using YIQ approximation
        let yiq = (299.0 * r + 587.0 * g + 114.0 * b) / 1000.0
        if yiq >= 200 { // very light color – darken it
            let factor = 0.6
            return Color(red: (r * factor) / 255.0, green: (g * factor) / 255.0, blue: (b * factor) / 255.0)
        } else {
            // Use original color
            return Color(red: r / 255.0, green: g / 255.0, blue: b / 255.0)
        }
    }

    /// Parses a hex string like "#RRGGBB" into 0...255 RGB components.
    private func rgb(fromHex hex: String) -> (Double, Double, Double)? {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if hexString.hasPrefix("#") { hexString.removeFirst() }
        guard hexString.count == 6, let value = UInt32(hexString, radix: 16) else { return nil }
        let r = Double((value >> 16) & 0xFF)
        let g = Double((value >> 8) & 0xFF)
        let b = Double(value & 0xFF)
        return (r, g, b)
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
