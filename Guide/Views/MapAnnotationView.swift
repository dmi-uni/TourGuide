//
//  MapAnnotationView.swift
//  Guide
//
//  Created by Danil Masnaviev on 06/05/22.
//

import SwiftUI

struct MapAnnotationView: View {
    
    @EnvironmentObject private var toursVM: ToursViewModel
    
    let accentColor = Color("AccentColor")
    let pinColor = Color("Pin")
    @State var placeInfoShown = false
//    var title: String
//    var imageLink: String
//    var description: String
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Image(systemName: "mappin")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(pinColor)
                    .cornerRadius(36)
            }
            
            Image(systemName: "triangle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 8, height: 8)
                .foregroundColor(pinColor)
                .rotationEffect(Angle(degrees: 180))
                .offset(y: -3)
            
            Circle()
                .frame(width: 6)
                .foregroundColor(pinColor)
                .padding(.bottom, 40)
        }
//        .popover(isPresented: $placeInfoShown) {
//                   Text("Your content here")
//                       .font(.headline)
//                       .padding()
//               }
        
//        .sheet(isPresented: $placeInfoShown, onDismiss: nil) {
//            PlaceInformationView(placeInfoShown: $placeInfoShown)
//        }
    }
}

struct PlaceInformationView: View {
    @Binding var placeInfoShown: Bool
    var body: some View {
        Rectangle()
    }
}

struct MapAnnotationView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            MapAnnotationView()
        }
    }
}
