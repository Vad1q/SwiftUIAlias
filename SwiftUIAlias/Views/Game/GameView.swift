//
//  GameView.swift
//  SwiftUIAlias
//
//  Created by Vadim A on 27.01.2023.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var teamList: TeamList
    @EnvironmentObject var game: Game
    
    func getCardZ(word: String) -> Double {
        switch word {
        case game.round.firstThreeWords[0]:
            return 3
        case game.round.firstThreeWords[1]:
            return 2
        case game.round.firstThreeWords[2]:
            return 1
        default:
            return 3
        }
        
    }
    
    func getCardY(word: String) -> CGFloat {
        switch word {
        case game.round.firstThreeWords[0]:
            return 0
        case game.round.firstThreeWords[1]:
            return 15
        case game.round.firstThreeWords[2]:
            return 30
        default:
            return 0
        }
        
    }
    
    func getCardScale(word: String) -> CGFloat {
        switch word {
        case game.round.firstThreeWords[0]:
            return 1
        case game.round.firstThreeWords[1]:
            return 0.95
        case game.round.firstThreeWords[2]:
            return 0.9
        default:
            return 1
        }
        
    }
    
    var body: some View {
        VStack {
            TeamLabel(team: teamList.activeTeam!)
            
            ProgressBar(game: game)
            
            HStack {
                ZStack {
                    ForEach(game.round.firstThreeWords, id: \.self) { word in
                        WordCardView(word: word,
                                     isActiveCard: word == game.round.currentWord,
                                     isLastWord: game.round.status == .lastWord,
                                     isPaused: game.round.status == .paused,
                                     isNew: game.round.status == .new)
                            .zIndex(getCardZ(word: word))
                            .offset(y: getCardY(word: word))
                            .scaleEffect(x: getCardScale(word: word), y: getCardScale(word: word))
                    }
                }
            }
            
            Spacer()
            
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(Color(.black).opacity(0.3))
                        .frame(maxHeight: 70)
                    
                    HStack {
                        Button(action: {
                            game.round.setStatus(status: RoundStatus.paused)
                            router.pushRoute(route: .home)
                        }) {
                            Image(systemName: "house")
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                                .padding()
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            game.round.setStatus(status: RoundStatus.paused)
                        }) {
                            Image(systemName: "pause.circle")
                                .font(.system(size: 40))
                                .foregroundColor([.new, .finished, .lastWord].contains(game.round.status) ? .gray : .white)
                                .padding()
                        }
                        .disabled([.new, .finished, .lastWord].contains(game.round.status))
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

struct WordCardView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var game: Game
    @EnvironmentObject var teamList: TeamList
    
    @State var xOffset: CGFloat = 0.0
    @State var skipOpacity: Double = 0.0
    @State var guessOpacity: Double = 0.0
    
    let word: String
    let isActiveCard: Bool
    let isLastWord: Bool
    let isPaused: Bool
    let isNew: Bool
    
    func handleSwipe(value: DragGesture.Value) {
        if !isActiveCard || isPaused || isNew { return }
        
        let dragValue = value.translation.width
        let maxOffset = UIScreen.main.bounds.size.width / 2.5
        
        if dragValue >= maxOffset {
            xOffset = maxOffset
        } else if dragValue <= -maxOffset {
            xOffset = -maxOffset
        } else {
            xOffset = dragValue
        }
        
        if xOffset == 0 {
            guessOpacity = 0.0
            skipOpacity = 0.0
        }
        
        if xOffset > 0 {
            guessOpacity = Double(xOffset / maxOffset)
        } else if xOffset < 0 {
            skipOpacity = Double(abs(xOffset) / maxOffset)
        }
    }
    
    func handleSwipeEnd(value: DragGesture.Value) {
        if !isActiveCard || isPaused || isNew { return }
        
        let dragValue = value.translation.width
        let maxOffset = UIScreen.main.bounds.size.width / 2.5
        
        if dragValue >= maxOffset {
            xOffset = dragValue * 2
            game.round.guessWord()
        } else if dragValue <= -maxOffset {
            xOffset = dragValue * 2
            game.round.skipWord()
        } else {
            resetValues()
            return
        }
        
        if game.round.status == .lastWord {
            game.round.setStatus(status: RoundStatus.finished)
            router.pushRoute(route: .roundResults)
        }
    }
    
    func resetValues() {
        guessOpacity = 0.0
        skipOpacity = 0.0
        xOffset = 0.0
    }
    
    func calculateFontSize(cardWidth: CGFloat) -> CGFloat {
        var result = 1.5 * cardWidth / CGFloat(word.count)
        if result > 45  { result = 45 }
        return result
    }
    
    func getBlurValue() -> CGFloat {
        return isPaused || isNew || !isActiveCard ? 15 : 0
    }
    
    var body: some View {
        VStack {
            GeometryReader{ g in
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color(.white))
                        .shadow( color: Color.black.opacity(0.5), radius: 10, x: 0, y: 0)
                    
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color(.red).opacity(skipOpacity))
                    
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color(.green).opacity(guessOpacity))
                    
                    Text(word)
                        .foregroundColor(Color.black)
                        .font(.system(size: calculateFontSize(cardWidth: g.size.width)))
                        .lineLimit(1)
                        .blur(radius: getBlurValue())
                    
                    if isLastWord && isActiveCard {
                        Text("Last word")
                            .foregroundColor(Color.black)
                            .font(.system(size: 20))
                            .padding(.top, (200 / 2) + 50)
                    }
                    
                    if isPaused {
                        Button(action: {
                            game.round.setStatus(status: RoundStatus.running)
                        }) {
                            Image(systemName: "playpause.fill")
                                .font(.system(size: 70))
                                .padding(.vertical, 15)
                                .foregroundColor(.white)
                                .shadow(color: Color.black, radius: 20, x: 0, y: 0 )
                        }
                    } else if isNew {
                        Button(action: {
                            game.round.setStatus(status: RoundStatus.running)
                        }) {
                            Text("Start")
                                .font(.system(size: 70, weight: .bold))
                                .padding(.vertical, 15)
                                .foregroundColor(.white)
                                .shadow(color: Color.black, radius: 20, x: 0, y: 0 )
                        }
                    }
                }
                .offset(x: xOffset)
                .gesture (
                    DragGesture()
                        .onChanged { value in
                            withAnimation(.default) {
                                handleSwipe(value: value)
                            }
                        }
                        .onEnded { (value) in
                            withAnimation(.default) {
                                handleSwipeEnd(value: value)
                            }
                        }
                )
            }
            .frame(height: 200)
            .padding(.horizontal, 40.0)
        }
    }
}

struct TimerView: View {
    @EnvironmentObject var game: Game
    
    func getProgressValue() -> CGFloat {
        let result = (1.0 / Double(game.round.roundTime!)) * Double(game.round.roundTime! - game.round.counter!)
        return (CGFloat(result))
    }
    
    func getProgressColor() -> Color {
        return game.round.counter == 0 || game.round.counter! < 10 ? Color.red : Color.white
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                .stroke(Color.white.opacity(0.3), lineWidth: 8)
                .frame(width: 90, height: 50)
                .overlay(
                    RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/).trim(from:0, to: getProgressValue())
                        .stroke(
                            style: StrokeStyle(
                                lineWidth: 8,
                                lineCap: .butt,
                                lineJoin: .round
                            )
                        )
                        .foregroundColor(
                            getProgressColor()
                        )
                )
            HStack {
                Text("\(game.round.counter!)")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(getProgressColor())
            }
        }
        .onReceive(game.timer) { _ in
            game.round.processTimer()
        }
    }
}

struct TeamLabel: View {
    let team: Team
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5, style: .continuous)
                .fill(team.color!)
                .frame(height: 60)
                .shadow(color: Color.black, radius: 5, x: 0, y: 0 )
            
            HStack {
                Text(team.name)
                    .font(.system(size: 25))
                    .padding(.vertical, 15)
                    .foregroundColor(.black)
            }
            .padding(.horizontal, 10)
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 20)
    }
}

struct ProgressBar: View {
    let game: Game
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color.black.opacity(0.1))
                .frame(height: 70)
                .shadow(color: Color.black, radius: 5, x: 0, y: 0 )
            
            HStack(alignment: .center) {
                Text("\(game.round.skippedCount)")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(Color.red)
                    .frame(width: 50)
                
                Spacer()
                
                TimerView()
                
                Spacer()
                
                Text("\(game.round.guessedCount)")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(Color.green)
                    .frame(width: 50)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 30)
        .animation(game.round.status == .running ? .none : .easeInOut(duration: 0.3))
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
            .environmentObject(Router())
            .environmentObject(TeamList())
            .environmentObject(Game())
    }
}

