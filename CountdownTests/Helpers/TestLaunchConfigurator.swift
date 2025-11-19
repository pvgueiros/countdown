//
//  TestLaunchConfigurator.swift
//  Countdown
//
//  Created by Paula Vasconcelos Gueiros on 11/19/25.
//

#if DEBUG

import Foundation
internal import os

enum TestLaunchConfigurator {
    static func applyFromLaunchArguments(_ arguments: [String] = ProcessInfo.processInfo.arguments) {
        if arguments.contains("UITEST_CLEAR_DATA") {
            UserDefaults.standard.removeObject(forKey: "datesOfInterest")
        }
        if arguments.contains("UITEST_PRELOAD_DATA") {
            TestDataPreloader.preloadSampleData()
        }
        if arguments.contains("UITEST_PRELOAD_100") {
            TestDataPreloader.preload(count: 100)
        }
    }
}

enum TestDataPreloader {
    static func preloadSampleData() {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let items: [DateOfInterestMapper.DTO] = [
            .init(
                id: UUID(),
                title: "My Birthday",
                date: Calendar.current.date(byAdding: .day, value: 10, to: Date()) ?? Date(),
                iconSymbolName: "gift.fill",
                entryColorHex: "#FF3B30",
                createdAt: Date()
            ),
            .init(
                id: UUID(),
                title: "Conference",
                date: Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date(),
                iconSymbolName: "calendar",
                entryColorHex: "#0A84FF",
                createdAt: Date()
            ),
            .init(
                id: UUID(),
                title: "Travel",
                date: Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date(),
                iconSymbolName: "airplane.up.right",
                entryColorHex: "#00C300",
                createdAt: Date()
            )
        ]
        do {
            let data = try encoder.encode(items)
            UserDefaults.standard.set(data, forKey: "datesOfInterest")
        } catch {
            Log.general.error("Failed to preload test data: \(String(describing: error), privacy: .public)")
        }
    }
    
    static func preload(count: Int) {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        var items: [DateOfInterestMapper.DTO] = []
        let calendar = Calendar.current
        let now = Date()
        for i in 0..<count {
            let offsetDays = (i % 2 == 0) ? i : -i
            let date = calendar.date(byAdding: .day, value: offsetDays, to: now) ?? now
            let colorHexes = ["#FF9500", "#FF2D55", "#AF52DE", "#34C759", "#0A84FF", "#FF3B30"]
            let color = colorHexes[i % colorHexes.count]
            let symbolNames = ["calendar", "gift.fill", "airplane", "heart", "graduationcap", "party.popper"]
            let symbol = symbolNames[i % symbolNames.count]
            items.append(.init(
                id: UUID(),
                title: "Item \(i + 1)",
                date: date,
                iconSymbolName: symbol,
                entryColorHex: color,
                createdAt: now.addingTimeInterval(TimeInterval(i))
            ))
        }
        do {
            let data = try encoder.encode(items)
            UserDefaults.standard.set(data, forKey: "datesOfInterest")
        } catch {
            Log.general.error("Failed to preload \(count) items: \(String(describing: error), privacy: .public)")
        }
    }
}

#endif


