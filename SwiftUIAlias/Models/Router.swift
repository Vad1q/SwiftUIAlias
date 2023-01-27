//
//  Router.swift
//  SwiftUIAlias
//
//  Created by Vadim A on 27.01.2023.
//

import SwiftUI

enum Route {
    case home
    case teams
    case settings
    case teamResults
    case roundResults
    case game
    case rules
}

enum Direction {
    case trailing
    case leading
}

class Router: ObservableObject {
    @Published var history: [Route] = [.home]
    @Published var insertionDirection: Edge = .trailing
    @Published var removalDirection: Edge = .bottom
    
    var previous: Route {
        return self.history.count > 1 ? self.history[self.history.count - 2] : .home
    }
    
    var current: Route {
        return self.history.last!
    }
    
    func pushRoute(route: Route) {
        self.insertionDirection = .trailing
        self.removalDirection = .bottom
        self.history.append(route)
    }
    
    func back() {
        if self.history.count > 1 {
            self.insertionDirection = .bottom
            self.removalDirection = .trailing
            self.history.removeLast()
        }
    }
}
