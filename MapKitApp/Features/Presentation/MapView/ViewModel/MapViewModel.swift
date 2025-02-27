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
}
