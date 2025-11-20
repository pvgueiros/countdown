import Foundation
import AppIntents

struct DateOfInterestAppEntity: AppEntity, Identifiable {
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Date of Interest"

    static var defaultQuery = DateOfInterestQuery()

    let id: UUID
    let title: String
    let date: Date

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(title)")
    }
}

struct DateOfInterestQuery: EntityQuery {
    struct DTO: Codable, Identifiable {
        let id: UUID
        let title: String
        let date: Date
    }

    func entities(for identifiers: [UUID]) async throws -> [DateOfInterestAppEntity] {
        let all = try await suggestedEntities()
        let set = Set(identifiers)
        return all.filter { set.contains($0.id) }
    }

    func suggestedEntities() async throws -> [DateOfInterestAppEntity] {
        // Read from shared App Group storage
        let suite = UserDefaults(suiteName: "group.com.bluecode.CountdownApp") ?? .standard
        guard let data = suite.data(forKey: "datesOfInterest") else { return [] }
        // Decode only fields we need
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        guard let dtos = try? decoder.decode([DTO].self, from: data) else { return [] }
        return dtos.map { dto in
            DateOfInterestAppEntity(id: dto.id, title: dto.title, date: dto.date)
        }
    }
}


