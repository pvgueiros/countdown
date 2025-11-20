import Foundation

public actor UserDefaultsDateOfInterestRepository: DateOfInterestRepository {
    private let key = "datesOfInterest"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let userDefaults: UserDefaults

    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        self.encoder.dateEncodingStrategy = .iso8601
        self.decoder.dateDecodingStrategy = .iso8601
    }

    public func fetchAll() async throws -> [DateOfInterest] {
        guard let data = userDefaults.data(forKey: key) else { return [] }
        let dtos = try decoder.decode([DateOfInterestMapper.DTO].self, from: data)
        return dtos.map { DateOfInterestMapper.fromDTO($0) }
    }

    private func saveAll(_ items: [DateOfInterest]) throws {
        let dtos = items.map { DateOfInterestMapper.toDTO($0) }
        let data = try encoder.encode(dtos)
        userDefaults.set(data, forKey: key)
    }

    public func add(_ item: DateOfInterest) async throws {
        var items = try await fetchAll()
        items.append(item)
        try saveAll(items)
    }

    public func update(_ item: DateOfInterest) async throws {
        var items = try await fetchAll()
        if let idx = items.firstIndex(where: { $0.id == item.id }) {
            items[idx] = item
            try saveAll(items)
        }
    }

    public func delete(_ id: UUID) async throws {
        var items = try await fetchAll()
        items.removeAll { $0.id == id }
        try saveAll(items)
    }
}


