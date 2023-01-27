//
//  RulesView.swift
//  SwiftUIAlias
//
//  Created by Vadim A on 27.01.2023.
//

import SwiftUI

struct RulesView: View {
    @EnvironmentObject var router: Router
    let ruleList: [String] = ["Rule 1", "Rule 2"]
    
    var body: some View {
        VStack {
            HStack {
                Text("Rules")
                    .font(.system(size: 30))
                    .foregroundColor(.black)
            }
            
            TabView {
                ForEach(ruleList, id: \.self) { rule in
                    RuleItem(text: rule)
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
            
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color(.black).opacity(0.3))
                        .frame(maxHeight: 70)
                    
                    HStack {
                        Button(action: {
                            router.back()
                        }) {
                            Image(systemName: "house")
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

struct RuleItem: View {
    let text: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color(.white).opacity(0.9))
                .shadow( color: Color.gray.opacity(0.9), radius: 10, x: 0, y: 0)
                .padding(.top, 20)
                .padding(.horizontal, 20)
            
            Text(text)
                .font(.system(size: 20))
                .foregroundColor(.black)
        }
        .padding(.bottom, 50)
    }
}

struct RulesView_Previews: PreviewProvider {
    static var previews: some View {
        RulesView()
            .environmentObject(Router())
    }
}

