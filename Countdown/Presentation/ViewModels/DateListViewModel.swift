import Foundation
import Combine
internal import os

@MainActor
public final class DateListViewModel: ObservableObject {
    // MARK: - Row Model
    public struct Row: Identifiable, Equatable {
        public let id: UUID
        public let iconSymbolName: String
        public let title: String
        public let dateText: String
        public let countdownText: String
        public let entryColorHex: String
    }

    // MARK: - Dependencies
    private let repository: any DateOfInterestRepository
    private let dateString: (Date) -> String
    private let countdownString: (Date) -> String

    // MARK: - State
    @Published public private(set) var rows: [Row] = []

    // MARK: - Init
    public init(
        repository: any DateOfInterestRepository,
        dateString: @escaping (Date) -> String = { DateFormatterProvider.mediumLocaleFormatter().string(from: $0) },
        countdownString: @escaping (Date) -> String = { CountdownFormatter.string(for: $0) }
    ) {
        self.repository = repository
        self.dateString = dateString
        self.countdownString = countdownString
    }

    // MARK: - API
    public func load() async {
        do {
            let items = try await repository.fetchAll()
            self.rows = mapRows(from: items)
        } catch {
            Log.general.error("Failed to load items: \(String(describing: error), privacy: .public)")
            self.rows = []
        }
    }

    public func setItems(_ items: [DateOfInterest]) {
        self.rows = mapRows(from: items)
    }

    // MARK: - Mapping
    private func mapRows(from items: [DateOfInterest]) -> [Row] {
        items.map { item in
            Row(
                id: item.id,
                iconSymbolName: item.iconSymbolName,
                title: item.title,
                dateText: dateString(item.date),
                countdownText: countdownString(item.date),
                entryColorHex: item.entryColorHex
            )
        }
    }
}


