//
//  LanguageCellView.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 17/10/24.
//

import SwiftUI

struct LanguageCell: View {
    let item: MDLLanguage
    let onTap: () -> Void
    var body: some View {

        HStack {
            HStack {
                Image(item.image)
                    .resizable()
                    .frame(
                        width: 30.aspectRatio,
                        height: 30.aspectRatio
                    )

                Text(LocalizedStringKey(item.languageName))
                    .font(.montserrat(size: 16))
                    .fontWeight(.medium)
                    .padding(.leading, 10.aspectRatio)
            }

            Spacer()

            Image(
                item.selected ? .icRadioChecked : .icRadioUnchecked
            )
            .resizable()
            .frame(width: 30.aspectRatio, height: 30.aspectRatio)
            .foregroundStyle(.accent)
        }
        .padding(.horizontal, 10.aspectRatio)
        .padding(.vertical, 16.aspectRatio)
        .background(Color.white)
        .corner(radius: 12.aspectRatio)
        .onTapGesture {
            onTap()
        }
        .padding(.bottom, 8.aspectRatio)
        .shadow(color: .appGrey.opacity(0.2), radius: 8, x: 0, y: 8)
    }
}
