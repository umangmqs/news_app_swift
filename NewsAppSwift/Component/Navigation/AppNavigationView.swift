//
//  AppNavigationView.swift
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
    var verifyOTPViewModel: VerifyOTPViewModel!
    var newsDetailViewModel: NewsDetailViewModel!
    var seeAllNewsViewModel: SeeAllViewModel!
    var bookmarkViewModel: BookmarkViewModel!
    var languageViewModel: LanguageViewModel!

    init() {
        networkMonitor.startMonitoring()
        Constants.userInfo = try? UserDefaults.standard.get(
            objectType: MDLUser.self, forKey: StorageKey.userInfo)

        verifyOTPViewModel = VerifyOTPViewModel(appWrite: appWrite)
        newsDetailViewModel = NewsDetailViewModel(appWrite: appWrite)
        bookmarkViewModel = BookmarkViewModel(appWrite: appWrite)
        seeAllNewsViewModel = SeeAllViewModel(service: SeeAllService())
        languageViewModel = LanguageViewModel()

        languageViewModel.getSelectedLanguage()
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
                    }
                }
            }
        }
        .environmentObject(router)
        .environment(\.locale, languageViewModel.selectedLocale)
        .environment(
            \.layoutDirection,
            languageViewModel.selectedLocale.identifier == "ar"
                ? .rightToLeft : .leftToRight
        )
        .onReceive(networkMonitor.isReachable.publisher) { newValue in
            // TODO: Handle Network
        }
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

