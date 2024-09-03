//
//  ContentView.swift
//  breakFlow
//
//  Created by Viktor Gordienko on 8/31/24.
//

import SwiftUI

#Preview {
    ContentView()
}

struct ContentView: View {
    @StateObject private var movesViewModel = MovesViewModel()
    
    var body: some View {
        TabView {
            NavigationView {
                FlowView(movesViewModel: movesViewModel)
            }
            .tabItem {
                Label("Flow", systemImage: "shuffle")
            }
            
            NavigationView {
                MovesListView(movesViewModel: movesViewModel)
            }
            .tabItem {
                Label("Moves", systemImage: "list.dash")
            }
            
            TimerView()
                .tabItem {
                    Label("30 sec", systemImage: "timer")
                }
        }
    }
}
