//
//  ForgotPasswordView.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 10/07/24.
//

import SwiftUI

struct ForgotPasswordView: View {
    @EnvironmentObject private var router: Router
    @Environment(\.dismiss) private var dismiss

    @StateObject var forgetVM: ForgotPasswordViewModel
    @StateObject var verifyVM: VerifyOTPViewModel

    @State private var showAlert = false

    var body: some View {
        VStack {
            AppNavigationBar(
                type: .titleAndLeading,
                searchText: .constant(""),
                leadingAction: {
                    dismiss.callAsFunction()
                },
                leadingImage: .icBack,
                title: "Forget Password"
            )

            ScrollView {
                Image(.forgetPassword)
                    .resizable()
                    .frame(height: 280.aspectRatio)
                    .padding(.bottom, 22.aspectRatio)

                Text("Enter your email address we'll send you a link to reset password")
                    .multilineTextAlignment(.center)
                    .font(.lato(.medium, size: 16))
                    .padding(.horizontal, 30.aspectRatio)

                AppTextField(
                    text: $forgetVM.email,
                    title: "Email",
                    placeholder: "abc@xyx.com",
                    keyboard: .emailAddress
                )
                .padding(.bottom, 16.aspectRatio)

                AppPrimaryButton(title: "Submit") {
                    Task {
                        if await forgetVM.checkEmailExist() {
                            showAlert = await forgetVM.storeOTP()
                        }
                    }
                }

                Spacer()
            }
            .scrollIndicators(.hidden)
        }
        .padding(.horizontal, 16.aspectRatio)
        .toast(toast: $forgetVM.toast)
        .loader(loading: forgetVM.isLoading)
        .navigationBarBackButtonHidden()
        .alert(forgetVM.otp, isPresented: $showAlert) {
            Button(action: {
                verifyVM.email = forgetVM.email
                router.push(to: .verifyOtp)
            }, label: {
                Text("Okay")
            })
        } message: {
            Text("OTP is valid till 2 minutes")
        }
    }
}

#Preview {
    ForgotPasswordView(
        forgetVM: ForgotPasswordViewModel(
            appWrite: Appwrite()
        ),
        verifyVM: VerifyOTPViewModel(
            appWrite: Appwrite()
        )
    )
}
