//
//  ProfileView.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 03/07/24.
//

import SDWebImageSwiftUI
import SwiftUI

struct MDLSetting: Identifiable {
    var id: UUID = .init()
    var title: String
    var image: ImageResource

    enum Titles: String, CaseIterable, CustomStringConvertible {
        case notificationsCenter = "Notifications Center"
        case changePassword = "Change Password"
        case language = "Language"
        case faqs = "FAQs"

        var description: String {
            self.rawValue
        }
    }
}

struct ProfileView: View {
    @EnvironmentObject private var router: Router
    @StateObject var profileVM: ProfileViewModel

    var arrSettings = [
        MDLSetting(
            title: "\(MDLSetting.Titles.notificationsCenter)".localiz(),
            image: .icNotification),
        MDLSetting(
            title: "\(MDLSetting.Titles.changePassword)".localiz(),
            image: .icKey),
        MDLSetting(
            title: "\(MDLSetting.Titles.language)".localiz(), image: .icLang),
        MDLSetting(title: "\(MDLSetting.Titles.faqs)".localiz(), image: .icFaq)
    ]

    @State private var showAlert = false
    @State private var showWebView = false

    @State private var notificationON = false

    var body: some View {
        VStack(alignment: .center) {
            VStack {
                AppNavigationBar(
                    type: .title, searchText: .constant(""),
                    title: "Profile".localiz())

                profileSection

                //                HStack(spacing: 20.aspectRatio) {
                //                    ForEach(0..<3) { _ in
                //                        profileMiddleSection
                //                    }
                //                }
                //                .foregroundStyle(.white)
                //                .frame(height: 75.aspectRatio)
                //                .padding(.top, 25.aspectRatio)
            }

            HStack {
                Text(LocalizedStringKey("Settings"))
                    .font(.montserrat(.medium, size: 24))
                    .padding(.top, 25.aspectRatio)
                Spacer()
            }

            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(arrSettings, id: \.id) { data in
                        if data.title.localiz()
                            == "\(MDLSetting.Titles.notificationsCenter)"
                            .localiz() {
                            SettingCell(
                                data: data, hasSwitch: true,
                                isOn: $notificationON
                            ) { _ in
                            }
                        } else {
                            SettingCell(
                                data: data,
                                lastId: arrSettings[arrSettings.count - 1].id,
                                isOn: .constant(false)
                            ) { setting in
                                if setting.title.localiz()
                                    == "\(MDLSetting.Titles.faqs)".localiz() {
                                    //                                    showWebView = true
                                } else if setting.title.localiz()
                                    == "\(MDLSetting.Titles.changePassword)"
                                    .localiz() {
                                    router.push(to: .changePassword)
                                } else if setting.title.localiz()
                                    == "\(MDLSetting.Titles.language)".localiz() {
                                    router.push(to: .languegeSelection)
                                }
                            }
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .onChange(of: notificationON) { newValue in
                AppPrint.debugPrint("NotificationON: \(newValue)")
            }

            Spacer()

            HStack(spacing: 12.aspectRatio) {
                Button(action: {
                    showAlert = true
                }) {
                    Spacer()
                    Image(.icLogout)
                    Text(LocalizedStringKey("Log Out"))
                        .font(.lato(.bold, size: 14))
                        .foregroundStyle(.appRed)
                    Spacer()
                }
                .frame(height: 50.aspectRatio)
                .border(radius: 25.aspectRatio, color: .appRed, lineWidth: 2)
                .padding(.bottom, 16.aspectRatio)
            }
        }
        .padding(.horizontal, 16.aspectRatio)
        //        .navigationDestination(isPresented: $showWebView, destination: {
        //            WebView(url: "https://www.google.com")
        //        })
        .alert("Logout".localiz(), isPresented: $showAlert) {
            Button("No".localiz()) {}

            Button("Yes".localiz()) {
                Task {
                    await profileVM.logoutAction()
                }
            }
        } message: {
            Text(LocalizedStringKey("Are you sure want to logout?"))
        }
    }
}

extension ProfileView {
    var profileSection: some View {
        VStack {
            ZStack(alignment: .bottomTrailing) {
                ZStack {
                    Image(.icUser)
                        .resizable()
                    WebImage(
                        url: URL(string: Constants.userInfo?.profileImage ?? "")
                    )
                    .resizable()
                    .scaledToFit()
                    .transition(.fade(duration: 2))
                }
                .frame(width: 100.aspectRatio, height: 100.aspectRatio)
                .corner(radius: 50.aspectRatio)
            }
            .padding(.top, 8.aspectRatio)

            VStack(spacing: 6.aspectRatio) {
                Text(Constants.userInfo?.fullname ?? "")
                    .font(.montserrat(.medium, size: 18))

                HStack(alignment: .bottom) {
                    Text(verbatim: Constants.userInfo?.email ?? "")
                        .foregroundStyle(.appGrey)
                        .font(.lato(size: 12))

                    Button(action: {}) {
                        Image(.icEdit)
                            .flipsForRightToLeftLayoutDirection(true)

                    }
                }
            }
        }
    }

    var profileMiddleSection: some View {
        RoundedRectangle(cornerRadius: 25.0.aspectRatio)
            .fill(.appPrimary)
            .frame(width: (UIDevice.screenWidth - 80.aspectRatio) / 3)
            .overlay {
                VStack {
                    Text("5")
                        .font(.montserrat(.bold, size: 24))

                    Text("Interesting")
                        .font(.montserrat(.medium, size: 12))
                }
            }
            .shadow(color: .appShadow, radius: 10, y: 4)
    }
}

#Preview {
    ProfileView(profileVM: ProfileViewModel(appWrite: Appwrite()))
}
