//
//  ToursGridModel.swift
//  Guide
//
//  Created by Vladislav Likh on 18/05/22.
//

import SwiftUI

struct Tour: Identifiable {
    var id = UUID()
    var title: String = ""
    var description: String = ""
    var tags: [Tags] = []
    var image: Image = Image("Sunset")
    var time: Int = 1
    var location: String
    var author: String
}

struct Place: Identifiable, Equatable {
    var id = UUID()
    var name: String
    var description: String
    var address: String
    var long: Double
    var lat: Double
    
    static func == (lhs: Place, rhs: Place) -> Bool {
        lhs.id == rhs.id
    }
}

enum Tags: String {
    case food = "Food"
    case bars = "Bars"
    case nature = "Nature"
    case stores = "Shopping"
    case history = "History"
    case walk = "Walk"
    case lgbt = "LGBT"
    case art = "Art"
    
    func withEmoji() -> String {
        switch self {
        case .food:
            return "🍔 Food"
        case .nature:
            return "🌸 Nature"
        case .stores:
            return "👔 Stores"
        case .history:
            return "⏳ History"
        case .bars:
            return "🍹 Bars"
        case .walk:
            return "🏛 Walk"
        case .lgbt:
            return "🌈 LGBT"
        case .art:
            return "🎨 Art"
        }
    }
    
    func color() -> Color {
        switch self {
        case .food:
            return Color("Yellow")
        case .nature:
            return Color("Green")
        case .stores:
            return Color("Violet")
        case .history:
            return Color("Pink")
        case .bars:
            return Color("Peach")
        case .walk:
            return Color("Blue")
        case .lgbt:
            return Color("Peach")
        case .art:
            return Color("Pink")
        }
    }
    
    func coverImage() -> Image {
        switch self {
        case .art:
            return Image("StreetArt")
        case .stores:
            return Image("VintageNaples")
        case .food:
            return Image("NeverDrinkWater")
        case .lgbt:
            return Image("RainbowCity")
        case .walk:
            return Image("WalkThrough")
        case .history:
            return Image("RioneSanita")
        default:
            return Image("emptyImage")
        }
    }
}

