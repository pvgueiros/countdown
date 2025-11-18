//
//  CountdownApp.swift
//  Countdown
//
//  Created by Paula Vasconcelos Gueiros on 3/10/25.
//

import SwiftUI
import SwiftData
import Foundation
internal import os

@main
struct CountdownApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

private struct RootView: View {
    init() {
        // Preload data for UI tests if requested
        let args = ProcessInfo.processInfo.arguments
        if args.contains("UITEST_CLEAR_DATA") {
            UserDefaults.standard.removeObject(forKey: "datesOfInterest")
        }
        if args.contains("UITEST_PRELOAD_DATA") {
            TestDataPreloader.preloadSampleData()
        }
    }
    var body: some View {
        AppCoordinator().rootView()
    }
}

private enum TestDataPreloader {
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
}
