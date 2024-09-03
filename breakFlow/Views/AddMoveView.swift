//
//  AddMoveView.swift
//  breakFlow
//
//  Created by Viktor Gordienko on 9/3/24.
//

import SwiftUI

#Preview {
    AddMoveView(movesViewModel: MovesViewModel())
}

struct AddMoveView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var movesViewModel: MovesViewModel
    @State private var name: String = ""
    @State private var type: MoveType = .topRock
    @AppStorage("lastSelectedMoveType") private var lastSelectedMoveType: MoveType = .topRock
    
    init(movesViewModel: MovesViewModel) {
        self.movesViewModel = movesViewModel
        _type = State(initialValue: lastSelectedMoveType)
    }
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Move Name", text: $name)
                Picker("Type", selection: $type) {
                    ForEach(MoveType.allCases) { moveType in
                        Text(moveType.rawValue.capitalized).tag(moveType)
                    }
                }
            }
            .navigationTitle("New Move")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        movesViewModel.addMove(Move(name: name, type: type))
                        lastSelectedMoveType = type // Save the selected type
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(name.isEmpty)  // Disable the Save button if the name is empty
                }
            }
        }
    }
}
