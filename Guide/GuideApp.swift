//
//  GuideApp.swift
//  Guide
//
//  Created by Danil Masnaviev on 05/05/22.
//

import SwiftUI
import Firebase

@main
struct GuideApp: App {
    
    @StateObject private var vm = MapViewModel()
    @StateObject private var toursVM = ToursViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ToursGridView()
                .environmentObject(vm)
                .environmentObject(toursVM)
                .preferredColorScheme(.light)
//            FetchTestView()
//                .environmentObject(FirebaseViewModel())
        }
    }
}
