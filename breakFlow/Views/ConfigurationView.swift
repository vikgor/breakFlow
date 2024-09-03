//
//  ConfigurationView.swift
//  breakFlow
//
//  Created by Viktor Gordienko on 9/3/24.
//

import SwiftUI

#Preview {
    ConfigurationView(
        numberOfMoves: .constant(5),
        includePowerMove: .constant(true),
        trueRandom: .constant(false),
        movesViewModel: MovesViewModel()
    )
}

struct ConfigurationView: View {
    @Binding var numberOfMoves: Int
    @Binding var includePowerMove: Bool
    @Binding var trueRandom: Bool
    @ObservedObject var movesViewModel: MovesViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Picker("Number of Moves", selection: $numberOfMoves) {
                    ForEach(1..<11) { number in
                        Text("\(number)").tag(number)
                    }
                }
                
                Toggle("Include powerMove", isOn: $includePowerMove)
                
                Toggle("True Random", isOn: $trueRandom)
                
                Text("Truly random flow might include 5 power moves in a row")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.top, 5)
                
                Section(header: Text("Enable/Disable Moves")) {
                    ForEach($movesViewModel.moves) { $move in
                        Toggle(move.name, isOn: $move.isEnabled)
                    }
                }
            }
            .navigationTitle("Configuration")
        }
    }
}
