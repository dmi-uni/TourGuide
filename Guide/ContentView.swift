//
//  ContentView.swift
//  Guide
//
//  Created by Danil Masnaviev on 05/05/22.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var manager = LocationManager.shared
    @EnvironmentObject private var vm: MapViewModel
    
    var body: some View {
        Group {
            if manager.userLocation == nil {
                LocationRequestView()
            } else {
                TabView {
                    MapView()
                        .tabItem {
                            Image(systemName: "figure.walk")
                            Text("Discover")
                        }
                    SearchLocationView()
                        .tabItem {
                            Image(systemName: "mappin.and.ellipse")
                            Text("Add places")
                        }
                }
                .onAppear {
                    UITabBar.appearance().backgroundColor = .white
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
