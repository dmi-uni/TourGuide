//
//  MapView.swift
//  Guide
//
//  Created by Danil Masnaviev on 06/05/22.
//

import SwiftUI
import MapKit
import CoreLocation
import FirebaseStorage
import SDWebImageSwiftUI

struct MapView: View {
    
    @State var imageURL = URL(string: "")
    @EnvironmentObject private var vm: MapViewModel
    @EnvironmentObject private var firebaseVM: FirebaseViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                mapLayer
                    .ignoresSafeArea()
                    .onAppear {
                        vm.requestNotifications()
                        vm.showUserLocation(coordinates: LocationManager.shared.userLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0))
                        print(vm.currentLocation?.name)
                    }
                
                VStack {
                    header
                        .padding()
                    if vm.currentLocation?.name != nil {
                        footer
                    }
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
            .environmentObject(MapViewModel())
            .environmentObject(FirebaseViewModel())
    }
}

extension MapView {
    
    private var mapLayer: some View {
        Map(
            coordinateRegion: $vm.mapRegion,
            showsUserLocation: true,
            annotationItems: firebaseVM.locations,
            annotationContent: { location in
                MapAnnotation(coordinate: location.coordinates) {
                    MapAnnotationView()
                        .scaleEffect(vm.currentLocation == location ? 1 : 0.7)
                        .onTapGesture {
                            vm.showLocation(location: location)
                            loadImage()
                            vm.mapRegion.center = location.coordinates
                        }
                }
            }
        )
        .onAppear {
            firebaseVM.startMonitoringRegions()
            firebaseVM.loadCity(cityName: "Неаполь")
        }
    }
    
    private var header: some View {
        VStack {
            HStack {
                Spacer()
                VStack {
                    Button {
                        print("Info")
                    } label: {
                        Image(systemName: "info.circle")
                            .font(.title2)
                    }
                    .padding()
                    
                    Divider()
                        .frame(maxWidth: 58)
                    
                    Button {
                        vm.showUserLocation(coordinates: LocationManager.shared.userLocation!.coordinate)
                        vm.currentLocation = nil
                    } label: {
                        Image(systemName: "location")
                            .font(.title2)
                    }
                    .padding()
                }
                .background(.thickMaterial)
                .cornerRadius(8)
                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
            }
            Spacer()
        }
    }
    
    private var footer: some View {
        PlaceInfoView(image: WebImage(url: imageURL), title: vm.currentLocation?.name ?? "", description: vm.currentLocation?.description ?? "")
//        VStack {
//            RoundedRectangle(cornerRadius: 10)
//                .aspectRatio(2.5, contentMode: .fit)
//                .foregroundColor(.white)
//                .padding(.horizontal)
//                .overlay(
//                    HStack {
//                        RoundedRectangle(cornerRadius: 10)
//                            .aspectRatio(1, contentMode: .fit)
//                            .overlay(
//                                WebImage(url: imageURL)
//                                    .resizable()
//                                    .aspectRatio(1, contentMode: .fit)
//                                    .mask(RoundedRectangle(cornerRadius: 10))
//                                )
//                            .padding()
//
//                        VStack(alignment: .leading) {
//                            Text(vm.currentLocation?.name ?? "")
//                                .font(.title2)
//                                .fontWeight(.semibold)
//                                .foregroundColor(.primary)
//                            Text(vm.currentLocation?.description ?? "")
//                                .font(.caption)
//                                .fontWeight(.semibold)
//                                .foregroundColor(.primary)
//                        }
//                        Spacer()
//
//                    }
//                    .padding()
//                )
//        }
//        .padding(.bottom, 32)
    }
    
    func loadImage() {
        if vm.currentLocation != nil {
            let storage = Storage.storage().reference(withPath: vm.currentLocation!.imageURL ?? "")
            storage.downloadURL { (url, error) in
                if error != nil {
                    return
                }
                self.imageURL = url
            }
        }
    }
}
