//
//  AppNavigationView.swift
//  NavigationDemo
//
//  Created by MQF-6 on 02/04/24.
//

import LanguageManager_iOS
import SwiftUI

struct AppNavigationView: View {
    @ObservedObject var router = Router()
    @AppStorage(StorageKey.onboarded) var onboarded = false
    
    var appWrite = Appwrite()
    var networkMonitor = NetworkMonitor()
    var verifyOTPViewModel: VerifyOTPViewModel!
    var newsDetailViewModel: NewsDetailViewModel!
    var seeAllNewsViewModel: SeeAllViewModel!
    var bookmarkViewModel: BookmarkViewModel!
    var languageViewModel: LanguageViewModel!

    @State var showNoInternet = false

    init() {
        networkMonitor.startMonitoring()
        Constants.userInfo = try? UserDefaults.standard.get(
            objectType: MDLUser.self, forKey: StorageKey.userInfo)

        verifyOTPViewModel = VerifyOTPViewModel(appWrite: appWrite)
        newsDetailViewModel = NewsDetailViewModel(appWrite: appWrite)
        bookmarkViewModel = BookmarkViewModel(appWrite: appWrite)
        seeAllNewsViewModel = SeeAllViewModel(service: SeeAllService())
        languageViewModel = LanguageViewModel()

        LanguageManager.shared.defaultLanguage = .en
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
                .navigationDestination(for: Destination.self) { destination in
                    switch destination {
                    case .login:
                        loginView
                    case .onboarding:
                        OnBoardingView()
                    case .signup:
                        SignupView(
                            signVM: SignupViewModel(
                                appWrite: appWrite
                            )
                        )
                    case .forgotPassword:
                        ForgotPasswordView(
                            forgetVM: ForgotPasswordViewModel(
                                appWrite: appWrite
                            ),
                            verifyVM: verifyOTPViewModel
                        )
                    case .changePassword:
                        ChangePasswordView(
                            changePassVM: ChangePasswordViewModel(
                                appWrite: appWrite
                            )
                        )
                    case .verifyOtp:
                        VerifyOTPView(
                            verifyVM: verifyOTPViewModel
                        )
                    case .tabbar:
                        tabView
                    case .newsDetail:
                        NewsDetailView(
                            newsDetailVM: newsDetailViewModel
                        )
                    case .seeAllNews:
                        SeeAllView(
                            seeAllVM: seeAllNewsViewModel,
                            newsDetailVM: newsDetailViewModel
                        )
                    case .languegeSelection:
                        LanguageView(languageViewModel: languageViewModel)
                    case .noInternet:
                        NoInternetView()
                    }
                }
            }
        }
        .environmentObject(router)
        .environment(\.locale, LanguageManager.shared.appLocale)
        .environment(
            \.layoutDirection,
            LanguageManager.shared.isRightToLeft ? .rightToLeft : .leftToRight
        )
        .fullScreenCover(isPresented: $showNoInternet) {
            NoInternetView()
        }
        .onReceive(
            networkMonitor.$isReachable,
            perform: { newValue in
                AppPrint.debugPrint("New value: \(newValue)")
                if !newValue && !showNoInternet {
                    showNoInternet = true
                }

                if newValue {
                    showNoInternet = false
                }
            })
    }

    var loginView: some View {
        LoginView(
            loginVM: LoginViewModel(
                appWrite: appWrite
            ))
    }

    var tabView: some View {
        TabBarView(
            tabVM: TabViewModel(),
            homeVM: HomeViewModel(
                service: HomeViewService()
            ),
            profileVM: ProfileViewModel(
                appWrite: appWrite
            ), newsDetailVM: newsDetailViewModel,
            seeAllVM: seeAllNewsViewModel,
            bookmarkVM: bookmarkViewModel
        )
    }
}
