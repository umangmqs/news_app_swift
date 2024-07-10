//
//  NewsDetailView.swift
//  NewsAppSwift
//
//  Created by MQF-6 on 09/07/24.
//

import SwiftUI

struct NewsDetailView: View {
    @State private var scale: Double = 1

    var body: some View {
        VStack {
            AppNavigationBar(
                type: .multipleTrailingWithBack,
                searchText: .constant(""),
                leadingImage: .icBack,
                trailingImage: .icBookmark,
                traling2Image: .icShare
            )
            
            ZStack(alignment: .bottom) {
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("World’s best spicy foods: 20 dishes to try")
                            .font(.lato(.medium, size: 20 * scale))
                            .padding(.top, 34.aspectRatio)
                        
                        HStack {
                            Text("CNN")
                            RoundedRectangle(cornerRadius: 2.aspectRatio)
                                .frame(width: 3.aspectRatio, height: 3.aspectRatio)
                            
                            Text("April 21, 2024")
                        }
                        .font(.lato(size: 12 * scale))
                        .foregroundStyle(.appGrey)
                        
                        ZStack {
                            Color.appGreyLight
                            Image(.icNewsPlaceholder)
                        }
                        .frame(height: 220.aspectRatio * scale)
                        .corner(radius: 16.aspectRatio)
                        .padding(.top, 10.aspectRatio)
                        
                        HStack {
                            Spacer()
                            Text("Pexels.com")
                                .font(.lato(size: 12 * scale))
                                .foregroundStyle(.appGrey)
                                .padding(.top, 2.aspectRatio)
                                .padding(.bottom, 8.aspectRatio)
                            Spacer()
                        }
                        
                        Text("""
        Some like it hot – and some like it hotter, still.
        
        When it comes to the world’s best spicy dishes, we have some of the world’s hottest peppers to thank, along with incredible layers of flavor and a long, spice-loving human history.
        
        “Spicy food, or at least spiced foods, clearly predates the idea of countries and their cuisine by a very, very long time,” says Indian author Saurav Dutt, who is writing a book about the spiciest foods on the Indian subcontinent.
        
        “Every spicy ingredient has a wild ancestor,” he says. “Ginger, horseradish, mustard, chiles and so on have predecessors which led to their domestication.”
        
        Hunter-gatherer groups historically made use of various wild ingredients to flavor their foods, Dutt says, and there are many ingredients all over the world that can lend a spicy taste to a dish or stand on their own.
        
        Peppers – a headliner for heat – are rated on the Scoville Heat Units scale, which measures capsaicin and other active components of chile peppers. By that measure, the Carolina Reaper is among the hottest in the world, while habaneros, Scotch bonnets and bird’s eye chiles drop down a few rungs on the mop-your-brow scale.
        
        Redolent with ghost peppers, Scotch bonnets, serranos, chiltepin peppers, mouth-numbing Sichuan peppercorns and more, the following spicy dishes from around the world bring the heat in the most delicious way.
        
        Egusi soup, Nigeria
        Ata rodo – Scotch bonnet pepper – brings the fire to Nigeria’s famous spicy soup. Egusi is made by pounding the seeds from the egusi melon, an indigenous West African fruit that’s related to the watermelon.
        
        In addition to being protein-packed, the melon’s seeds serve to thicken and add texture and flavor to the soup’s mix of meat, seafood and leafy vegetables. Pounded yams are often served alongside this dish, helping to temper the scorch of the Scotch bonnets.
        
        """)
                        .font(.lato(size: 14 * scale))
                    }
                    Spacer()
                }
                .scrollIndicators(.never)
                
                HStack {
                    CircularButton(image: .icPlus1) {
                        scale += 0.1
                    }
                    
                    CircularButton(image: .icMinus) {
                        if scale > 1 {
                            scale -= 0.1
                        }
                    }
                }
            }
            

        }
        .padding(.horizontal, 16.aspectRatio)
        .navigationBarBackButtonHidden()
        
    }
}

struct CircularButton: View {
    var image: ImageResource
    var onTap: () -> ()
    
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
    NewsDetailView()
}
