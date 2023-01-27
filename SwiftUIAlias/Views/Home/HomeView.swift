//
//  HomeView.swift
//  SwiftUIAlias
//
//  Created by Vadim A on 27.01.2023.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var teamList: TeamList
    @EnvironmentObject var settings: GameSettings
    @EnvironmentObject var game: Game
    
    func resetState() {
        teamList.reset()
        settings.reset()
        game.reset()
    }
    
    var body: some View {
        VStack (alignment: .trailing) {
            VStack {}
                .frame(height: 300)
            VStack(spacing: 15) {
                if game.status == .started {
                    Button(action: {
                        router.pushRoute(route: .game)
                    }) {
                        Text("Continue")
                            .font(.system(size: 35, weight: .bold))
                            .padding(.horizontal, 15)
                            .padding(.vertical, 10)
                            .background(Color(.black).opacity(0.3))
                            .cornerRadius(20)
                            .foregroundColor(.white)
                            .shadow(color: Color.gray.opacity(0.7), radius: 5, x: 0, y: 0 )
                    }
                }
                
                Button(action: {
                    resetState()
                    router.pushRoute(route: .teams)
                }) {
                    Text("New game")
                        .font(.system(size: 35, weight: .bold))
                        .padding(.horizontal, 15)
                        .padding(.vertical, 10)
                        .background(Color(.black).opacity(0.3))
                        .cornerRadius(20)
                        .foregroundColor(.white)
                        .shadow(color: Color.gray.opacity(0.7), radius: 5, x: 0, y: 0 )
                }
                
                Button(action: {
                    router.pushRoute(route: .rules)
                }) {
                    Text("Rules")
                        .font(.system(size: 35, weight: .bold))
                        .padding(.horizontal, 15)
                        .padding(.vertical, 10)
                        .background(Color(.black).opacity(0.3))
                        .cornerRadius(20)
                        .foregroundColor(.white)
                        .shadow(color: Color.gray.opacity(0.7), radius: 15, x: 0, y: 0 )
                    
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(Router())
            .environmentObject(TeamList())
            .environmentObject(GameSettings())
            .environmentObject(Game())
    }
}
