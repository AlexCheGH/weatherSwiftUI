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
    
    @State var selectedLocation = CGPoint(x: 5, y: 5)
    
    var body: some Scene {
        WindowGroup {
//            ContentView()
            MapView().ignoresSafeArea()
        }
    }
    
    
    
    
}
