import OSLog

public enum Log {
    public static let subsystem = "com.arctouch.Countdown"
    public static let general = Logger(subsystem: subsystem, category: "general")
}


