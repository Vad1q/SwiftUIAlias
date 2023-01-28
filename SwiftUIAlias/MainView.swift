//
//  MainView.swift
//  SwiftUIAlias
//
//  Created by Vadim A on 27.01.2023.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var router = Router()
    @ObservedObject var teamList = TeamList()
    @ObservedObject var settings = GameSettings()
    @ObservedObject var game = Game()
    
    let backgroundZ = 0.0
    let titleZ = 1.0
    let viewZ = 2.0
    
    var isTitleVisible: Bool {
        return router.current == .home
    }
    
    var body: some View {
        
        ZStack {
            Image("Background")
                .resizable()
                .zIndex(backgroundZ)
                .scaledToFill()
            
            Image("Alias_home")
                .resizable()
                .zIndex(titleZ)
                .scaledToFit()
                .opacity(isTitleVisible ? 1.0 : 0.0)
                .animation(.easeInOut(duration: 0.2), value: isTitleVisible)
            
            AnimatedContentView(content: {
                switch router.current {
                case .home:
                    HomeView()
                case .teams:
                    TeamListView()
                case .settings:
                    GameSettingsView()
                case .teamResults:
                    TeamResultsView()
                case .roundResults:
                    RoundResultsView()
                case .game:
                    GameView()
                case .rules:
                    RulesView()
                }
            }, zValue: viewZ)
        }
        .ignoresSafeArea()
        .environmentObject(router)
        .environmentObject(teamList)
        .environmentObject(settings)
        .environmentObject(game)
    }
}

struct AnimatedContentView<Content: View>: View {
    @EnvironmentObject var router: Router
    let content: Content
    let zValue: Double
    
    init(@ViewBuilder content: () -> Content, zValue: Double) {
        self.content = content()
        self.zValue = zValue
    }
    
    var body: some View {
        self.content
            .transition(
                .asymmetric(insertion: .move(edge: router.insertionDirection),
                            removal: .move(edge: router.removalDirection)
                           )
            )
            .animation(.easeInOut(duration: 0.4))
            .zIndex(zValue)
            .padding(.top, 50)
            .padding(.bottom, 20)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
