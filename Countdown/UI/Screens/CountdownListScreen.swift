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
                headerView

                if isEmpty {
                    emptyStateView
                } else {
                    listView
                }
            }
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .task {
                await viewModel.load()
//                mockData()
            }
        }
    }
    
    private func mockData() {
#if DEBUG
        if viewModel.rows.isEmpty && !ProcessInfo.processInfo.arguments.contains("UITEST_CLEAR_DATA") {
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
    
    @ViewBuilder
    private var headerView: some View {
        Text("Countdowns")
            .font(.largeTitle.bold())
        Text("Track your special moments")
            .font(.subheadline)
            .foregroundStyle(.secondary)
    }
   
    @ViewBuilder
    private var listView: some View {
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
    
    private var emptyStateView: some View {
        VStack(alignment: .center, spacing: 16) {
            Text("No Countdowns Yet")
                .font(.headline)
                .multilineTextAlignment(.center)

            Text("Add your first countdown to get started")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button(action: {
                // Placeholder action for now; will be wired in US4 (add/edit).
            }) {
                Text("Create Countdown")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(
                        LinearGradient(
                            colors: [Color.purple, Color.pink],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(Capsule())
                    .shadow(color: .pink.opacity(0.25), radius: 8, x: 0, y: 4)
            }
            .accessibilityIdentifier("empty_state_cta")
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 24)
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("empty_state_message")
    }

    private var currentRows: [DateListViewModel.Row] {
        selectedTab == 0 ? viewModel.upcomingRows : viewModel.pastRows
    }

    private var isEmpty: Bool {
        viewModel.upcomingRows.isEmpty && viewModel.pastRows.isEmpty
    }
}

#Preview("List of Dates") {
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

#Preview("Empty Date List") {
    CountdownListScreen(
        viewModel: DateListViewModel(
            repository: PreviewRepository(items: [])
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


