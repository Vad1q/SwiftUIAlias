//
//  Team.swift
//  SwiftUIAlias
//
//  Created by Vadim A on 27.01.2023.
//

import SwiftUI

class Team: ObservableObject, Identifiable {
    @Published var id: UUID = UUID()
    @Published var name = ""
    @Published var editMode = false
    @Published var score = 0
    @Published var shownWords: [[String: String]] = []
    @Published var color: Color
    
    init(name: String, color: Color) {
        self.name = name
        self.color = color
    }
    
    func setName(newName: String) {
        self.name = newName
    }
    
    func toggleEditMode() {
        self.editMode = !self.editMode
    }
    
    func increaseScore(increaseBy: Int) {
        self.score += increaseBy
    }
    
    func addShownWords(words: [[String: String]]) {
        self.shownWords += words
    }
    
    func setColor(color: Color) {
        self.color = color
    }
}

