import Foundation

public nonisolated struct Event: Equatable, Identifiable {
    public let id: UUID
    public var title: String
    public var date: Date
    public var iconSymbolName: String
    public var eventColorHex: String
    public let createdAt: Date

    public init(
        id: UUID = UUID(),
        title: String,
        date: Date,
        iconSymbolName: String,
        eventColorHex: String,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.date = date
        self.iconSymbolName = iconSymbolName
        self.eventColorHex = eventColorHex
        self.createdAt = createdAt
    }
}
