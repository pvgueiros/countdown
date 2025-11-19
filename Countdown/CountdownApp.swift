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
        #if DEBUG
        TestLaunchConfigurator.applyFromLaunchArguments()
        #endif
    }
    var body: some View {
        AppCoordinator().rootView()
    }
}
