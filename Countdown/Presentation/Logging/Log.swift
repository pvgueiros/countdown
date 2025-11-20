import OSLog

public enum Log {
    public static let subsystem = "com.bluecode.CountdownApp"
    public static let general = Logger(subsystem: subsystem, category: "general")
}


