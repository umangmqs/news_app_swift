//
//  LoginView.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 28/06/24.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var router: Router

    @StateObject var loginVM: LoginViewModel

    init(loginVM: LoginViewModel) {
        _loginVM = StateObject(wrappedValue: loginVM)
    }

    var body: some View {
        VStack(alignment: .center) {
            AppNavigationBar(type: .imageHeader, searchText: .constant(""))

            ScrollView {
                HeaderComponent()
                    .padding(.top, 40.aspectRatio)

                VStack(spacing: 10.aspectRatio) {
                    AppTextField(
                        text: loginVM.binding(for: \.email),
                        title: "Email",
                        placeholder: "abc@xyz.com",
                        keyboard: .emailAddress
                    )

                    AppTextField(
                        text: loginVM.binding(for: \.password),
                        title: "Password",
                        placeholder: "********",
                        suffixImage: loginVM.secured ? "eye.slash" : "eye",
                        secured: loginVM.secured
                    ) {
                        loginVM.secured = !loginVM.secured
                    }

                    HStack {
                        HStack(spacing: 4) {
                            Image(loginVM.remember ? .icChecked : .icUnchecked)
                                .resizable()
                                .frame(width: 24.aspectRatio, height: 24.aspectRatio)
                                .foregroundStyle(.appPrimaryLight)

                            Text("Remember me")
                                .font(.lato(.medium, size: 14.aspectRatio))
                                .foregroundStyle(.appGrey)
                        }
                        .animation(.easeIn, value: loginVM.remember)
                        .onTapGesture {
                            loginVM.remember.toggle()
                        }

                        Spacer()

                        Text("Forgot password?")
                            .font(.lato(.regular, size: 14.aspectRatio))
                            .foregroundStyle(.black)
                            .onTapGesture {
                                router.push(to: .forgotPassword)
                            }
                    }
                    .padding(.top, 6.aspectRatio)

                    AppPrimaryButton(title: "Login") {
                        if loginVM.validate() {
                            Task {
                                if await loginVM.login() {
                                    router.push(to: .tabbar)
                                }
                            }
                        }
                    }
                    .padding(.vertical, 30.aspectRatio)
                }
//                socialLoginView

                Spacer()

                HStack {
                    Text("Don’t have an account?")
                        .foregroundStyle(.appGrey)
                    Button(action: {
                        router.push(to: .signup)
                    }, label: {
                        Text("Sign Up")
                    })
                }
                .font(.lato(.medium, size: 16))
                .padding(.top, 16.aspectRatio)
            }
            .scrollIndicators(.never)
        }
        .padding(16.aspectRatio)
        .navigationBarBackButtonHidden()
        .toast(toast: $loginVM.toast)
        .loader(loading: loginVM.isLoading)
        .onAppear {
            if !loginVM.remembserEmail.isEmpty {
                loginVM.email = loginVM.remembserEmail
                loginVM.password = loginVM.remembserPass
                loginVM.remember = true
            }
        }
    }

    var socialLoginView: some View {
        VStack {
            Text("Or Sign In With")
                .font(.lato(.medium, size: 14))
                .foregroundStyle(.secondary)
            HStack(spacing: 14.aspectRatio) {
                AppSocialButton(title: "Apple", image: "ic_apple") {}

                AppSocialButton(title: "Google", image: "ic_google") {
                    AppPrint.debugPrint("Google Tapped")
                }
            }
        }
    }
}

#Preview {
    LoginView(
        loginVM: LoginViewModel(appWrite: Appwrite())
    )
}

struct HeaderComponent: View {
    var body: some View {
        VStack(spacing: 14.aspectRatio) {
            Text("Welcome Back!")
                .font(.montserrat(.semibold, size: 25))

            Text("Start exploring various hottest news topics around the world with us.")
                .font(.lato(.regular, size: 14))
                .foregroundStyle(.appGrey)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 60.aspectRatio)
        }
    }
}
