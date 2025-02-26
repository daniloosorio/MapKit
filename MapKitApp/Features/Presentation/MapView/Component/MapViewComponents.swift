//
//  MapViewComponents.swift
//  MapKitApp
//
//  Created by Danilo Osorio on 25/02/25.
//

import SwiftUI

extension MapView {
    var topTrailingOverlayView: some View {
        VStack(spacing: -5){
            IconView(systemName: "map.fill")
                .onTapGesture {
                    self.viewModel.mapStyle = viewModel.mapStyle.toggle()
                }
        }.padding(.init(top: 30, leading: 0, bottom: 0, trailing: 30))
    }
}
