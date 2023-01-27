//
//  TeamResultsView.swift
//  SwiftUIAlias
//
//  Created by Vadim A on 27.01.2023.
//

import SwiftUI

struct TeamResultsView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var teamList: TeamList
    @EnvironmentObject var settings: GameSettings
    @EnvironmentObject var game: Game
    
    func startGame() {
        teamList.setNextActive()
        game.setSettings(settings: settings)
        game.updateRound(teamName: teamList.activeTeam!.name)
        game.setStatus(status: GameStatus.started)
        router.pushRoute(route: .game)
    }
    
    var body: some View {
        VStack {
            Text("Team results")
                .font(.system(size: 30))
                .foregroundColor(.black)
            
            if game.status == .finished {
                Text("Winner:\(game.winner!.name)")
                    .font(.system(size: 30))
                    .foregroundColor(.black)
            }
            
            ScrollView {
                VStack (spacing: 0) {
                    ForEach(teamList.teamList, id: \.id) { team in
                        TeamResultsItem(team: team)
                    }
                    
                }
                .padding(.top, 10)
            }
            
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(Color(.black).opacity(0.3))
                        .frame(maxHeight: 70)
                    
                    HStack {
                        if game.status == .new  {
                            Button(action: {
                                router.back()
                            }) {
                                Image(systemName: "arrow.backward")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white)
                                    .padding()
                            }
                        }
                        
                        Spacer()
                        
                        if game.status == .finished {
                            Button(action: {
                                game.reset()
                                router.pushRoute(route: .home)
                            }) {
                                Image(systemName: "house")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white)
                                    .padding()
                            }
                        } else if game.status == .started {
                            Button(action: {
                                router.pushRoute(route: .game)
                            }) {
                                Image(systemName: "forward.frame")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white)
                                    .padding()
                            }
                        } else {
                            Button(action: {
                                startGame()
                            }) {
                                Image(systemName: "play")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white)
                                    .padding()
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

struct TeamResultsItem: View {
    let team: Team
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5, style: .continuous)
                .fill(team.color!)
                .frame(height: 60)
                .shadow(color: Color.black, radius: 5, x: 0, y: 0 )
            
            HStack {
                Image(systemName: "person.2")
                    .font(.system(size: 20))
                    .foregroundColor(.black)
                
                Text(team.name)
                    .font(.system(size: 25))
                    .padding(.vertical, 15)
                    .foregroundColor(.black)
                
                Spacer()
                
                Text("\(team.score)")
                    .font(.system(size: 25))
            }
            .padding(.horizontal, 10)
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 20)
    }
}

struct TeamResultsView_Previews: PreviewProvider {
    static var previews: some View {
        TeamResultsView()
            .environmentObject(Router())
            .environmentObject(TeamList())
            .environmentObject(GameSettings())
            .environmentObject(Game())
    }
}
