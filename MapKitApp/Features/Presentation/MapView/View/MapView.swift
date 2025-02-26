//
//  MapView.swift
//  MapKitApp
//
//  Created by Danilo Osorio on 25/02/25.
//

import SwiftUI
import Observation
import MapKit

struct MapView: View {
    @Bindable var viewModel: MapViewModel
    
    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack{
            Map(position : $viewModel.cameraPosition, selection: $viewModel.mapSelection){
                UserAnnotation()
            }.mapStyle(viewModel.mapStyle.toMapStyle())
                .overlay(alignment: .topTrailing){
                    topTrailingOverlayView
                }
        }
    }
}
