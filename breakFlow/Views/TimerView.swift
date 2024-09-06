//
//  TimerView.swift
//  breakFlow
//
//  Created by Viktor Gordienko on 9/3/24.
//

import SwiftUI

#Preview {
    TimerView()
}

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
