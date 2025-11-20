import Foundation

public enum AppGroupUserDefaults {
    public static let appGroupIdentifier = "group.com.bluecode.CountdownApp"

    public static func make() -> UserDefaults {
        if let defaults = UserDefaults(suiteName: appGroupIdentifier) {
            return defaults
        }
        // Fallback for Simulator/dev when App Group isn't fully provisioned
        return .standard
    }
}


