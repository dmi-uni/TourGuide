//
//  Location.swift
//  Guide
//
//  Created by Danil Masnaviev on 06/05/22.
//

import Foundation
import CoreLocation

struct Location: Identifiable, Equatable {
    let name: String
    let cityName: String
    let coordinates: CLLocationCoordinate2D
    let type: String
    let description: String
    var imageURL: String?
    
    var id: String {
        name + cityName
    }
    
    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
}
