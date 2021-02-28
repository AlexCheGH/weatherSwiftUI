//
//  MapView.swift
//  SwiftUIWeatherApp
//
//  Created by AP Aliaksandr Chekushkin on 2/28/21.
//

import SwiftUI

struct MapView: View {
    @Binding var coordinates: CGPoint
    
    var body: some View {
        
        ZStack {
            Map(coordinate: $coordinates)
                .ignoresSafeArea()
        }
        
        
        
    }
}
