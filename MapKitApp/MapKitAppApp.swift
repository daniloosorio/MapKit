//
//  MapKitAppApp.swift
//  MapKitApp
//
//  Created by Danilo Osorio on 24/02/25.
//

import SwiftUI

@main
struct MapKitAppApp: App {
    @StateObject var manager = LocationManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(manager)
        }
    }
}
