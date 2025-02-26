//
//  IconView.swift
//  MapKitApp
//
//  Created by Danilo Osorio on 25/02/25.
//

import SwiftUI

struct IconView: View {
    @Environment(\.colorScheme) var colorScheme
    var systemName: String
    var imageColor: Color?
    var rectangleColor: Color?
    var cornerRadius: CGFloat?
    
    init (systemName: String,
    imageColor: Color? = nil,
          rectangleColor: Color? = nil,
          cornerRadius: CGFloat? = nil) {
        self.systemName = systemName
        self.imageColor = imageColor
        self.rectangleColor = rectangleColor
        self.cornerRadius = cornerRadius
    }
    
    var body: some View {
        Image(systemName: systemName)
            .foregroundColor(imageColor ?? .init(colorScheme == .dark ? .white : .black))
            .font(.title3)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius ?? 10)
                    .frame(width: 44, height: 46)
                    .foregroundColor(rectangleColor ?? .init(.systemBackground))
            )
    }
}
 
