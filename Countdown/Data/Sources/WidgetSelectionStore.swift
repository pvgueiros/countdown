import Foundation

public struct WidgetSelection {
    public let widgetId: String
    public let selectedEventId: String
    public let lastDisplayTitle: String
    public let lastDisplayDateString: String
}

public final class WidgetSelectionStore {
    private let userDefaults: UserDefaults

    public init(userDefaults: UserDefaults = AppGroupUserDefaults.make()) {
        self.userDefaults = userDefaults
    }

    private func key(_ widgetId: String, _ suffix: String) -> String {
        "widget.selection.\(widgetId).\(suffix)"
    }

    public func saveSelection(widgetId: String, eventId: String, titleSnapshot: String, dateStringSnapshot: String) {
        userDefaults.set(eventId, forKey: key(widgetId, "eventId"))
        userDefaults.set(titleSnapshot, forKey: key(widgetId, "title"))
        userDefaults.set(dateStringSnapshot, forKey: key(widgetId, "dateString"))
    }

    public func loadSelection(widgetId: String) -> WidgetSelection? {
        guard
            let eventId = userDefaults.string(forKey: key(widgetId, "eventId")),
            let title = userDefaults.string(forKey: key(widgetId, "title")),
            let dateString = userDefaults.string(forKey: key(widgetId, "dateString"))
        else { return nil }
        return WidgetSelection(
            widgetId: widgetId,
            selectedEventId: eventId,
            lastDisplayTitle: title,
            lastDisplayDateString: dateString
        )
    }

    public func clearSelection(widgetId: String) {
        userDefaults.removeObject(forKey: key(widgetId, "eventId"))
        userDefaults.removeObject(forKey: key(widgetId, "title"))
        userDefaults.removeObject(forKey: key(widgetId, "dateString"))
    }
}


