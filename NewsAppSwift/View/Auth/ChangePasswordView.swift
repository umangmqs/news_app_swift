//
//  ChangePasswordView.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 10/07/24.
//

import AVKit
import SwiftUI

struct ChangePasswordView: View {
    @EnvironmentObject private var router: Router
    @Environment(\.dismiss) private var dismiss

    @StateObject var changePassVM: ChangePasswordViewModel

    @State private var player = AVPlayer()
    @State var showAlert = false

    var body: some View {
        VStack {
            AppNavigationBar(
                type: .titleAndLeading,
                searchText: .constant(""),
                leadingAction: {
                    dismiss.callAsFunction()
                },
                leadingImage: .icBack,
                title: "Change Password"
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
                    text: $changePassVM.oldPassword,
                    title: "Old Password",
                    placeholder: "*********",
                    suffixImage: changePassVM.oldSecured ? "eye.slash" : "eye",
                    secured: changePassVM.oldSecured
                ) {
                    changePassVM.oldSecured.toggle()
                }

                AppTextField(
                    text: $changePassVM.newPassword,
                    title: "New Password",
                    placeholder: "*********",
                    suffixImage: changePassVM.newSecured ? "eye.slash" : "eye",
                    secured: changePassVM.newSecured
                ) {
                    changePassVM.newSecured.toggle()
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
                        router.popToView(destination: .tabbar)
                    }
                }

                Spacer()
            }
            .scrollIndicators(.hidden)
        }
        .padding(.horizontal, 16)
        .toast(toast: $changePassVM.toast)
        .loader(loading: changePassVM.isLoading)
        .navigationBarBackButtonHidden()
        .alert("Password Change", isPresented: $showAlert) {
            Button(action: {
                dismiss()
            }, label: {
                Text("Okay")
            })
        } message: {
            Text("Password has been changed successfully.")
        }
    }
}

#Preview {
    ChangePasswordView(
        changePassVM: ChangePasswordViewModel(
            appWrite: Appwrite()
        )
    )
}
