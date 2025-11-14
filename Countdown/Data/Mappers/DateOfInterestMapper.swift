import Foundation

// Placeholder mapper for potential DTO conversions.
public nonisolated enum DateOfInterestMapper {
    public struct DTO: Codable, Equatable, Identifiable {
        public let id: UUID
        public var title: String
        public var date: Date
        public var iconSymbolName: String
        public var entryColorHex: String
        public let createdAt: Date
    }

    public static func toDTO(_ entity: DateOfInterest) -> DTO {
        DTO(
            id: entity.id,
            title: entity.title,
            date: entity.date,
            iconSymbolName: entity.iconSymbolName,
            entryColorHex: entity.entryColorHex,
            createdAt: entity.createdAt
        )
    }

    public static func fromDTO(_ dto: DTO) -> DateOfInterest {
        DateOfInterest(
            id: dto.id,
            title: dto.title,
            date: dto.date,
            iconSymbolName: dto.iconSymbolName,
            entryColorHex: dto.entryColorHex,
            createdAt: dto.createdAt
        )
    }
}


