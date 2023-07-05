//
//  TourPageView.swift
//  Guide
//
//  Created by Vladislav Likh on 18/05/22.
//

import SwiftUI

struct TourPageView: View {
    @EnvironmentObject var toursViewModel: ToursViewModel
    var tour: Tour
    private var title: String {tour.title}
    private var description: String {tour.description}
    private var tags: [Tags] {tour.tags}
    private var foregroundColor: Color {tour.tags[0].color()}
    private var image: Image {tour.image}
    private var place: String {tour.location}
    private var time: Int {tour.time}
    private var amountOfPlaces: Int {toursViewModel.listOfPlaces.count}
    
    var body: some View {
        ZStack {
            foregroundColor.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.system(size: 58, weight: .regular))
                        .foregroundColor(.black)
                        .textCase(.uppercase)
                        .lineSpacing(0)
                        .padding(.bottom, 10)
                        .padding(.horizontal, 20)
                    HStack {
                        ForEach(0..<tags.count) { num in
                            HStack(spacing: 5) {
                                SmallTagView(text: tags[num].withEmoji())
                            }
                            
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                    
                    Text(description)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.black)
                        .lineSpacing(5)
                        .padding(.bottom, 30)
                        .padding(.horizontal, 20)
                    Spacer()
                    TourPagePhotosView()
                        .padding(.bottom, 30)
                    Spacer()
                    TourPageNumbersView(time: time, amount: amountOfPlaces)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 120)
                    
                }
                
            }
            .mask(
                LinearGradient(gradient: Gradient(colors: [.white, .white, .white, .white, .white.opacity(0)]), startPoint: .top, endPoint: .bottom)
            )
            VStack {
                Spacer()
                Button {
                } label: {
                    NavigationLink {
                        ContentView()
                    } label: {
                        RoundedRectangle(cornerRadius: 13, style: .continuous)
                            .frame(height: 65)
                            .foregroundColor(.black)
                            .overlay(
                                Text("Open map")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20, weight: .semibold))
                            )
                    }
                    
                    
                }
                .padding(.horizontal, 20)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        //        .navigationTitle(title)
        .navigationBar(backgroundColor: foregroundColor.opacity(0), titleColor: .black)
        .onAppear() {
            toursViewModel.parsePlacesFromTour(title)
        }
        //        .onAppear() {
        //            UINavigationBar.appearance().largeTitleTextAttributes = [.font:UIFont.preferredFont(forTextStyle:.largeTitle)]
        //            UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: ".SFProText-Regular", size: 120)!]
        //
        //        }
    }
}

struct TourPagePhotosView: View {
    var images = [Image("Sunset"), Image("Sunset"), Image("Sunset"), Image("Sunset")]
    var body: some View {
        ScrollView([.horizontal], showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(0..<images.count) { n in
                    images[n]
                        .resizable()
                        .aspectRatio(16/9, contentMode: .fit)
                        .frame(height: 130)
                        .mask(RoundedRectangle(cornerRadius: 13)
                            .aspectRatio(16/9, contentMode: .fit)
                            .frame(height: 130))
                }
                
            }
            .padding(.horizontal, 20)
        }
    }
}


struct TourPageNumbersView: View {
    var time: Int
    var amount: Int
    var numbers: [Int] { [time, amount, 12] }
    var texts =  ["hours usually takes", "places in the guide", "kilometers for a walk"]
    
    var body: some View {
        HStack(spacing: 0) {
            Spacer()
            ForEach(0..<3) { n in
                VStack(alignment: .center, spacing: 0) {
                    Text("\(numbers[n])")
                        .font(.system(size: 36, weight: .regular))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                    Text(texts[n])
                        .font(.system(size: 12, weight: .regular))
                        .multilineTextAlignment(.center)
                }
                .frame(width: 80)
                if n < 2 {
                    Spacer()
                    Divider()
                        .frame(height: 80)
                    Spacer()
                }
            }
            Spacer()
        }
    }
}

struct TourPageView_Previews: PreviewProvider {
    static var previews: some View {
        ToursGridView()
            .environmentObject(ToursViewModel())
    }
}
