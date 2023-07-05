//
//  MapViewModel.swift
//  Guide
//
//  Created by Danil Masnaviev on 06/05/22.
//

import MapKit
import SwiftUI

class MapViewModel: ObservableObject {
    
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion()
    @Published var userLocation: CLLocationCoordinate2D
    @Published var currentLocation: Location?
    
    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    
    init() {
        let userLocation = LocationManager.shared.userLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)
        self.userLocation = userLocation
        self.updateMapRegion(coordinates: userLocation)
    }
    
    func showLocation(location: Location) {
        withAnimation(.default) {
            if currentLocation == nil || location.id != currentLocation!.id {
                currentLocation = location
                updateMapRegion(coordinates: currentLocation!.coordinates)
            } else {
                currentLocation = nil
            }
            print(currentLocation?.name ?? "None")
        }
    }
    
    func showUserLocation(coordinates: CLLocationCoordinate2D) {
        if LocationManager.shared.userLocation?.coordinate != nil {
            updateMapRegion(coordinates: LocationManager.shared.userLocation!.coordinate)
        }
    }
    
    func updateMapRegion(coordinates: CLLocationCoordinate2D) {
        withAnimation(.default) {
            mapRegion = MKCoordinateRegion(
                center: coordinates,
                span: mapSpan
            )
        }
    }
    
    func requestNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Notifications enabled!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
