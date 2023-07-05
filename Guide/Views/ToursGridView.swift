//
//  GridView.swift
//  Guide
//
//  Created by Vladislav Likh on 18/05/22.
//

import SwiftUI

struct ToursGridView: View {
    @EnvironmentObject var toursViewModel: ToursViewModel
    var cityName = "Naples"
    var tourData: [Tour] {toursViewModel.listOfTours}
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    ForEach(tourData) { tour in
                        NavigationLink(destination: TourPageView(tour: tour)) {
                            ToursGridBlockView(tour: tour)
                                .padding(.horizontal, 20)
                        }
                    }
                }
                .padding(.top, 20)
            }
            .background(Color("Background"))
            .navigationBarHidden(true)
            .navigationTitle(cityName)
            .navigationBarTitleDisplayMode(.large)
        }
        .accentColor(.black)
        .onAppear(){ toursViewModel.parseTours(cityName) }
        //        .navigationBarHidden(true)
        //        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ToursGridBlockView: View {
    var tour: Tour
    private var title: String {tour.title}
    private var tags: [Tags] {tour.tags}
    private var foregroundColor: Color {tour.tags[0].color()}
    private var image: Image {tour.image}
    private var place: String {tour.location}
    private var time: Int {tour.time}
    private var author: String {tour.author}
    private var coverImage: Image {tour.tags[0].coverImage()}
    
    var body: some View {
        coverImage
            .resizable()
            .aspectRatio(1.25, contentMode: .fit)
            .cornerRadius(20)
            .foregroundColor(foregroundColor)
            .overlay(
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Text(title)
                            .font(.system(size: 48, weight: .semibold))
                            .textCase(.uppercase)
//                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                            .lineLimit(3)
                        Spacer()
                    }
                    Spacer()
                    HStack {
                        ForEach(0..<tags.count, id: \.self) { num in
                            SmallTagView(text: tags[num].withEmoji())
                        }
                    }
                    .padding(.leading, -1)
//                    Spacer()
                    /*
                    HStack(alignment: .bottom) {
//                        image
//                            .resizable()
//                            .frame(width: 80, height: 80)
//                            .foregroundColor(.white)
//                            .mask(Circle())
//                        Spacer()
                        
                        
                        HStack(spacing: 3) {
                            Image(systemName: "person")
                            Text("\(author)")
                                .padding(.trailing, 10)
//                            Image(systemName: "pin")
//                            Text(place)
//                                .padding(.trailing, 10)
                            Image(systemName: "clock")
                            Text("\(time) hours")
//                            Spacer()
                            
                        }
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.black)
                        .lineSpacing(0)
                        .padding(.bottom, 3)
                         
                         
                    }
                    */
                    
                }
                    .padding(15)
                
            )
    }
}


struct ToursGridView_Previews: PreviewProvider {
    static var previews: some View {
        ToursGridView()
            .environmentObject(ToursViewModel())
            .preferredColorScheme(.light)
            .previewDevice("iPhone 12")
    }
}
