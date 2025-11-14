import Foundation

public enum DateFormatterProvider {
    public static func mediumLocaleFormatter() -> DateFormatter {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .none
        df.locale = .current
        return df
    }
}


