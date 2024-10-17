//
//  ToastView.swift
//  MoodTrackingSwiftUI
//
//  Created by MQF-6 on 06/06/24.
//

import SwiftUI

struct ToastView: View {
    var message: String
    var width = CGFloat.infinity

    var body: some View {
        HStack(alignment: .center, spacing: 12.aspectRatio) {
            Text(LocalizedStringKey(message))
                .font(.montserrat(.semibold, size: 16))
                .foregroundColor(.white)
                .lineLimit(3)

            Spacer(minLength: 10.aspectRatio)
        }
        .padding()
        .frame(minWidth: 0, maxWidth: width)
        .background(.appPrimary)
        .corner(radius: 8.aspectRatio)
        .padding(.horizontal, 16.aspectRatio)
    }
}

#Preview {
    ToastView(message: "Heelo")
}
