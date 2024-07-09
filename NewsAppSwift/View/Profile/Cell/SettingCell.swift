//
//  SettingCell.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 03/07/24.
//

import SwiftUI

struct SettingCell: View {
    var data: MDLSetting
    var lastId: UUID
    var onTap: () -> ()
    
    var body: some View {
        VStack {
            HStack(spacing: 14.aspectRatio) {
                Image(data.image)
                    .frame(width: 33.aspectRatio, height: 20.aspectRatio)
                
                Text(data.title)
                    .font(.lato(.medium, size: 14))
                
                Spacer()
                
                Image(.icArrowRight)
            }
            .padding(.vertical, 10.aspectRatio)
            
            Rectangle()
                .fill(lastId == data.id ? .clear : .appGrey.opacity(0.2))
                .frame(height: 2)
        }
        .onTapGesture {
            onTap()
        }
    }
}
