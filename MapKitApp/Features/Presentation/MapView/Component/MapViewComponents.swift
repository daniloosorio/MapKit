//
//  MapViewComponents.swift
//  MapKitApp
//
//  Created by Danilo Osorio on 25/02/25.
//

import SwiftUI
import MapKit

extension MapView {
    var topTrailingOverlayView: some View {
        VStack{
            IconView(systemName: "map.fill")
                .onTapGesture {
                    self.viewModel.mapStyle = viewModel.mapStyle.toggle()
                }
            
            Spacer(minLength: 2)
            
            if viewModel.isLoading {
                ProgressView()
                    .font(.title3)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 44, height: 46)
                            .foregroundColor(.init(.systemBackground))
                    )
                    .padding()
            }else{
                IconView(systemName:"location.fill")
                    .onTapGesture {
                        withAnimation{
                            viewModel.cameraPosition = .region(viewModel.region)
                        }
                    }
            }
        }.frame(width: 50, height: 75)
            .padding(.init(top: 30, leading: 0, bottom: 0, trailing: 15))
    }
}

extension MapView {
    var bottomTrailingOverlayView: some View {
        HStack{
            IconView(systemName: "sun.min.fill", imageColor: .yellow)
                .offset(x:-10)
            Text("14°")
                .foregroundColor(.init(.gray))
                .font(.title3)
                .offset(x:-13)
        }.background(
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 62,height: 46)
                .foregroundColor(.init(.systemBackground))
        ).offset(y:-100)
            .padding(.init(top: 0, leading: 0, bottom: 0, trailing: 15))
        
    }
}

extension MapView {
    var bottomLeadingOverlayView: some View {
        IconView(systemName: "binoculars.fill")
            .frame(width: 62,height: 46)
            .offset(y:-100)
            .onTapGesture {
                Task {
                    guard let coordinate = viewModel.viewInRegion?.center else {
                        showErrorAlert = true
                        return
                    }
                    await viewModel.fetchLookAroungPreview(coordinate: coordinate)
                    viewModel.isLoading = false
                }
            }
    }
}

extension MapView {
    var endRouteButtonView: some View {
        Button("End Route") {
            withAnimation(.snappy){
                viewModel.resetRoute()
                if let coordinate = viewModel.mapSelection?.placemark.coordinate {
                    viewModel.cameraPosition = .region(.init(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000))
                }
            }
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .padding(.vertical,12)
        .background(.red.gradient, in: .rect(cornerRadius: 15))
        .padding()
        .background(.ultraThinMaterial)
    }
}

extension MapView {
    var lookAroundPreview: some View {
        VStack {
            LookAroundPreview(scene: $viewModel.lookArounScene)
                .frame(height: lookAroundViewIsExpanded ? UIScreen.main.bounds.height - 32: 300)
                .animation(.easeInOut, value: viewModel.lookArounScene)
                .overlay(alignment: .topTrailing, content: {
                    VStack {
                        IconView (systemName: "xmark.circle.fill")
                            .frame(width: 62,height: 46)
                            .onTapGesture {
                                Task {
                                    viewModel.lookArounScene = nil
                                    lookAroundViewIsExpanded = false
                                }
                            }
                        IconView(systemName: lookAroundViewIsExpanded ? "arrow.down.right.and.arrow.up.left" : "arrow.up.backward.and.arrow.down.forward")
                            .frame(width: 62,height: 46)
                            .onTapGesture {
                                Task {
                                    lookAroundViewIsExpanded.toggle()
                                }
                            }
                    }.padding(.vertical)
                }).padding(.horizontal,4)
            Spacer()
        }
    }
}
