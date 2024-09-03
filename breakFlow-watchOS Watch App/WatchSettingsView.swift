//
//  WatchSettingsView.swift
//  breakFlow-watchOS Watch App
//
//  Created by Viktor Gordienko on 9/3/24.
//

import SwiftUI

#Preview {
    WatchSettingsView()
}

struct WatchSettingsView: View {
    @AppStorage("numberOfMoves") private var numberOfMoves = 5
    @AppStorage("includePowerMove") private var includePowerMove = true
    @AppStorage("trueRandom") private var trueRandom = false
    
    var body: some View {
        List {
            Picker("Moves", selection: $numberOfMoves) {
                ForEach(1...10, id: \.self) { number in
                    Text("\(number)").tag(number)
                }
            }
            Toggle("Include Power Move", isOn: $includePowerMove)
            Toggle("True Random", isOn: $trueRandom)
        }
    }
}
