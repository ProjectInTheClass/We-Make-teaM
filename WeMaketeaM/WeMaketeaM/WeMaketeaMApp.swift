//
//  WeMaketeaMApp.swift
//  WeMaketeaM
//
//  Created by 김현경 on 10/29/24.
//

import SwiftUI

@main
struct WeMaketeaMApp: App {
    @StateObject private var navigationManager = NavigationManager()

        var body: some Scene {
            WindowGroup {
                ContentView()
                    .environmentObject(navigationManager)
            }
        }
    }
