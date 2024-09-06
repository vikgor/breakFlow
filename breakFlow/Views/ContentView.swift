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
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var body: some View {
        Group {
            if horizontalSizeClass == .regular {
                // iPad layout
                NavigationView {
                    List {
                        NavigationLink(destination: FlowView(movesViewModel: movesViewModel)) {
                            Label("Flow", systemImage: "shuffle")
                        }
                        NavigationLink(destination: MovesListView(movesViewModel: movesViewModel)) {
                            Label("Moves", systemImage: "list.dash")
                        }
                        NavigationLink(destination: TimerView()) {
                            Label("30 sec", systemImage: "timer")
                        }
                    }
                    .listStyle(SidebarListStyle())
                    .frame(minWidth: 200)
                    
                    FlowView(movesViewModel: movesViewModel)
                }
            } else {
                // iPhone layout
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
                    
                    NavigationView {
                        TimerView()
                    }
                    .tabItem {
                        Label("30 sec", systemImage: "timer")
                    }
                }
            }
        }
    }
}
