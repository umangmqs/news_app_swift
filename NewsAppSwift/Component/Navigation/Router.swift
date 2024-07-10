//
//  Routing.swift
//  NavigationDemo
//
//  Created by MQF-6 on 02/04/24.
//

import SwiftUI
 
final class Router: ObservableObject {
    public enum Destination: Codable, Hashable {
        case onboarding
        case login
        case signup
        case forgotPassword
        case changePassword
        case verifyOtp 
        case tabbar
        case newsDetail
    }
    
    @Published var navPath = NavigationPath()

    func navigate(to destination: Destination) {
        navPath.append(destination)
    }
    
    func navigateBack() {
        navPath.removeLast()
    }
    
    func navigateToRoot() {
        navPath.removeLast(navPath.count)
    }
     
}
