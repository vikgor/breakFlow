//
//  MovesListView.swift
//  breakFlow
//
//  Created by Viktor Gordienko on 9/3/24.
//

import SwiftUI

#Preview {
    MovesListView(movesViewModel: MovesViewModel())
}

struct MovesListView: View {
    @ObservedObject var movesViewModel: MovesViewModel
    @State private var showingAddMove = false
    
    var body: some View {
        List {
            ForEach(MoveType.allCases, id: \.self) { moveType in
                let movesForType = movesViewModel.moves.filter { $0.type == moveType }
                
                if !movesForType.isEmpty {
                    Section(header: Text(moveType.rawValue)) {
                        ForEach(movesForType) { move in
                            NavigationLink(
                                destination: MoveDetailView(
                                    move: move,
                                    movesViewModel: movesViewModel
                                )
                            ) {
                                Text(move.name)
                            }
                        }
                        .onDelete { indexSet in
                            let movesToDelete = movesForType
                                .enumerated()
                                .filter { indexSet.contains($0.offset) }
                                .map { $0.element }
                            
                            movesToDelete.forEach { move in
                                if let index = movesViewModel.moves.firstIndex(of: move) {
                                    movesViewModel.moves.remove(at: index)
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Moves")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showingAddMove = true
                }) {
                    Label("Add Move", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddMove) {
            AddMoveView(movesViewModel: movesViewModel)
        }
    }
}
