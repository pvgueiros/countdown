import Foundation

public struct DateOfInterest: Equatable, Identifiable {
    public let id: UUID
    public var title: String
    public var date: Date
    public var iconSymbolName: String
    public var entryColorHex: String
    public let createdAt: Date

    public init(
        id: UUID = UUID(),
        title: String,
        date: Date,
        iconSymbolName: String,
        entryColorHex: String,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.date = date
        self.iconSymbolName = iconSymbolName
        self.entryColorHex = entryColorHex
        self.createdAt = createdAt
    }
}


