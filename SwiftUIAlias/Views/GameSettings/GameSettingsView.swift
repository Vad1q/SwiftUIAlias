//
//  GameSettingsView.swift
//  SwiftUIAlias
//
//  Created by Vadim A on 27.01.2023.
//

import SwiftUI

struct GameSettingsView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var settings: GameSettings
    
    let shortCuts: [Int] = [10, 30, 60, 90]
    
    func incrementWordCount() {
        settings.incrementWordCount()
    }
    
    func decrementWordCount() {
        settings.decrementWordCount()
    }
    
    func incrementRoundTime() {
        settings.incrementRoundTime()
    }
    
    func decrementRoundTime() {
        settings.decrementRoundTime()
    }
    
    func resetSettings() {
        settings.reset()
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Settings")
                    .font(.system(size: 30))
                    .foregroundColor(.black)
            }
            
            ScrollView {
                VStack(spacing: 0) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .fill(Color(.white))
                            .shadow( color: Color.black, radius: 5, x: 0, y: 0)
                        
                        VStack(spacing: 0) {
                            Stepper(onIncrement: incrementWordCount,
                                    onDecrement: decrementWordCount) {
                                Text("Word count: \(settings.wordCount)")
                                    .font(.system(size: 20))
                                    .foregroundColor(.black)
                            }
                            .padding(.vertical, 10.0)
                            .padding(.horizontal, 15.0)
                            
                            HStack (spacing: 20) {
                                ForEach(shortCuts, id: \.self) { shortCut in
                                    Button(action: {
                                        settings.setWordCount(count: shortCut)
                                    }) {
                                        Text("\(shortCut)")
                                            .font(.system(size: 20))
                                            .foregroundColor(.black)
                                            .padding(.vertical, 3)
                                            .padding(.horizontal, 10)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .stroke(Color(.black), lineWidth: 2)
                                            )
                                    }
                                }
                            }
                            
                            Text("Guess \(settings.wordCount) words to win")
                                .font(.system(size: 17))
                                .foregroundColor(.black)
                                .padding(.vertical, 10.0)
                        }
                    }
                    .padding(.vertical, 5.0)
                    .padding(.horizontal, 20.0)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .fill(Color(.white))
                            .shadow( color: Color.black, radius: 5, x: 0, y: 0)
                        
                        VStack(spacing: 0) {
                            Stepper(onIncrement: incrementRoundTime,
                                    onDecrement: decrementRoundTime) {
                                Text("Round time: \(settings.roundTime)")
                                    .font(.system(size: 20))
                                    .foregroundColor(.black)
                            }
                            .padding(.vertical, 10.0)
                            .padding(.horizontal, 15.0)
                            
                            HStack (spacing: 20) {
                                ForEach(shortCuts, id: \.self) { shortCut in
                                    Button(action: {
                                        settings.setRoundTime(seconds: shortCut)
                                    }) {
                                        Text("\(shortCut)")
                                            .font(.system(size: 20))
                                            .foregroundColor(.black)
                                            .padding(.vertical, 3)
                                            .padding(.horizontal, 10)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .stroke(Color(.black), lineWidth: 2)
                                            )
                                    }
                                }
                            }
                            
                            Text("\(settings.roundTime) seconds per round to guess words")
                                .font(.system(size: 17))
                                .foregroundColor(.black)
                                .padding(.vertical, 10.0)
                        }
                    }
                    .padding(.vertical, 5.0)
                    .padding(.horizontal, 20.0)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .fill(Color(.white))
                            .shadow( color: Color.black, radius: 5, x: 0, y: 0)
                        
                        VStack(spacing: 0) {
                            Toggle(isOn: $settings.skipPenalty) {
                                Text("Skip penalty")
                                    .font(.system(size: 20))
                                    .foregroundColor(.black)
                            }
                            .toggleStyle(SwitchToggleStyle(tint: .orange))
                            .padding(.vertical, 10.0)
                            .padding(.horizontal, 15.0)
                            
                            Text("Subtract points for skipped words")
                                .font(.system(size: 17))
                                .foregroundColor(.black)
                                .padding(.vertical, 10.0)
                        }
                    }
                    .padding(.vertical, 5.0)
                    .padding(.horizontal, 20.0)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .fill(Color(.white))
                            .shadow( color: Color.black, radius: 5, x: 0, y: 0)
                        
                        VStack(spacing: 0) {
                            Toggle(isOn: $settings.sound) {
                                Text("Sound")
                                    .font(.system(size: 20))
                                    .foregroundColor(.black)
                            }
                            .toggleStyle(SwitchToggleStyle(tint: .orange))
                            .padding(.vertical, 10.0)
                            .padding(.horizontal, 15.0)
                            
                            Text("Enable sound effects in game")
                                .font(.system(size: 17))
                                .foregroundColor(.black)
                                .padding(.vertical, 10.0)
                        }
                    }
                    .padding(.vertical, 5.0)
                    .padding(.horizontal, 20.0)
                }
                .padding(.top, 10)
            }
            
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(Color(.black).opacity(0.3))
                        .frame(maxHeight: 70)
                    
                    HStack {
                        Button(action: {
                            router.back()
                        }) {
                            Image(systemName: "arrow.backward")
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                                .padding()
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            resetSettings()
                        }) {
                            Image(systemName: "arrow.triangle.2.circlepath")
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                                .padding()
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            router.pushRoute(route: .teamResults)
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

struct GameSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        GameSettingsView()
            .environmentObject(Router())
            .environmentObject(GameSettings())
    }
}

