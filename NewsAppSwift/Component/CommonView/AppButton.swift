//
//  AppButton.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 28/06/24.
//

import SwiftUI

struct AppPrimaryButton: View {
    var title: String
    var width: CGFloat?
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack {
                Spacer()
                Text(title)
                    .font(.lato(.bold, size: 14))
                    .foregroundStyle(.white)
                Spacer()
            }
        }
        .frame(width: width, height: 55.aspectRatio)
        .background(.appPrimary)
        .corner(radius: 5.aspectRatio)
    }
}

struct AppSocialButton: View {
    var title: String
    var image: String
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14.aspectRatio) {
                Spacer()
                Image(image)
                    .resizable()
                    .frame(width: 24.aspectRatio, height: 24.aspectRatio)

                Text(title)
                    .font(.lato(.bold, size: 14))
                    .foregroundStyle(.appBlack)
                Spacer()
            }
        }
        .frame(height: 55.aspectRatio)
        .background(.appPrimaryLight)
        .corner(radius: 5.aspectRatio)
        .shadow(color: .appShadow, radius: 10, x: 0.0, y: 10)
    }
}

struct CircularButton: View {
    var image: ImageResource
    var onTap: () -> Void

    var body: some View {
        Circle()
            .fill(.appPrimary)
            .frame(width: 50.aspectRatio, height: 50.aspectRatio)
            .overlay {
                Image(image)
            }
            .onTapGesture {
                onTap()
            }
    }
}

#Preview {
    AppSocialButton(title: "Login", image: "ic_google") {
        AppPrint.debugPrint("Tapped")
    }
}
