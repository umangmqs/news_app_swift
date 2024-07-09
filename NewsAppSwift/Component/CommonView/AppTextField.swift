//
//  AppTextField.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 28/06/24.
//

import SwiftUI

struct AppTextField: View {
    
    @Binding var text: String
    var title: String?
    var placeholder: String = ""
    var suffixImage: String = ""
    var secured: Bool = false
    var keyboard: UIKeyboardType = .default
    var maxLength: Int = 40
    var suffixAction: (() -> ())?
    
    var body: some View {
        VStack(alignment: .leading) {
            if let title = title {
                Text(title)
                    .font(.lato(.medium, size: 14))
                    .foregroundStyle(.appGrey)
            }
            
            HStack {
                commonStyle {
                    secured ? 
                    AnyView(SecureField("", text: $text)) :
                    AnyView(
                        TextField("", text: $text)
                            .textInputAutocapitalization(.never)
                            .onChange(of: text) { newValue in
                                if newValue.count > maxLength {
                                    text = String(newValue.prefix(maxLength))
                                }
                            }
                    )
                }
                
                if !suffixImage.isEmpty {
                    Image(systemName: suffixImage)
                        .onTapGesture {
                            suffixAction?()
                        }
                        .foregroundStyle(.appPrimaryLight)
                        
                }
            }
            .frame(height: 55.aspectRatio)
            .padding(.horizontal, 14.aspectRatio)
            .border(radius: 5.aspectRatio, color: .appPrimaryLight)
            .animation(.easeIn, value: suffixImage)
        }
        .padding(.top, 16.aspectRatio)
    }
    
    @ViewBuilder
    func commonStyle<Content: View>(
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack {
            content()
                .placeHolder(placeholder, show: text.isEmpty)
                .font(.montserrat(size: 16.aspectRatio))
                .keyboardType(keyboard)
        }
    }
}

struct AppSearchField: View {
    @Binding var text: String
    @State var placeholder: String = ""
    
    var body: some View {
        HStack {
            TextField("", text: $text)
                .placeHolder(placeholder, show: text.isEmpty)
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.appPrimary)
        }
        .padding(.horizontal, 16.aspectRatio)
        .frame(height: 46.aspectRatio)
        .background(.appPrimaryLight.opacity(0.3))
        .corner(radius: 23.aspectRatio)
    }
}



#Preview {
    AppTextField(text: .constant(""), title: "Email address", placeholder: "abx@xyz.com", suffixImage: "eye", secured: true) {
    }
}
