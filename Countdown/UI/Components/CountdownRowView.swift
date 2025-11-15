import SwiftUI

public struct CountdownRowView: View {
    public let row: DateListViewModel.Row

    public init(row: DateListViewModel.Row) {
        self.row = row
    }

    public var body: some View {
        HStack(spacing: 12) {
            Image(systemName: row.iconSymbolName)
                .foregroundStyle(.primary)
                .frame(width: 28, height: 28, alignment: .center)
                .padding(8)
                .background(
                    Group {
                        if let color = Color(hex: row.entryColorHex) {
                            color.opacity(0.15)
                        } else {
                            Color.gray.opacity(0.15)
                        }
                    }
                )
                .clipShape(.rect(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 4) {
                Text(row.title)
                    .font(.headline)
                Text(row.dateText)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 12)

            Text(row.countdownText)
                .font(.subheadline.weight(.semibold))
                .multilineTextAlignment(.trailing)
                .foregroundStyle(.primary)
        }
        .padding(.vertical, 6)
    }
}

#Preview {
    CountdownRowView(
        row: .init(
            id: UUID(),
            iconSymbolName: "calendar",
            title: "Sample Event",
            dateText: "Jan 1, 2025",
            countdownText: "10 days left",
            entryColorHex: "#3366FF"
        )
    )
    .padding()
}


