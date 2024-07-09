//
//  AppNavView.swift
//  NavigationDemo
//
//  Created by MQF-6 on 02/04/24.
//

import SwiftUI
  
struct AppNavigationView: View {
    
    @ObservedObject var router = Router()
    @AppStorage(StorageKey.onboarded) var onboarded = false
    
    var appWrite = Appwrite()
    var networkMonitor = NetworkMonitor()
    
    init() {
        networkMonitor.startMonitoring()
        Constants.userInfo = try? UserDefaults.standard.get(objectType: MDLUser.self, forKey: StorageKey.userInfo)
    }
    
    var body: some View {
        NavigationStack(path: $router.navPath) {
            ZStack {
                Color.white
                VStack {
                    if onboarded {
                        if Constants.userInfo != nil {
                            tabView
                        } else {
                            loginView
                        }
                    } else {
                        OnBoardingView()
                    }
                }
                .navigationDestination(for: Router.Destination.self) { destination in
                    switch destination {
                    case .login:
                        loginView
                    case .onboarding:
                        OnBoardingView()
                    case .signup:
                        SignupView(
                            signVM: SignupViewModel(appWrite: appWrite)
                        )
                    case .verifyOtp:
                        VerifyOTPView() 
                    case .tabbar:
                        tabView
                    case .newsDetail:
                        NewsDetailView()
                    }
                }
            }
        }
        .environmentObject(router)
        .onReceive(networkMonitor.isReachable.publisher) { newValue in
            AppPrint.debugPrint("NewValue: \(newValue)")
        }
    }
    
    var loginView: some View {
        LoginView(loginVM: LoginViewModel(
            appWrite: appWrite
        ))
    }
    
    var tabView: some View {
        TabBarView(
            tabVM: TabViewModel(),
            homeVM: HomeViewModel(
                service: HomeViewService()
            )
        )
    }
}

#Preview {
    AppNavigationView()
}

