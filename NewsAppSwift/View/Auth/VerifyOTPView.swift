//
//  VerifyOTPView.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 08/07/24.
//

import SwiftUI

struct VerifyOTPView: View {
    
    @EnvironmentObject private var router: Router
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var verifyVM: VerifyOTPViewModel
        
    @FocusState var firstFocused: Bool
    @FocusState var secondFocused: Bool
    @FocusState var thirdFocused: Bool
    @FocusState var fourthFocused: Bool
    @FocusState var fifthFocused: Bool
    @FocusState var sixthFocused: Bool

    var body: some View {
        VStack {
            AppNavigationBar(
                type: .titleAndLeading,
                searchText: .constant(""),
                leadingAction: {
                    dismiss.callAsFunction()
                },
                leadingImage: .icBack,
                title: "Verify OTP"
            )
            
            ScrollView {
                Image(.verifyOtp)
                    .resizable()
                    .frame(height: 320.aspectRatio)
                    .padding(.bottom, 22.aspectRatio)
                
                Text("We have sent otp to \(verifyVM.email)")
                    .multilineTextAlignment(.center)
                    .font(.lato(.medium, size: 16))
                    .padding(.horizontal, 30.aspectRatio)
                
                
                otpView
                
                AppPrimaryButton(title: "Verify OTP") {
                    Task {
                        verifyVM.isLoading = true
                        let success = await verifyVM.verifyOTP()
                        verifyVM.isLoading = false
                        if success {
                            verifyVM.toast = Toast(message: "OTP Vetified successfully")
                            router.navigate(to: .changePassword)
                        }
                    }
                }
                .padding(.top, 50.aspectRatio)
                
                Spacer()
            }
            .scrollIndicators(.hidden)
        }
        .padding(.horizontal, 16.aspectRatio)
        .toast(toast: $verifyVM.toast)
        .loader(loading: verifyVM.isLoading)
        .navigationBarBackButtonHidden()
        
    }
}

extension VerifyOTPView {
    var otpView: some View {
        HStack(spacing: 12.aspectRatio) {
            AppTextField(
                text: $verifyVM.first,
                keyboard: .numberPad,
                maxLength: 1,
                textAlignment: .center,
                isFocused: _firstFocused
            )
            AppTextField(
                text: $verifyVM.second,
                keyboard: .numberPad,
                maxLength: 1,
                textAlignment: .center,
                isFocused: _secondFocused
            )
            AppTextField(
                text: $verifyVM.third,
                keyboard: .numberPad,
                maxLength: 1,
                textAlignment: .center,
                isFocused: _thirdFocused
            )
            AppTextField(
                text: $verifyVM.fourth,
                keyboard: .numberPad,
                maxLength: 1,
                textAlignment: .center,
                isFocused: _fourthFocused
            )
            AppTextField(
                text: $verifyVM.fifth,
                keyboard: .numberPad,
                maxLength: 1,
                textAlignment: .center,
                isFocused: _fifthFocused
            )
            AppTextField(
                text: $verifyVM.sixth,
                keyboard: .numberPad,
                maxLength: 1,
                textAlignment: .center,
                isFocused: _sixthFocused
            )
        }
        .frame(height: 50.aspectRatio)
        .padding(.horizontal, 10.aspectRatio)
        .onAppear(perform: {
            firstFocused = true
        })
        .onChange(of: verifyVM.first) { value in
            if value.count > 0 {
                secondFocused = true
            }
        }
        .onChange(of: verifyVM.second) { value in
            if value.count > 0 {
                thirdFocused = true
            }
        }
        .onChange(of: verifyVM.third) { value in
            if value.count > 0 {
                fourthFocused = true
            }
        }
        .onChange(of: verifyVM.fourth) { value in
            if value.count > 0 {
                fifthFocused = true
            }
        }
        .onChange(of: verifyVM.fifth) { value in
            if value.count > 0 {
                sixthFocused = true
            }
        }
        .onChange(of: verifyVM.sixth) { value in
            if value.count > 0 {
                sixthFocused = false
            }
        }
    }
}
#Preview {
    VerifyOTPView(verifyVM: VerifyOTPViewModel(appWrite: Appwrite()))
}
