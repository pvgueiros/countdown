import Foundation

// Placeholder mapper for potential DTO conversions.
public nonisolated enum EventMapper {
    public struct DTO: Codable, Equatable, Identifiable {
        public let id: UUID
        public var title: String
        public var date: Date
        public var iconSymbolName: String
        public var eventColorHex: String
        public let createdAt: Date
    }
    
    public static func toDTO(_ event: Event) -> DTO {
        DTO(
            id: event.id,
            title: event.title,
            date: event.date,
            iconSymbolName: event.iconSymbolName,
            eventColorHex: event.eventColorHex,
            createdAt: event.createdAt
        )
    }
    
    public static func fromDTO(_ dto: DTO) -> Event {
        Event(
            id: dto.id,
            title: dto.title,
            date: dto.date,
            iconSymbolName: dto.iconSymbolName,
            eventColorHex: dto.eventColorHex,
            createdAt: dto.createdAt
        )
    }
}

