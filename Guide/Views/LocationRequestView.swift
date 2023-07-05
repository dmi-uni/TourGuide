//
//  LocationRequestView.swift
//  Guide
//
//  Created by Danil Masnaviev on 06/05/22.
//

import SwiftUI

struct LocationRequestView: View {
    var body: some View {
        ZStack {
            Color.blue.ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Image(systemName: "map.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding(.bottom, 32)
                
                Text("Would you like to explore places nearby?")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Text("Start sharing your location")
                    .multilineTextAlignment(.center)
                    .padding()
                
                Spacer()
                
                VStack {
                    Button {
                        LocationManager.shared.requestLocation()
                    } label: {
                        Text("Allow Location")
                            .padding()
                            .font(.headline)
                            .foregroundColor(Color.blue)
                    }
                    .frame(width: UIScreen.main.bounds.width)
                    .padding(.horizontal, -32)
                    .background(Color.white)
                    .clipShape(Capsule())
                }
                .padding(.bottom, 32)
            }
            .foregroundColor(.white)
        }
    }
}

struct LocationRequestView_Previews: PreviewProvider {
    static var previews: some View {
        LocationRequestView()
    }
}
