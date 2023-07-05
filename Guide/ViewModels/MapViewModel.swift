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
    @Published var currentPlace: Place?
    
    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    
    init() {
        let userLocation = LocationManager.shared.userLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)
        self.userLocation = userLocation
        self.updateMapRegion(coordinates: userLocation)
    }
    
    func showLocation(place: Place) {
        if currentPlace == nil || place.id != currentPlace!.id {
            currentPlace = place
            updateMapRegion(coordinates: CLLocationCoordinate2D(latitude: place.lat, longitude: place.long))
        } else {
            currentPlace = nil
        }
        print(currentPlace?.name ?? "None")
    }
    
    func showUserLocation(coordinates: CLLocationCoordinate2D) {
        if LocationManager.shared.userLocation?.coordinate != nil {
            updateMapRegion(coordinates: LocationManager.shared.userLocation!.coordinate)
        }
    }
    
    func updateMapRegion(coordinates: CLLocationCoordinate2D) {
        mapRegion = MKCoordinateRegion(
            center: coordinates,
            span: mapSpan
        )
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
