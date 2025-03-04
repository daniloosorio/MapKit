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
    @State var showErrorAlert: Bool = false
    @State var lookAroundViewIsExpanded: Bool = false
    
    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack{
            mapView
            if viewModel.lookArounScene != nil{
                lookAroundPreview
            }
        }.alert(isPresented: $showErrorAlert){
            Alert(title: Text("Important message"),
                  message: Text("Unexpected error is happen"),
                  dismissButton: .default(Text("go it")))
        }
    }
    
    var mapView: some View {
        Map(position : $viewModel.cameraPosition, selection: $viewModel.mapSelection){
            UserAnnotation()
            
            if let route = viewModel.route {
                if let coordinate = viewModel.destinationCoordinate {
                    Annotation("Destination",coordinate: coordinate){
                        AnimatedMarker(systemName: "mappin.circle.fill", imageColor: .red, backgroundColor: .clear)
                    }.annotationTitles(.hidden)
                }
                MapPolyline(route.polyline)
                    .stroke(.red, lineWidth: 7)
            }
            if viewModel.lookArounScene != nil{
                if let coordinate = viewModel.viewInRegion?.center {
                    Annotation("Library",coordinate: coordinate){
                        AnimatedMarker(systemName: "binoculars.fill", imageColor: .red, backgroundColor: .clear)
                    }.annotationTitles(.hidden)
                }
            }
        }.mapStyle(viewModel.mapStyle.toMapStyle())
            .onMapCameraChange { ctx in
                viewModel.viewInRegion = ctx.region
            }
            .overlay(alignment: .topTrailing){
                topTrailingOverlayView
            }
            .overlay(alignment: .bottomTrailing){
                bottomTrailingOverlayView
            }
            .overlay(alignment: .bottomLeading){
                if !viewModel.routeDisplaying{
                    bottomLeadingOverlayView
                }
            }
            .safeAreaInset(edge: .bottom){
                if viewModel.routeDisplaying{
                    endRouteButtonView
                }
            }
            .onTapGesture {
                if !viewModel.routeDisplaying{
                    Task {
                        await viewModel.calculateRoute(from: viewModel.location?.coordinate, to: viewModel.viewInRegion?.center)
                    }
                }
            }
    }
}


