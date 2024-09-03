//
//  MoveDetailView.swift
//  breakFlow
//
//  Created by Viktor Gordienko on 9/3/24.
//

import SwiftUI

#Preview {
    MoveDetailView(move: Move(), movesViewModel: MovesViewModel())
}

struct MoveDetailView: View {
    var move: Move
    @ObservedObject var movesViewModel: MovesViewModel
    @State private var name: String
    @State private var type: MoveType
    @Environment(\.presentationMode) var presentationMode

    init(move: Move, movesViewModel: MovesViewModel) {
        self.move = move
        self.movesViewModel = movesViewModel
        _name = State(initialValue: move.name)
        _type = State(initialValue: move.type)
    }
    
    var body: some View {
        Form {
            TextField("Move Name", text: $name)
            Picker("Type", selection: $type) {
                ForEach(MoveType.allCases) { moveType in
                    Text(moveType.rawValue.capitalized).tag(moveType)
                }
            }
        }
        .navigationTitle("Edit Move")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    movesViewModel.editMove(move: move, name: name, type: type)
                    presentationMode.wrappedValue.dismiss() // Navigate back after saving
                }
                .disabled(name.isEmpty)  // Disable the Save button if the name is empty
            }
        }
    }
}

