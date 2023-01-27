//
//  GameSettings.swift
//  SwiftUIAlias
//
//  Created by Vadim A on 27.01.2023.
//

import SwiftUI

class GameSettings: ObservableObject {
    @Published var wordCount: Int = 60
    @Published var roundTime: Int = 60
    @Published var skipPenalty: Bool = false
    @Published var sound: Bool = false
    
    func reset() {
        self.wordCount = 60
        self.roundTime = 60
        self.skipPenalty = false
    }
    
    func incrementWordCount() {
        if self.wordCount < 150 {
            self.wordCount += 10
        }
    }
    
    func decrementWordCount() {
        if self.wordCount > 10 {
            self.wordCount -= 10
        }
    }
    
    func incrementRoundTime() {
        if self.roundTime < 100 {
            self.roundTime += 10
        }
    }
    
    func decrementRoundTime() {
        if self.roundTime > 10 {
            self.roundTime -= 10
        }
    }
    
    func setWordCount(count: Int) {
        self.wordCount = count
    }
    
    func setRoundTime(seconds: Int) {
        self.roundTime = seconds
    }
}
