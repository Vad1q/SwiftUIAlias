//
//  TeamList.swift
//  SwiftUIAlias
//
//  Created by Vadim A on 27.01.2023.
//

import SwiftUI

class TeamList: ObservableObject {
    @Published var teamList: [Team] = []
    @Published var activeTeam: Team?
    
    var teamsCount: Int {
        return self.teamList.count
    }
    
    var canStartGame: Bool {
        return self.teamList.count >= 2
    }
    
    var leaderTeam: Team {
        var leaderTeam: Team?
        
        self.teamList.forEach { team in
            if let tm = leaderTeam {
                if team.score > tm.score {
                    leaderTeam = team
                }
            } else {
                leaderTeam = team
            }
        }
        
        return leaderTeam!
    }
    
    var onlyOneMaxScore: Bool {
        let scores = self.teamList.map{$0.score}
        let maxScore = scores.max()
        let maxScoreArray = scores.filter({ $0 == maxScore })
        return maxScoreArray.count == 1
    }
    
    init() {
        self.createTeams()
        self.activeTeam = self.teamList[0]
    }
    
    func reset() {
        self.createTeams()
        self.activeTeam = self.teamList[0]
    }
    
    func createTeams() {
        let teamOne = Team()
        let teamTwo = Team()
        while teamOne.name == teamTwo.name {
            teamTwo.generateRandomName()
        }
        
        self.teamList = [teamOne, teamTwo]
    }
    
    func toggleTeamEditMode(team: Team) {
        team.toggleEditMode()
        self.objectWillChange.send()
    }

    func renameTeam(team: Team, newName: String) {
        team.rename(newName: newName)
        team.toggleEditMode()
        self.objectWillChange.send()
    }

    func increaseTeamScore(team: Team, increaseBy: Int) {
        team.increaseScore(increaseBy: increaseBy)
        self.objectWillChange.send()
    }
    
    func addNewTeam() {
        let newTeam = Team()
        self.teamList.append(newTeam)
        self.activeTeam = self.teamList[0]
    }
    
    func removeTeam(id: UUID) {
        if let index = self.teamList.firstIndex(where: {$0.id == id}){
            teamList.remove(at: index)
            self.activeTeam = self.teamList[0]
        }
    }
    
    func setNextActive() {
        let activeTeamId = self.activeTeam!.id
        if let index = self.teamList.firstIndex(where: {$0.id == activeTeamId}){
            let nextIdx = index + 1
            if self.teamList.indices.contains(nextIdx) {
                self.activeTeam = self.teamList[nextIdx]
            } else {
                self.activeTeam = self.teamList[0]
            }
        }
    }
    
    func changeTeamColor(team: Team) {
        team.changeColor()
        self.objectWillChange.send()
    }
    
}
