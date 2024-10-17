//
//  NewsAppSwiftApp.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 28/06/24.
//

import IQKeyboardManagerSwift
import SwiftUI

@main
struct NewsAppSwiftApp: App {
    var body: some Scene {
        WindowGroup {
            AppNavigationView()
                .onAppear {
                    IQKeyboardManager.shared.enable = true
                }
        }
    }
}
