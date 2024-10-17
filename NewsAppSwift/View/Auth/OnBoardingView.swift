//
//  OnBoardingView.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 02/07/24.
//

import SwiftUI

struct OnBoardingView: View {
    @EnvironmentObject var router: Router
    @AppStorage(StorageKey.onboarded) var onboarded = false

    @State private var position: CGSize = .zero
    @State private var offset: Int = 0

    var arrOnboarding: [MDLOnboarding] = [
        MDLOnboarding(
            title: "The best digital magazine.",
            subTitle:
                "Start exploring the hottest news topics around the world with us anywhere.",
            image: "ic_onboarding_1"),

        MDLOnboarding(
            title: "Stay up to date with selected news",
            subTitle:
                "Get the latest news selected by editors according to your interests from all over the world.",
            image: "ic_onboarding_2"),

        MDLOnboarding(
            title: "Enrich your understanding of the world.",
            subTitle:
                "The latest and hottest news from around the world, making you understand more about your surroundings.",
            image: "ic_onboarding_3"),
    ]

    var body: some View {
        VStack {
            Text("NewsTren.")
                .font(.montserrat(.medium, size: 20))
                .padding(.bottom, 40.aspectRatio)

            TabView(selection: $offset) {
                ForEach(0..<arrOnboarding.count, id: \.self) { index in
                    VStack {
                        Image(arrOnboarding[index].image)
                            .padding(.bottom, 50.aspectRatio)

                        Text(arrOnboarding[index].title)
                            .font(.montserrat(.medium, size: 24))
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 16.aspectRatio)
                            .padding(.horizontal, 30.aspectRatio)

                        Text(arrOnboarding[index].subTitle)
                            .font(.lato(size: 14))
                            .foregroundColor(.appGrey)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40.aspectRatio)
                    }
                    .animation(.easeInOut, value: offset)
                    .frame(width: UIScreen.main.bounds.width)
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            HStack {
                ForEach(0..<arrOnboarding.count, id: \.self) { index in
                    BottomIndicatorView(
                        color: offset == index ? .appGrey : .appGreyLight)
                }
            }
            .padding(.vertical, 30.aspectRatio)
            .animation(.easeIn(duration: 0.4), value: offset)

            Spacer()

            AppPrimaryButton(
                title: offset == (arrOnboarding.count - 1) ? "Done" : "Next",
                width: 170.aspectRatio
            ) {
                if offset == (arrOnboarding.count - 1) {
                    router.push(to: .login)
                    return
                }
                offset += 1
            }
            .padding(.bottom, 16.aspectRatio)
        }
        .padding(.horizontal, 16.aspectRatio)
        .gesture(
            DragGesture()
                .onChanged { value in
                    position = value.translation
                }
                .onEnded { value in
                    if value.translation.width > 50, offset > 0 {
                        offset -= 1
                    } else if value.translation.width < -50,
                        offset < arrOnboarding.count - 1
                    {
                        offset += 1
                    }
                }
        )
        .onAppear {
            onboarded = true
        }
    }
}

#Preview {
    OnBoardingView()
        .environmentObject(Router())
}

struct BottomIndicatorView: View {
    var color: Color

    var body: some View {
        RoundedRectangle(cornerRadius: 6.aspectRatio)
            .fill(color)
            .frame(
                width: color == .appGrey ? 36.aspectRatio : 22.aspectRatio,
                height: 6.aspectRatio
            )
    }
}
