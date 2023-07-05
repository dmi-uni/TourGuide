//
//  ToursViewModel.swift
//  Guide
//
//  Created by Danil Masnaviev on 31/05/22.
//

import Foundation
import SwiftUI

class ToursViewModel: ObservableObject {
    @Published var listOfPlaces: [Place] = []
    @Published var listOfTours: [Tour] = []
    
    
    func parseTours(_ city: String) -> [Tour] {
        let rows = extractDataFromCSV(city)
        var list = [Tour]()
        for row in rows {
            if row.count > 5 {
                let columns = row.components(separatedBy: ";")
                print(columns[3].components(separatedBy: ","))
                let tagsList = columns[3].components(separatedBy: ",").map { Tags(rawValue: $0)! }
                let tour = Tour(title: columns[0], description: columns[1], tags: tagsList, time: Int(columns[5])!, location: columns[2], author: columns[4])
                list.append(tour)
            }
        }
        listOfTours = list
        return list
    }
    
    func parsePlacesFromTour(_ name: String) -> [Place] {
        let rows = extractDataFromCSV(name)
        var list = [Place]()
        for row in rows {
            if row.count > 5 {
                let columns = row.components(separatedBy: ";")
                let place = Place(name: columns[1], description: columns[2], address: columns[5], long: Double(columns[4])!, lat: Double(columns[3])!)
                list.append(place)
            }
        }
        listOfPlaces = list
        return list
    }
    
    func extractDataFromCSV(_ name: String) -> [String] {
        guard let path = Bundle.main.path(forResource: name, ofType: "csv") else {
            listOfPlaces = []
            return []
        }
        var data = ""
        do {
            data = try String(contentsOfFile: path)
        } catch {
            print("Error")
            listOfPlaces = []
            return []
        }
        return data.components(separatedBy: "\n")
    }
}
