//
//  RoundResultsView.swift
//  SwiftUIAlias
//
//  Created by Vadim A on 27.01.2023.
//

import SwiftUI

struct RoundResultsView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var teamList: TeamList
    @EnvironmentObject var settings: GameSettings
    @EnvironmentObject var game: Game
    
    func goNext() {
        teamList.activeTeam!.addShownWords(words: game.round.shownWords)
        teamList.activeTeam!.increaseScore(increaseBy: game.round.roundResult)
        
        game.addPlayedRound()
                
        let isLapEnded = game.roundsPlayed.isMultiple(of: teamList.teamsCount)
        let hasOnlyOneLeader = isLapEnded && teamList.onlyOneMaxScore
        
        if hasOnlyOneLeader {
            let leaderTeam = teamList.leaderTeam
            
            if leaderTeam.score >= game.settings!.wordCount {
                game.setStatus(status: GameStatus.finished, winner: leaderTeam)
            } else {
                teamList.setNextActive()
                game.updateRound(teamName: teamList.activeTeam!.name)
            }
        } else {
            teamList.setNextActive()
            game.updateRound(teamName: teamList.activeTeam!.name)
        }
        
        router.pushRoute(route: .teamResults)
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Round results")
                    .font(.system(size: 30))
                    .foregroundColor(.black)
            }
            
            ScrollView {
                ForEach(game.round.shownWords, id: \.self) { word in
                    RoundResultsItem(word: word)
                }
            }
            .padding(.horizontal, 10)
            
            Text("+\(game.round.roundResult) words")
                .font(.system(size: 30))
                .foregroundColor(.black)
                .padding(.vertical, 10)
            
            Spacer()
            
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(Color(.black).opacity(0.3))
                        .frame(maxHeight: 70)
                    
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            goNext()
                        }) {
                            Image(systemName: "arrow.forward")
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                                .padding()
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

struct RoundResultsItem: View {
    @EnvironmentObject var game: Game
    
    let word: [String: String]
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5, style: .continuous)
                .fill(Color(.white).opacity(0.9))
                .shadow(color: Color.gray.opacity(0.7), radius: 5, x: 0, y: 0 )
                .frame(height: 50)
            
            HStack {
                Text(word["text"]!)
                    .font(.system(size: 20))
                    .foregroundColor(.black)
                    .padding(.all, 10)
                    .lineLimit(1)
                
                Spacer()
                
                Button(action: {
                    if word["type"]! == "guessed" {
                        game.round.unGuessWord(word: word["text"]!)
                    } else {
                        game.round.unSkipWord(word: word["text"]!)
                    }
                    
                }) {
                    Image(systemName: word["type"]! == "guessed" ? "checkmark" : "xmark")
                        .font(.system(size: 20))
                        .padding(.all, 10)
                        .foregroundColor(word["type"]! == "guessed" ? .green : .red)
                }
            }
        }
        .padding(.top, 5.0)
        .padding(.horizontal, 10)
    }
}

struct RoundResultsView_Previews: PreviewProvider {
    static var previews: some View {
        RoundResultsView()
            .environmentObject(Router())
            .environmentObject(TeamList())
            .environmentObject(GameSettings())
            .environmentObject(Game())
    }
}
