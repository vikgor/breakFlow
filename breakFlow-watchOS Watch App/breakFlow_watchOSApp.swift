//
//  breakFlow_watchOSApp.swift
//  breakFlow-watchOS Watch App
//
//  Created by Viktor Gordienko on 9/3/24.
//

import SwiftUI

@main
struct breakFlow_watchOS_Watch_AppApp: App {
    @StateObject private var movesViewModel = MovesViewModel()
    
    var body: some Scene {
        WindowGroup {
            TabView {
                WatchFlowView(movesViewModel: movesViewModel)
                    .tabItem {
                        Label("Flow", systemImage: "shuffle")
                    }
                
                WatchSettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
            }
        }
    }
}
