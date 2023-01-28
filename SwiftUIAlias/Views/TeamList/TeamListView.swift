//
//  TeamListView.swift
//  SwiftUIAlias
//
//  Created by Vadim A on 27.01.2023.
//

import SwiftUI

struct TeamListView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var teamList: TeamList
    
    var body: some View {
        VStack {
            Text("Teams")
                .font(.system(size: 30))
                .foregroundColor(.black)
            
            ScrollView() {
                VStack(spacing: 0) {
                    ForEach(teamList.teamList, id: \.id) { team in
                        TeamListItem(team: team)
                    }
                }
                .padding(.top, 10)
            }
            
            VStack(alignment: .center) {
                Text("Double tap - change color")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                Text("Right swipe - delete")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                Text("Left swipe - rename")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
            }
            
            HStack {
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
                            teamList.addNewTeam()
                        }) {
                            Image(systemName: "plus.circle")
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                                .padding()
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            router.pushRoute(route: .settings)
                        }) {
                            Image(systemName: "arrow.forward")
                                .font(.system(size: 40))
                                .foregroundColor(teamList.canStartGame ? .white : .gray)
                                .padding()
                        }
                        .disabled(!teamList.canStartGame)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

struct TeamListItem: View {
    @EnvironmentObject var teamList: TeamList
    @State var tempName = ""
    @State var xOffset: CGFloat = 0.0
    @State var deleteIconOpacity: Double = 0.0
    @State var editIconOpacity: Double = 0.0
    let team: Team
    
    func toggleTeamEditMode(team: Team) {
        tempName = team.name
        teamList.toggleTeamEditMode(team: team)
    }
    
    func renameTeam(team: Team, newName: String) {
        teamList.renameTeam(team: team, newName: tempName)
        tempName = ""
    }
    
    func handleSwipe(value: DragGesture.Value) {
        let dragValue = value.translation.width
        
        if dragValue > 0 {
            editIconOpacity = Double(abs(dragValue)) / 50
        } else if dragValue < 0 {
            deleteIconOpacity = Double(abs(dragValue)) / 50
        }
        
        if dragValue >= 50 {
            xOffset = 50
        } else if dragValue <= -50 {
            xOffset = -50
        } else {
            xOffset = dragValue
        }
    }
    
    func handleSwipeEnd(value: DragGesture.Value) {
        let dragValue = value.translation.width
        
        if dragValue >= 50 {
            toggleTeamEditMode(team: team)
        } else if dragValue <= -50 {
            if teamList.canStartGame {
                teamList.removeTeam(id: team.id)
            }
        }
        
        xOffset = 0.0
        deleteIconOpacity = 0.0
        editIconOpacity = 0.0
    }
    
    var body: some View {
        if team.editMode {
            ZStack {
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .fill(Color(.black).opacity(0.1))
                    .shadow(color: Color.gray.opacity(0.7), radius: 5, x: 0, y: 0 )
                    .frame(height: 60)
                
                HStack {
                    TextField("Enter name", text: $tempName)
                        .font(.system(size: 25))
                        .padding(.vertical, 15)
                        .foregroundColor(.black)
                        .disableAutocorrection(true)
                    
                    Spacer()
                    
                    Button(action: {
                        renameTeam(team: team, newName: tempName)
                    }) {
                        Image(systemName: "checkmark")
                            .font(.system(size: 20))
                            .padding(.vertical, 15)
                            .foregroundColor(.green)
                    }
                }
                .padding(.horizontal, 10)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .transition(.scale)
        } else {
            ZStack {
                HStack {
                    Image(systemName: "pencil")
                        .font(.system(size: 20))
                        .foregroundColor(.blue)
                        .opacity(editIconOpacity)
                    
                    Spacer()
                    
                    Image(systemName: "trash")
                        .font(.system(size: 20))
                        .foregroundColor(teamList.canStartGame ? .red : .gray)
                        .opacity(deleteIconOpacity)
                }
                
                ZStack {
                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                        .fill(team.color)
                        .frame(height: 60)
                        .shadow(color: Color.black, radius: 5, x: 0, y: 0 )
                    
                    HStack {
                        Image(systemName: "person.2")
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                        
                        Text(team.name)
                            .font(.system(size: 25))
                            .foregroundColor(.black)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 10)
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
                .simultaneousGesture (
                    TapGesture(count: 2)
                        .onEnded { (value) in
                            teamList.changeTeamColor(team: team)
                        }
                )
            }
            .padding(.vertical, 5)
            .padding(.horizontal, 20)
            .transition(.scale)
        }
    }
}

struct TeamListView_Previews: PreviewProvider {
    static var previews: some View {
        TeamListView()
            .environmentObject(Router())
            .environmentObject(TeamList())
    }
}

