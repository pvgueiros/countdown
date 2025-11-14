import Foundation

public actor UserDefaultsDateOfInterestRepository: DateOfInterestRepository {
    private let defaults: UserDefaults
    private let key = "datesOfInterest"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    public init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        self.encoder.dateEncodingStrategy = .iso8601
        self.decoder.dateDecodingStrategy = .iso8601
    }

    public func fetchAll() async throws -> [DateOfInterest] {
        guard let data = defaults.data(forKey: key) else { return [] }
        return try decoder.decode([DateOfInterest].self, from: data)
    }

    private func saveAll(_ items: [DateOfInterest]) throws {
        let data = try encoder.encode(items)
        defaults.set(data, forKey: key)
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
}


