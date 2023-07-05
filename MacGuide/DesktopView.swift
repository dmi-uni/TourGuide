//
//  ContentView.swift
//  MacGuide
//
//  Created by Danil Masnaviev on 16/05/22.
//

import SwiftUI

struct DesktopView: View {
    var body: some View {
        MapView()
            .environmentObject(MapViewModel())
            .environmentObject(FirebaseViewModel())
//        Text("Hello, world!")
//            .padding()
    }
}

struct DesktopView_Previews: PreviewProvider {
    static var previews: some View {
        DesktopView()
            .frame(width: 800.0, height: 600.0)
    }
}
