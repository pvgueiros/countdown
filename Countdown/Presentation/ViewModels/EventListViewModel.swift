import Foundation
import Combine
internal import os

@MainActor
public final class EventListViewModel: ObservableObject {
    
    // MARK: - Row Model
    
    public struct Row: Identifiable, Equatable {
        static let grayBackgroundColorHex: String = "#808080"
        
        public let id: UUID
        public let iconSymbolName: String
        public let title: String
        public let dateText: String
        public let eventColorHex: String
        public let daysNumberText: String
        public let backgroundColorHex: String
        public let hasClockIcon: Bool
    }

    // MARK: - Dependencies
    
    private let repository: any EventRepository
    private let dateString: (Date) -> String

    // MARK: - State
    
    @Published public private(set) var rows: [Row] = []
    @Published public private(set) var upcomingRows: [Row] = []
    @Published public private(set) var pastRows: [Row] = []
    @Published public private(set) var items: [Event] = []

    // MARK: - Init
    
    public init(
        repository: any EventRepository,
        dateString: @escaping (Date) -> String = { DateFormatterProvider.mediumLocaleFormatter().string(from: $0) }
    ) {
        self.repository = repository
        self.dateString = dateString
    }

    // MARK: - API
    
    public func load() async {
        do {
            let items = try await repository.fetchAll()
            self.rows = mapRows(from: items)
            self.items = items
            
            let partitions = GetEventsPartitionedUseCase().execute(items: items)
            self.upcomingRows = mapRows(from: partitions.upcoming)
            self.pastRows = mapRows(from: partitions.past)
        } catch {
            Log.general.error("Failed to load items: \(String(describing: error), privacy: .public)")
            self.rows = []
            self.items = []
            self.upcomingRows = []
            self.pastRows = []
        }
    }

    public func setItems(_ items: [Event]) {
        self.rows = mapRows(from: items)
        self.items = items
        
        let partitions = GetEventsPartitionedUseCase().execute(items: items)
        self.upcomingRows = mapRows(from: partitions.upcoming)
        self.pastRows = mapRows(from: partitions.past)
    }

    // MARK: - Mapping
    
    private func mapRows(from items: [Event]) -> [Row] {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())
        
        func startOfDay(_ date: Date) -> Date { calendar.startOfDay(for: date) }
        
        return items.map { item in
            let startTarget = startOfDay(item.date)
            let delta = calendar.dateComponents([.day], from: startOfToday, to: startTarget).day ?? 0
            let isToday = startTarget == startOfToday
            let isFuture = delta > 0
            
            let daysNumber = isToday ? 0 : abs(delta)
            let daysNumberText = isToday ? "Today" : (isFuture ? "\(daysNumber)" : "- \(daysNumber)")
            let backgroundColorHex = (isToday || isFuture) ? item.eventColorHex : Row.grayBackgroundColorHex
            
            return Row(
                id: item.id,
                iconSymbolName: item.iconSymbolName,
                title: item.title,
                dateText: dateString(item.date),
                eventColorHex: item.eventColorHex,
                daysNumberText: daysNumberText,
                backgroundColorHex: backgroundColorHex,
                hasClockIcon: isFuture
            )
        }
    }

    // MARK: - Actions
    public func item(for id: UUID) -> Event? {
        items.first(where: { $0.id == id })
    }

    public func delete(id: UUID) async {
        do {
            try await repository.delete(id)
            await load()
        } catch {
            Log.general.error("Failed to delete: \(String(describing: error), privacy: .public)")
        }
    }
}
