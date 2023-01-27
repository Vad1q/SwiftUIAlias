//
//  Round.swift
//  SwiftUIAlias
//
//  Created by Vadim A on 27.01.2023.
//

import SwiftUI

enum RoundStatus {
    case new
    case running
    case paused
    case lastWord
    case finished
}

class Round: ObservableObject {
    @Published var counter: Int?
    @Published var roundTime: Int?
    @Published var totalWords: [String] = []
    @Published var shownWords: [[String: String]] = []
    @Published var guessedWords: [String] = []
    @Published var skippedWords: [String] = []
    @Published var status: RoundStatus = .new
    @Published var teamName: String?
    @Published var skipPenalty: Bool = false
    
    var roundResult: Int {
        if skipPenalty {
            if self.skippedCount > self.guessedCount {
                return 0
            } else {
                return self.guessedCount - self.skippedCount
            }
        } else {
            return self.guessedCount
        }
    }
    
    var firstThreeWords: [String] {
        return Array(totalWords[...2])
    }
    
    var currentWord: String {
        return self.totalWords.first!
    }
    
    var guessedCount: Int {
        return self.shownWords.filter({ $0["type"] == "guessed" }).count
    }
    
    var skippedCount: Int {
        return self.shownWords.filter({ $0["type"] == "skipped" }).count
    }
    
    init(totalWords: [String]? = nil, settings: GameSettings? = nil, teamName: String? = nil) {
        
        if let totalWords = totalWords {
            self.totalWords = totalWords
        }
        
        if let settings = settings {
            self.counter = settings.roundTime
            self.roundTime = settings.roundTime
            self.skipPenalty = settings.skipPenalty
        }
        
        if let teamName = teamName {
            self.teamName = teamName
        }
    }
    
    func processTimer() {
        if self.status == .running {
            self.decreaseCounter()
        }
    }
    
    func setStatus(status: RoundStatus) {
        self.status = status
    }

    func decreaseCounter() {
        self.counter! -= 1
        if self.counter! <= 0 {
            self.setStatus(status: RoundStatus.lastWord)
        }
    }
    
    func guessWord() {
        let word = self.totalWords.first!
        self.shownWords.append(["text": word, "type": "guessed"])
        self.totalWords.removeFirst()
        self.objectWillChange.send()
    }
    
    func skipWord() {
        let word = self.totalWords.first!
        self.shownWords.append(["text": word, "type": "skipped"])
        self.totalWords.removeFirst()
        self.objectWillChange.send()
    }
    
    func unGuessWord(word: String) {
        if let index = self.shownWords.firstIndex(where: {$0["text"] == word}){
            self.shownWords[index] = ["text": word, "type": "skipped"]
            self.objectWillChange.send()
        }
    }
    
    func unSkipWord(word: String) {
        if let index = self.shownWords.firstIndex(where: {$0["text"] == word}){
            self.shownWords[index] = ["text": word, "type": "guessed"]
            self.objectWillChange.send()
        }
    }

    
}
