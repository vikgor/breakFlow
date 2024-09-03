//
//  WatchFlowView.swift
//  breakFlow-watchOS Watch App
//
//  Created by Viktor Gordienko on 9/3/24.
//

import SwiftUI

#Preview {
    WatchFlowView(movesViewModel: MovesViewModel())
}

struct WatchFlowView: View {
    @ObservedObject var movesViewModel: MovesViewModel
    @AppStorage("numberOfMoves") private var numberOfMoves = 5
    @AppStorage("includePowerMove") private var includePowerMove = true
    @AppStorage("trueRandom") private var trueRandom = false
    @State private var shuffledMoves: [Move] = []

    var body: some View {
        VStack {
            if !shuffledMoves.isEmpty {
                List {
                    ForEach(shuffledMoves) { move in
                        Text(move.name)
                    }
                }
            } else {
                Text("Tap to generate moves")
            }
            
            Button("New Flow") {
                shuffleMoves()
            }
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
