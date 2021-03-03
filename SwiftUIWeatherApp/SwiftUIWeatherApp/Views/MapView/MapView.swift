//
//  MapView.swift
//  SwiftUIWeatherApp
//
//  Created by AP Aliaksandr Chekushkin on 2/28/21.
//

import SwiftUI

struct MapView: View {
    @Binding var coordinates: CGPoint
    @Binding var isMapTapped: Bool
    
    var body: some View {
        
        ZStack {
            Map(coordinate: $coordinates)
                .ignoresSafeArea()
        }.onChange(of: coordinates, perform: { value in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                isMapTapped = false
            })
        })
    }
}

