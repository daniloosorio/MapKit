//
//  MapViewModel.swift
//  MapKitApp
//
//  Created by Danilo Osorio on 25/02/25.
//

import Foundation
import Observation
import MapKit
import SwiftUI

enum MyMapStyle: Int {
    case standard = 0
    case imagery
    case hybrid
    
    func toMapStyle() -> MapStyle {
        switch self {
        case .standard:
            return .standard
        case .imagery:
            return .imagery
        case .hybrid:
            return .hybrid
        }
    }
    
    func toggle() -> MyMapStyle {
        switch self {
        case .standard:
            return .imagery
        case .imagery:
            return .hybrid
        case .hybrid:
            return .standard
        }
    }
    
}

@Observable
class MapViewModel {
    
    var cameraPosition: MapCameraPosition
    var location: CLLocation?
    var region: MKCoordinateRegion
    var mapSelection: MKMapItem?
    
    var mapStyle : MyMapStyle = .standard
    
    var isLoading: Bool = false
    var viewInRegion: MKCoordinateRegion?
    var routeDisplaying: Bool = false
    var lookArounScene: MKLookAroundScene?
    var route: MKRoute?
    var destinationCoordinate: CLLocationCoordinate2D?
    
    init(location: CLLocation?,
         region:MKCoordinateRegion){
        self.cameraPosition = .region(region)
        self.location = location
        self.region = region
    }
    
}

extension MapViewModel{
    func fetchLookAroungPreview(coordinate: CLLocationCoordinate2D) async {
        isLoading = true
        lookArounScene = nil
        let request = MKLookAroundSceneRequest(coordinate: coordinate)
        lookArounScene = try? await request.scene
    }
    
    func calculateRoute(from source:CLLocationCoordinate2D?,
                        to destination: CLLocationCoordinate2D?)async {
        guard let source,
              let destination else {return }
        isLoading = true
        let request = MKDirections.Request()
        request.source = .init(placemark: .init(coordinate: source))
        request.destination = .init(placemark: .init(coordinate: destination))
        request.transportType = .automobile
        
        let result = try? await MKDirections(request: request).calculate()
        route = result?.routes.first
        mapSelection = request.destination
        destinationCoordinate = destination
        
        withAnimation(.snappy){
            routeDisplaying = true
            isLoading = false
        }
    }
    
    func resetRoute(){
        routeDisplaying = false
        route = nil
        destinationCoordinate = nil
    }
}
