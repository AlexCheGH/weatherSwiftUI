//
//  SwiftUIWeatherAppApp.swift
//  SwiftUIWeatherApp
//
//  Created by AP Aliaksandr Chekushkin on 1/3/21.
//

import SwiftUI
import MapKit

@main
struct SwiftUIWeatherAppApp: App {
    
    @State var coordinate: CGPoint = CGPoint()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
//            MapView(coordinates: $coordinate)
//                .onChange(of: coordinate) { _ in
//                }
        }
    }
    
    
    
    
}
