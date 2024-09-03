//
//  FlowView.swift
//  breakFlow
//
//  Created by Viktor Gordienko on 9/3/24.
//

import SwiftUI

#Preview {
    FlowView(movesViewModel: MovesViewModel())
}

struct FlowView: View {
    @ObservedObject var movesViewModel: MovesViewModel
    @AppStorage("numberOfMoves") private var numberOfMoves = 5
    @AppStorage("includePowerMove") private var includePowerMove = true
    @AppStorage("trueRandom") private var trueRandom = false
    @State private var shuffledMoves: [Move] = []
    @State private var showingConfiguration = false
    
    var body: some View {
        VStack {
            Spacer()
            
            if !shuffledMoves.isEmpty {
                VStack(alignment: .center, spacing: 10) {
                    ForEach(shuffledMoves) { move in
                        Text(move.name)
                            .font(.title2)
                    }
                }
                .padding()
            } else {
                Text("Press the button to get a new list of moves")
            }
            Spacer()
            
            Button("New Flow") {
                shuffleMoves()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding()
        }
        .navigationTitle("Flow")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showingConfiguration = true
                }) {
                    Image(systemName: "gearshape")
                }
            }
        }
        .sheet(isPresented: $showingConfiguration) {
            ConfigurationView(
                numberOfMoves: $numberOfMoves,
                includePowerMove: $includePowerMove,
                trueRandom: $trueRandom,
                movesViewModel: movesViewModel
            )
        }
    }
    
    private func shuffleMoves() {
        shuffledMoves = MovesViewModel.structuredShuffle(
            moves: movesViewModel.moves,
            numberOfMoves: numberOfMoves,
            includePowerMove: includePowerMove,
            trueRandom: trueRandom
        )
    }
}
