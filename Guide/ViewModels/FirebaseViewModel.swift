//
//  FirebaseViewModel.swift
//  Guide
//
//  Created by Vlad Likh on 11.05.2022.
//

import Foundation
import Firebase
import SwiftUI
import CoreLocation

class FirebaseViewModel: ObservableObject {
    
    @Published var locations: [Location] = []
    
    func addPin(location: Location) {
        let myLatitude = location.coordinates.latitude
        let myLongitude = location.coordinates.longitude
        let db = Firestore.firestore()
        let ref = db.collection("\(location.cityName)").document("\(location.id)")
        ref.setData(["Name": location.name,
                     "Latitude": myLatitude,
                     "Longitude": myLongitude,
                     "Description": location.description,
                     "Type": location.type,
                     "ImageURL": location.imageURL]) { error in
            if error != nil {
                print("alert")
            } else {
                print("success")
            }
        }
    }
    
    func loadCity(cityName: String){
        let db = Firestore.firestore()
        var loadedPlaces = [Location]()

        db.collection(cityName).getDocuments() { (snapshot, error) in
            guard let snapshot = snapshot, error == nil else {
                return
            }

            for document in snapshot.documents {
                let location = Location(name: document["Name"] as! String,
                                        cityName: cityName,
                                        coordinates: CLLocationCoordinate2D(latitude: document["Latitude"] as! CLLocationDegrees, longitude: document["Longitude"] as! CLLocationDegrees),
                                        type: document["Type"] as! String,
                                        description: document["Description"] as! String,
                                        imageURL: document["ImageURL"] as! String)

                loadedPlaces.append(location)
                
            }
        }
    }
    
    func startMonitoringRegions() {
        for location in locations {
            LocationManager.shared.monitorRegion(center: location.coordinates, identifier: location.name)
            print(location.name)
        }
    }
}
