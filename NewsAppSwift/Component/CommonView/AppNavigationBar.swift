//
//  AppNavigationBar.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 02/07/24.
//

import SDWebImageSwiftUI
import SwiftUI

enum NavigationBarType {
    case imageHeader
    case searchWithLeadingTrailing
    case multipleTrailingWithBack
    case multipleTrailingWithProfile
    case title
    case titleAndLeading
}

struct AppNavigationBar: View {
    var type: NavigationBarType
    @Binding var searchText: String

    var leadingAction: (() -> Void)?
    var trailingAction: (() -> Void)?
    var trailing2Action: (() -> Void)?

    var leadingImage: ImageResource!
    var trailingImage: ImageResource!
    var traling2Image: ImageResource!

    var title: String?
    var isShowingDot: Bool = false

    @State private var greeting: String = ""

    var body: some View {
        if type == .imageHeader {
            Image(.icLogo)

        } else if type == .searchWithLeadingTrailing {
            HStack(spacing: 12.aspectRatio) {
                AppSearchField(text: $searchText, placeholder: "Search")
            }
            .frame(height: 50.aspectRatio)

        } else if type == .multipleTrailingWithBack {
            HStack(spacing: 12.aspectRatio) {
                Circle()
                    .fill(.appPrimary)
                    .overlay {
                        Image(leadingImage)
                    }
                    .onTapGesture {
                        leadingAction?()
                    }

                Spacer()

                commonButtons
            }
            .frame(height: 50.aspectRatio)

        } else if type == .title {
            Text(title ?? "")
                .font(.montserrat(.semibold, size: 24))
        } else if type == .titleAndLeading {
            ZStack {
                Text(title ?? "")
                    .font(.montserrat(.semibold, size: 24))

                HStack {
                    Button {
                        leadingAction?()
                    } label: {
                        Image(leadingImage)
                            .renderingMode(.template)
                            .foregroundStyle(.appPrimary)
                    }
                    Spacer()
                }
            }
        } else if type == .multipleTrailingWithProfile {
            HStack {
                HStack {
                    ZStack {
                        Image(.icUser)
                            .resizable()
                            .scaledToFit()
                        WebImage(url: URL(string: "\(Constants.userInfo?.profileImage ?? "" + "11231")"))
                            .resizable()
                            .transition(.fade(duration: 2))
                    }
                    .frame(width: 60.aspectRatio, height: 60.aspectRatio)
                    .corner(radius: 30.aspectRatio)

                    VStack(alignment: .leading) {
                        Text(greeting)
                            .font(.montserrat(size: 12))
                        Text("\(Constants.userInfo?.fullname ?? "")")
                            .font(.montserrat(.medium, size: 14))
                            .lineLimit(1)
                    }
                    .onAppear {
                        updateGreeting()
                    }
                }
                Spacer()

                commonButtons
            }
            .frame(height: 50.aspectRatio)
        }
    }

    var commonButtons: some View {
        HStack {
            Circle()
                .fill(.appPrimary)
                .overlay {
                    Image(trailingImage!)
                }
                .onTapGesture {
                    trailingAction?()
                }

            Circle()
                .fill(.appPrimary)
                .overlay {
                    Image(traling2Image!)
                        .overlay {
                            isShowingDot ?
                                AnyView(Circle()
                                    .fill(.blue)
                                    .frame(width: 8.aspectRatio, height: 8.aspectRatio)
                                    .offset(x: 10.0.aspectRatio, y: -6.0.aspectRatio))
                                : AnyView(EmptyView())
                        }
                }
                .onTapGesture {
                    trailing2Action?()
                }
        }
    }

    func updateGreeting() {
        let hour = Calendar.current.component(.hour, from: Date())

        if hour < 12 {
            greeting = "Good Morning"
        } else if hour < 18 {
            greeting = "Good Afternoon"
        } else {
            greeting = "Good Evening"
        }
    }
}
