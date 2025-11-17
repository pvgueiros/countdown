import SwiftUI

public struct CountdownListScreen: View {
    @StateObject private var viewModel: DateListViewModel
    @State private var selectedTab: Int = 0

    public init(viewModel: DateListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Countdowns")
                    .font(.largeTitle.bold())
                Text("Track your special moments")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Picker("Sections", selection: $selectedTab) {
                    Text("Upcoming").tag(0)
                    Text("Past").tag(1)
                }
                .pickerStyle(.segmented)

                List(currentRows) { row in
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
                            date: Date().addingTimeInterval(60 * 60 * 24 * 30),
                            iconSymbolName: "gift.fill",
                            entryColorHex: "#FF4D9F"
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
                    ]
                    viewModel.setItems(samples)
                }
                #endif
            }
        }
    }

    private var currentRows: [DateListViewModel.Row] {
        selectedTab == 0 ? viewModel.upcomingRows : viewModel.pastRows
    }
}

#Preview {
    let repo = PreviewRepository(items: [
        DateOfInterest(
            title: "My Birthday",
            date: Date().addingTimeInterval(60 * 60 * 24 * 30),
            iconSymbolName: "gift.fill",
            entryColorHex: "#FF4D9F"
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


