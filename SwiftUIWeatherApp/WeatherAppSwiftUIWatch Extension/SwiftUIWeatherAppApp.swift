//
//  SwiftUIWeatherAppApp.swift
//  WeatherAppSwiftUIWatch Extension
//
//  Created by AP Aliaksandr Chekushkin on 3/24/21.
//

import SwiftUI

@main
struct SwiftUIWeatherAppApp: App {    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            TabView {
                WeatherView()
                SettingsView()
            }
        }
        
        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
