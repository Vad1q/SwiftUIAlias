//
//  Game.swift
//  SwiftUIAlias
//
//  Created by Vadim A on 27.01.2023.
//

import SwiftUI
import Combine


enum GameStatus {
    case new
    case started
    case finished
}

class Game: ObservableObject {
    @ObservedObject var round: Round = Round()
    @Published var words: [String] = []
    @Published var status: GameStatus = .new
    @Published var settings: GameSettings?
    @Published var winner: Team?
    @Published var roundsPlayed: Int = 0
    
    var anyCancellableRound: AnyCancellable? = nil
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        
    init() {
        self.anyCancellableForRound()
        self.words = gameWords.shuffled()
    }
    
    func reset() {
        self.words = gameWords.shuffled()
        self.round = Round()
        self.status = .new
        self.settings = nil
    }
    
    func setStatus(status: GameStatus, winner: Team? = nil) {
        if status == .finished {
            if let winner = winner {
                self.winner = winner
            }
        }
        
        self.status = status
    }
    
    func anyCancellableForRound() {
        anyCancellableRound = round.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
    }
    
    func setSettings(settings: GameSettings) {
        self.settings = settings
    }
    
    func updateRound(teamName: String) {
        let roundWords = Array(self.words[0...100])
        self.words = Array(words[100...])
        self.round = Round(totalWords: roundWords, settings: self.settings, teamName: teamName)
        self.anyCancellableForRound()
    }
    
    func addPlayedRound() {
        self.roundsPlayed += 1
    }
}
