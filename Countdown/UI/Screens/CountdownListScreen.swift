import SwiftUI

public struct CountdownListScreen: View {
    @StateObject private var viewModel: DateListViewModel

    public init(viewModel: DateListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Countdowns")
                    .font(.largeTitle.bold())
                Text("Track important dates")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                List(viewModel.rows) { row in
                    CountdownRowView(row: row)
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                }
                .listStyle(.plain)
            }
            .padding(.horizontal, 16)
            .task {
                await viewModel.load()
                #if DEBUG
                if viewModel.rows.isEmpty {
                    let samples: [DateOfInterest] = [
                        DateOfInterest(
                            title: "My Birthday",
                            date: Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date(),
                            iconSymbolName: "gift.fill",
                            entryColorHex: "#FF3B30"
                        ),
                        DateOfInterest(
                            title: "Conference",
                            date: Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date(),
                            iconSymbolName: "calendar",
                            entryColorHex: "#0A84FF"
                        ),
                        DateOfInterest(
                            title: "Travel",
                            date: Date().addingTimeInterval(-60 * 60 * 24 * 41),
                            iconSymbolName: "airplane.up.right",
                            entryColorHex: "#00C300"
                        )
                    ]
                    viewModel.setItems(samples)
                }
                #endif
            }
        }
    }
}

#Preview {
    let repo = PreviewRepository(items: [
        DateOfInterest(
            title: "My Birthday",
            date: Date().addingTimeInterval(60 * 60 * 24 * 30),
            iconSymbolName: "gift.fill",
            entryColorHex: "#FF3B30"
        ),
        DateOfInterest(
            title: "Conference",
            date: Date().addingTimeInterval(60 * 60 * 24 * 7),
            iconSymbolName: "calendar",
            entryColorHex: "#0A84FF"
        ),
        DateOfInterest(
            title: "Travel",
            date: Date().addingTimeInterval(-60 * 60 * 24 * 41),
            iconSymbolName: "airplane.up.right",
            entryColorHex: "#00C300"
        )
    ])
    return CountdownListScreen(
        viewModel: DateListViewModel(
            repository: repo
        )
    )
}

// MARK: - Previews Support
private struct PreviewRepository: DateOfInterestRepository {
    let items: [DateOfInterest]
    init(items: [DateOfInterest]) { self.items = items }
    func fetchAll() async throws -> [DateOfInterest] { items }
    func add(_ item: DateOfInterest) async throws {}
    func update(_ item: DateOfInterest) async throws {}
}


