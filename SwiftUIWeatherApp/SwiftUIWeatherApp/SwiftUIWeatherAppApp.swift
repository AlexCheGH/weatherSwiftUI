//
//  SwiftUIWeatherAppApp.swift
//  SwiftUIWeatherApp
//
//  Created by AP Aliaksandr Chekushkin on 1/3/21.
//

import SwiftUI
import PartialSheet

@main
struct SwiftUIWeatherAppApp: App {
   private let sheetManager: PartialSheetManager = PartialSheetManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(sheetManager)
        }
    }
}
