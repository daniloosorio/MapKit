//
//  HomeView.swift
//  MapKitApp
//
//  Created by Danilo Osorio on 25/02/25.
//

import SwiftUI

struct HomeView : View {
    @EnvironmentObject private var manager: LocationManager
    
    var body: some View {
            if let location = manager.location,
                let region = manager.region {
                    MapView(viewModel: MapViewModel(location: location, region: region))
                } else {
                    ProgressView()
                }
    }
}

