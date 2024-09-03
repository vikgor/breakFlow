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

struct Move: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var type: MoveType
    var isEnabled: Bool = true
}

enum MoveType: String, CaseIterable, Codable, Identifiable {
    case topRock
    case drop
    case footWork
    case powerMove
    case tricks
    case freeze
    
    var id: String { self.rawValue }
}

class MovesViewModel: ObservableObject {
    @Published var moves: [Move] = [
        Move(name: "Top Rock", type: .topRock),
        Move(name: "Indian Step", type: .topRock),
        Move(name: "Side Step", type: .topRock),
        Move(name: "Bronx Step", type: .topRock),
        Move(name: "Knee Drop", type: .drop),
        Move(name: "Spin Down (Corkscrew)", type: .drop),
        Move(name: "Parachute Drop", type: .drop),
        Move(name: "Leg Sweep", type: .drop),
        Move(name: "Shuffle Step", type: .footWork),
        Move(name: "6 step", type: .footWork),
        Move(name: "4 Step", type: .footWork),
        Move(name: "3 Step", type: .footWork),
        Move(name: "2 Step (Scramble)", type: .footWork),
        Move(name: "2 Step Sweep", type: .footWork),
        Move(name: "CC", type: .footWork),
        Move(name: "CC Invert", type: .footWork),
        Move(name: "Baby Love", type: .footWork),
        Move(name: "Zulu Spin", type: .footWork),
        Move(name: "Double Zulu Spin", type: .footWork),
        Move(name: "Backspin", type: .powerMove),
        Move(name: "2 Step Bellymill", type: .powerMove),
        Move(name: "Windmill", type: .powerMove),
        Move(name: "Swipe", type: .powerMove),
        Move(name: "Swipe 2 Feet", type: .powerMove),
        Move(name: "Turtle", type: .powerMove),
        Move(name: "Munchmill", type: .powerMove),
        Move(name: "Baby Freeze", type: .freeze),
        Move(name: "Chair", type: .freeze),
        Move(name: "Shoulder Freeze", type: .freeze),
        Move(name: "Air Baby", type: .freeze),
        Move(name: "Handstand", type: .freeze)
    ] {
        didSet {
            saveMoves()
        }
    }
    
    private let movesKey = "savedMoves"
    
    init() {
        loadMoves()
    }
    
    func addMove(_ move: Move) {
        moves.append(move)
    }
    
    func deleteMove(at offsets: IndexSet) {
        moves.remove(atOffsets: offsets)
    }
    
    func editMove(move: Move, name: String, type: MoveType) {
        if let index = moves.firstIndex(where: { $0.id == move.id }) {
            moves[index].name = name
            moves[index].type = type
        }
    }
    
    private func saveMoves() {
        if let encodedMoves = try? JSONEncoder().encode(moves) {
            UserDefaults.standard.set(encodedMoves, forKey: movesKey)
        }
    }
    
    private func loadMoves() {
        if let savedMovesData = UserDefaults.standard.data(forKey: movesKey),
           let savedMoves = try? JSONDecoder().decode([Move].self, from: savedMovesData) {
            moves = savedMoves
        }
    }
    
    static func structuredShuffle(
        moves: [Move],
        numberOfMoves: Int
    ) -> [Move] {
        var result = [Move]()
        
        // Filter out disabled moves
        let enabledMoves = moves.filter { $0.isEnabled }
        
        var entries = enabledMoves.filter { $0.type == .drop }
        var topRocks = enabledMoves.filter { $0.type == .topRock }
        var others = enabledMoves.filter { $0.type == .footWork || $0.type == .powerMove || $0.type == .tricks }
        var freezes = enabledMoves.filter { $0.type == .freeze }
        
        // Add one entry move if available
        if let entry = entries.randomElement(), result.count < numberOfMoves {
            result.append(entry)
            entries.removeAll { $0.id == entry.id }
        }
        
        // Add a random topRock move
        if let topRock = topRocks.randomElement(), result.count < numberOfMoves {
            result.append(topRock)
            topRocks.removeAll { $0.id == topRock.id }
        }
        
        // Add footWork/powerMove/tricks moves with rules
        while !others.isEmpty && result.count < numberOfMoves {
            if let nextMove = others.randomElement() {
                if result.last?.type == .powerMove && nextMove.type == .powerMove {
                    // Prevent more than 1 powerMove in a row
                    others = others.filter { $0.type != .powerMove }
                }
                result.append(nextMove)
                others.removeAll { $0.id == nextMove.id }
            }
        }
        
        // Add a freeze move if available
        if let freeze = freezes.randomElement(), result.count < numberOfMoves {
            result.append(freeze)
            freezes.removeAll { $0.id == freeze.id }
        }
        
        // Ensure we do not exceed the number of moves specified
        if result.count > numberOfMoves {
            result = Array(result.prefix(numberOfMoves))
        }
        
        return result
    }
}

// MARK: - ContentView

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

// MARK: - Flow

struct FlowView: View {
    @ObservedObject var movesViewModel: MovesViewModel
    @AppStorage("numberOfMoves") private var numberOfMoves = 5
    @AppStorage("includepowerMove") private var includepowerMove = true
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
                includepowerMove: $includepowerMove,
                trueRandom: $trueRandom,
                movesViewModel: movesViewModel
            )
        }
    }
    
    private func shuffleMoves() {
        var filteredMoves = movesViewModel.moves
        
        if !includepowerMove {
            filteredMoves = filteredMoves.filter { $0.type != .powerMove }
        }
        
        if trueRandom {
            // True random shuffling
            shuffledMoves = Array(filteredMoves.shuffled().prefix(numberOfMoves))
        } else {
            // Structured shuffling
            shuffledMoves = MovesViewModel.structuredShuffle(
                moves: filteredMoves,
                numberOfMoves: numberOfMoves
            )
        }
    }
}

// MARK: - Flow config

struct ConfigurationView: View {
    @Binding var numberOfMoves: Int
    @Binding var includepowerMove: Bool
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
                
                Toggle("Include powerMove", isOn: $includepowerMove)
                
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

// MARK: - Timer

struct TimerView: View {
    @State private var counter = 31
    @State private var counterOverall = 0
    @State private var isPaused = true
    @State private var timer: Timer?
    @State private var showingRules = false
    
    @State private var labelTimer = "30"
    @State private var labelNext = "Get ready!"
    
    private let maxTime = 1200  // 20 minutes in seconds
    
    var body: some View {
        NavigationView {
            VStack {
                
                Spacer()
                
                Text(labelTimer)
                    .font(.largeTitle)
                    .padding()
                
                Text(labelNext)
                    .font(.headline)
                    .padding()
                
                Spacer()
                
                Button(isPaused ? "Start" : "Pause") {
                    if isPaused {
                        startTimer()
                    } else {
                        pauseTimer()
                    }
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .padding()
            }
            .navigationTitle("30 seconds of love")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Rules") {
                        showingRules = true
                    }
                }
            }
            .sheet(isPresented: $showingRules) {
                NavigationView {
                    RulesView()
                }
            }
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            timerAction()
        }
        isPaused = false
    }
    
    func pauseTimer() {
        timer?.invalidate()
        isPaused = true
    }

    func timerAction() {
        guard counterOverall < maxTime else {
            // Stop the timer if overall time exceeds or equals 20 minutes
            pauseTimer()
            return
        }
        if counter > 6 {
            labelNext = "Overall time: \(String(format: "%02d", counterOverall/60)):\(String(format: "%02d", counterOverall%60))"
        } else if counter > 1 {
            labelNext = "Get ready!"
        } else if counter == 1 {
            labelNext = "Next!"
            counter = 31
        } else {
            labelNext = "Overall time \(String(format: "%02d", counterOverall/60)): \(String(format: "%02d", counterOverall%60))"
        }
        counter -= 1
        counterOverall += 1
        labelTimer = "\(counter)"
    }
}

// MARK: - Timer Rules

struct RulesView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Participants take turns making half-minute dance routines. \n\n5 seconds before the end of the current round, the next dancer gets ready.\n\nThe total time, the number of rounds, the order of participants, as well as the format (e.g., footWork only) are determined in advance.")
            Spacer()
        }
        .padding()
        .navigationTitle("30 seconds of love")
    }
}

// MARK: - Moves list

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

// MARK: - Add move

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

// MARK: - Edit move

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
