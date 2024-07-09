//
//  SignupView.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 02/07/24.
//

import SwiftUI

struct SignupView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var router: Router
    @StateObject var signVM: SignupViewModel
    
    @State private var showConfirmationDialog = false
    
    
    var body: some View {
        VStack(alignment: .center) {
            
            AppNavigationBar(type: .imageHeader, searchText: .constant(""))
            
            ScrollView {
                ZStack(alignment: .bottomTrailing) {
                    signVM.profileImage
                        .resizable()
                        .frame(width: 100.aspectRatio, height: 100.aspectRatio)
                        .corner(radius: 60.aspectRatio)
                    
                    Button(action: {
                        showConfirmationDialog = true
                    }, label: {
                        Image(.icPlus)
                            .resizable()
                            .frame(width: 40.aspectRatio, height: 40.aspectRatio)
                            .offset(y: 12.0.aspectRatio)
                            .shadow(color: .appGrey.opacity(0.6), radius: 8, y: 8)
                    })
                }.padding(.top, 16.aspectRatio)
                
                VStack(spacing: 10.aspectRatio) {
                    AppTextField(
                        text: signVM.binding(for: \.fullname),
                        title: "Fullname",
                        placeholder: "John Martin"
                    )
                    
                    AppTextField(
                        text: signVM.binding(for: \.email),
                        title: "Email",
                        placeholder: "abc@xyz.com",
                        keyboard: .emailAddress
                    )
                    
                    AppTextField(
                        text: signVM.binding(for: \.phone),
                        title: "Phone",
                        placeholder: "9898656532",
                        keyboard: .phonePad,
                        maxLength: 10
                    )
                    
                    AppTextField(
                        text: signVM.binding(for: \.password),
                        title: "Password",
                        placeholder: "********",
                        suffixImage: signVM.secured ? "eye.slash" : "eye",
                        secured: signVM.secured
                    ) {
                        signVM.secured.toggle()
                    }
                    
                    AppTextField(
                        text: signVM.binding(for: \.confirmPassword),
                        title: "Confirm Password",
                        placeholder: "********",
                        suffixImage: signVM.confirmSecured ? "eye.slash" : "eye",
                        secured: signVM.confirmSecured
                    ) {
                        signVM.confirmSecured.toggle()
                    }
                    
                    AppPrimaryButton(title: "Singup") {
                        if signVM.validate() {
                            Task {
                                if await signVM.signup() {
                                    router.navigate(to: .verifyOtp)
                                }
                            }
                        }
                    }
                    .padding(.vertical, 30.aspectRatio)
                }
                
                Spacer()
                
                HStack {
                    Text("Already have an account?")
                        .foregroundStyle(.appGrey)
                    Button(action: {
                        dismiss.callAsFunction()
                    }, label: {
                        Text("Login")
                    })
                }
                .font(.lato(.medium, size: 16))
                .padding(.top, 16.aspectRatio)
            }
            .scrollIndicators(.never)
            
        }
        .padding(16.aspectRatio)
        .toast(toast: $signVM.toast)
        .loader(loading: signVM.isLoading)
        .confirmationDialog("Choose image to pick from", isPresented: $showConfirmationDialog, actions: {
            Button {
                //                signVM.btnCameraAction()
            } label: {
                Text("Camera")
            }
            
            Button {
                signVM.btnGalleryAction()
            } label: {
                Text("Photos")
            }
            
        })
        .navigationBarBackButtonHidden()
        
    }
}

#Preview {
    SignupView(signVM: SignupViewModel(appWrite: Appwrite()))
}
