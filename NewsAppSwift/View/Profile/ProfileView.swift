//
//  ProfileView.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 03/07/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct MDLSetting: Identifiable {
    var id: UUID = UUID()
    var title: String
    var image: ImageResource
}

struct ProfileView: View {
    
    var arrSettings = [
        MDLSetting(title: "Notifications Center", image: .icNotification),
        MDLSetting(title: "Change Password", image: .icKey),
        MDLSetting(title: "Language ", image: .icLang),
        MDLSetting(title: "FAQs", image: .icFaq),
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack {
                AppNavigationBar(type: .title, searchText: .constant(""), title: "Profile")
                
                profileSection
                
                HStack(spacing: 20.aspectRatio) {
                    ForEach(0..<3) { _ in
                        profileMiddleSection
                    }
                }
                .foregroundStyle(.white)
                .frame(height: 75.aspectRatio)
                .padding(.top, 25.aspectRatio)
            }
            
            Text("Settings")
                .font(.montserrat(.medium, size: 24))
                .padding(.top, 25.aspectRatio)
            
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(arrSettings, id: \.id) { data in
                        SettingCell(data: data, lastId: arrSettings[arrSettings.count - 1].id) {
                            AppPrint.debugPrint(data.id)
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            
            Spacer()
            
            HStack(spacing: 12.aspectRatio) {
                Button(action: {}) {
                    Spacer()
                    Image(.icLogout)
                    Text("Log Out")
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
    }
     
    var profileSection: some View {
        VStack {
            ZStack(alignment: .bottomTrailing) {
                ZStack {
                    Image(.icUser)
                        .resizable()
                    WebImage(url: URL(string: Constants.userInfo.profileImage ?? ""))
                        .resizable()
                        .scaledToFit()
                        .transition(.fade(duration: 2))
                }
                .frame(width: 100.aspectRatio, height: 100.aspectRatio)
                .corner(radius: 50.aspectRatio)
                
                Button(action: {
                    
                }, label: {
                    Image(.icPlus)
                        .resizable()
                        .frame(width: 40.aspectRatio, height: 40.aspectRatio)
                        .offset(y: 10.0.aspectRatio)
                        .shadow(color: .appGrey.opacity(0.6), radius: 8, y: 8)
                })
            }
            .padding(.top, 8.aspectRatio)
            
            VStack(spacing: 6.aspectRatio) {
                Text(Constants.userInfo.fullname ?? "")
                    .font(.montserrat(.medium, size: 18))
                
                HStack(alignment: .bottom) {
                    Text(verbatim: Constants.userInfo.email ?? "")
                        .foregroundStyle(.appGrey)
                        .font(.lato(size: 12))
                    
                    Button(action: {}) {
                        Image(.icEdit)
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
    ProfileView()
}

