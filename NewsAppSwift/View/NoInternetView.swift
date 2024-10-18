//
//  NoInternet.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 18/10/24.
//

import DotLottie
import SwiftUI

struct NoInternetView: View {
    var body: some View {
        ZStack {
            Color.appPrimaryLight.opacity(0.4).ignoresSafeArea()
            VStack {
                DotLottieView(
                    dotLottie: DotLottieAnimation(
                        fileName: "noInternet",
                        config: AnimationConfig(
                            autoplay: true, loop: true, mode: .bounce,
                            useFrameInterpolation: true, marker: "noInternet"
                        )
                    )
                )
                
                Text("Whoose!!\n You are not connected to internet")
                    .font(.montserrat(size: 26))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                Spacer()
            }.offset(x: 0, y: -80)
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    NoInternetView()
}
