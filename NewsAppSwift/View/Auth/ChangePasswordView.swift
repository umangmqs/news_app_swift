//
//  ChangePassword.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 10/07/24.
//

import SwiftUI
import AVKit

struct ChangePasswordView: View {
    @EnvironmentObject private var router: Router
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var changePassVM: ChangePasswordViewModel
    
    @State var player = AVPlayer()
    
    var body: some View {
        VStack {
            AppNavigationBar(
                type: .titleAndLeading,
                searchText: .constant(""),
                leadingAction: {
                    dismiss.callAsFunction()
                },
                leadingImage: .icBack,
                title: "Reset Password"
            )
            
            ScrollView {
                PlayerView(player: $player)
                    .frame(height: 300.aspectRatio)
                    .onAppear(perform: {
                        player = AVPlayer(url: Bundle.main.url(forResource: "reset_password", withExtension: "mp4")!)
                        player.play()
                    })
                    .disabled(true)
                
                Text("You have passed verification, now you can change your password")
                    .multilineTextAlignment(.center)
                    .font(.lato(.medium, size: 16))
                    .padding(.horizontal, 30.aspectRatio)
                
                AppTextField(
                    text: $changePassVM.password,
                    title: "Password",
                    placeholder: "*********",
                    suffixImage: changePassVM.secured ? "eye.slash" : "eye",
                    secured: changePassVM.secured
                ) {
                    changePassVM.secured.toggle()
                }
                 
                AppTextField(
                    text: $changePassVM.confirmPassword,
                    title: "Confirm Password",
                    placeholder: "*********",
                    suffixImage: changePassVM.confirmSecured ? "eye.slash" : "eye",
                    secured: changePassVM.confirmSecured
                ) {
                    changePassVM.confirmSecured.toggle()
                }
                .padding(.bottom, 16.aspectRatio)
                
                AppPrimaryButton(title: "Submit") {
                    Task {
                        await changePassVM.changePassword()
                    }
                }
                
                Spacer()
            }
            .scrollIndicators(.hidden)

        }
        .padding(.horizontal, 16)
        .toast(toast: $changePassVM.toast)
        .loader(loading: changePassVM.isLoading)
    }
}

#Preview {
    ChangePasswordView(
        changePassVM: ChangePasswordViewModel(
            appWrite: Appwrite()
        )
    )
} 
