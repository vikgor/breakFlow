//
//  MovesViewModel.swift
//  breakFlow
//
//  Created by Viktor Gordienko on 9/3/24.
//

import WatchConnectivity

class MovesViewModel: NSObject, ObservableObject {
    private let movesKey = "savedMoves"
    
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
        // Add other moves here...
    ] {
        didSet {
            saveMoves()
            sendMovesToWatch()
        }
    }
    
    // MARK: - Init
    
    override init() {
        super.init()
        loadMoves()
        
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }

        sendMovesToWatch()
    }
    
    // MARK: - Helpers
    
    func addMove(_ move: Move) {
        moves.append(move)
    }

    func editMove(move: Move, name: String, type: MoveType) {
        if let index = moves.firstIndex(where: { $0.id == move.id }) {
            moves[index].name = name
            moves[index].type = type
        }
    }
    
    static func structuredShuffle(
        moves: [Move],
        numberOfMoves: Int,
        includePowerMove: Bool,
        trueRandom: Bool
    ) -> [Move] {
        var filteredMoves = moves
        if !includePowerMove {
            // Filter out powerMove
            filteredMoves = filteredMoves.filter { $0.type != .powerMove }
        }
        if trueRandom {
            return Array(filteredMoves.shuffled().prefix(numberOfMoves))
        }
        
        var result = [Move]()
        
        // Filter out disabled moves
        let enabledMoves = filteredMoves.filter { $0.isEnabled }
        
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

// MARK: - Private

private extension MovesViewModel {
    func saveMoves() {
        if let encodedMoves = try? JSONEncoder().encode(moves) {
            UserDefaults.standard.set(encodedMoves, forKey: movesKey)
        }
    }

    func sendMovesToWatch() {
        if let encodedMoves = try? JSONEncoder().encode(moves) {
            let context = ["moves": encodedMoves]
            do {
                try WCSession.default.updateApplicationContext(context)
            } catch {
                print("Failed to update application context: \(error)")
            }
        }
    }

    func loadMoves() {
        if let savedMovesData = UserDefaults.standard.data(forKey: movesKey),
           let savedMoves = try? JSONDecoder().decode([Move].self, from: savedMovesData) {
            moves = savedMoves
        }
    }
}

// MARK: - WCSessionDelegate

extension MovesViewModel: WCSessionDelegate {
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) { }
    func sessionDidDeactivate(_ session: WCSession) { session.activate() }
    #endif

    // Required method for WCSessionDelegate
    func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) { }

    func session(
        _ session: WCSession,
        didReceiveApplicationContext applicationContext: [String : Any]
    ) {
        if let moveData = applicationContext["moves"] as? Data {
            if let newMoves = try? JSONDecoder().decode([Move].self, from: moveData) {
                DispatchQueue.main.async {
                    self.moves = newMoves
                }
            }
        }
    }
}
