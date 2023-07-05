//
//  LocationManager.swift
//  Guide
//
//  Created by Danil Masnaviev on 06/05/22.
//

import Foundation
import CoreLocation
import UserNotifications
import MapKit
import Combine
import AVKit
import AVFAudio
import AVFoundation
import Firebase

class LocationManager: NSObject, ObservableObject, MKMapViewDelegate {
    
    @Published var manager = CLLocationManager()
    @Published var userLocation: CLLocation?
    @Published var mapView: MKMapView = .init()
    @Published var searchText: String = ""
    @Published var fetchedPlaces: [CLPlacemark]?
    @Published var pickedLocation: CLLocation?
    @Published var pickedPlaceMark: CLPlacemark?
    
    var cancellable: AnyCancellable?
    
    static let shared = LocationManager()
    
    var previousNotificationID: String?
    
    
    override init() {
        super.init()
        mapView.delegate = self
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        
        cancellable = $searchText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink(receiveValue: { value in
                if value != "" {
                    self.fetchPlaces(value: value)
                } else {
                    self.fetchedPlaces = nil
                }
            })
    }
    
    func fetchPlaces(value: String) {
        Task {
            do {
                let request = MKLocalSearch.Request()
                request.naturalLanguageQuery = value.lowercased()
                
                let response = try await MKLocalSearch(request: request).start()
                
                await MainActor.run(body: {
                    self.fetchedPlaces = response.mapItems.compactMap({ item -> CLPlacemark? in
                        return item.placemark
                    })
                })
            }
        }
        
        print(value)
    }
    
    func requestLocation() {
        manager.requestAlwaysAuthorization()
    }
    
    func monitorRegion(center: CLLocationCoordinate2D, identifier: String) {
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            let region = CLCircularRegion(center: center, radius: 50, identifier: identifier)
            region.notifyOnEntry = true
            region.notifyOnExit = true
            
            manager.startMonitoring(for: region)
        }
    }
    
    func addDraggablePin(coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Add this location"
        
        mapView.addAnnotation(annotation)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let marker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "LOCATIONPIN")
        self.pickedLocation = .init(latitude: marker.annotation?.coordinate.latitude ?? 0, longitude: marker.annotation?.coordinate.longitude ?? 0)
        marker.isDraggable = true
        marker.canShowCallout = false
        
        return marker
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        guard let newLocation = view.annotation?.coordinate else { return }
        self.pickedLocation = .init(latitude: newLocation.latitude, longitude: newLocation.longitude)
        updatePlacemark(location: .init(latitude: newLocation.latitude, longitude: newLocation.longitude))
    }
    
    func updatePlacemark(location: CLLocation) {
        Task{
            do {
                guard let place = try await reverseLocationCoordinates(location: location) else { return }
                await MainActor.run(body: {
                    self.pickedPlaceMark = place
                })
            } catch {
                // HANDLE ERROR
            }
        }
    }
    
    func reverseLocationCoordinates(location: CLLocation) async throws -> CLPlacemark? {
        let place = try await CLGeocoder().reverseGeocodeLocation(location).first
        
        return place
    }
    
    func pronounceText(text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.4
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // HANDLE ERROR
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            print("DEBUG: Not Determined")
//            manager.requestAlwaysAuthorization()
        case .restricted:
            print("DEBUG: Restricted")
        case .denied:
            print("DEBUG: Denied")
        case .authorizedAlways:
            print("DEBUG: Auth Always")
            manager.requestLocation()
        case .authorizedWhenInUse:
            print("DEBUG: Auth When In Use")
            manager.requestLocation()
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.userLocation = location
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("DEBUG: Entered region: \(region.identifier)")
        
        for location in FirebaseViewModel().locations {
            if location.name == region.identifier {
                pronounceText(text: location.description)
            }
        }
        
        let content = UNMutableNotificationContent()
        content.title = "You entered \(region.identifier)"
        content.body = "Check it out!"
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let identifier = region.identifier
        
        if identifier != previousNotificationID {
            previousNotificationID = identifier
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
                if error != nil {
                    print("Error adding notification with identifier: \(identifier)")
                }
            })
        } else {
            previousNotificationID = nil
            return
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("DEBUG: Exited region: \(region.identifier)")
    }
}
