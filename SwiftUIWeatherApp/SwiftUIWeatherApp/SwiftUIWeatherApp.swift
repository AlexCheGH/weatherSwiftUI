//
//  SwiftUIWeatherAppApp.swift
//  SwiftUIWeatherApp
//
//  Created by AP Aliaksandr Chekushkin on 1/3/21.
//

import SwiftUI
import PartialSheet
import Firebase

@main
struct SwiftUIWeatherApp: App {
   private let sheetManager: PartialSheetManager = PartialSheetManager()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(sheetManager)
        }
    }
}
