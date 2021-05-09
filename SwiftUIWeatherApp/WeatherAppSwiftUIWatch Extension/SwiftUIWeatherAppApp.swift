//
//  SwiftUIWeatherAppApp.swift
//  WeatherAppSwiftUIWatch Extension
//
//  Created by AP Aliaksandr Chekushkin on 3/24/21.
//

import SwiftUI

@main
struct SwiftUIWeatherAppApp: App {
    @Environment(\.scenePhase) var scenePhase
    
    @ObservedObject var viewModel = WeatherViewModel()
    
    @State private var initialDate = Date()
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            TabView {
                makeWeatherView()
                LocationSelectionView()
                SettingsView()
            }
        }
        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
    
    private func makeWeatherView() -> some View {
        WeatherView(viewModel: viewModel)
            .onChange(of: scenePhase) { (phase) in
                processScenePhase(for: phase)
            }
            .onAppear { viewModel.loadData() }
    }
    
    private func processScenePhase(for phase: ScenePhase) {
        switch phase {
        case .active:
            loadData()
            print("The app went in active phase")
        case .background:
            print("The app went in background phase")
        case .inactive:
            print("The app went in inactive phase")
        @unknown default:
            print("Unknown app state")
        }
    }
    
    private func loadData() {
        let currentDate = Date()
        let oneHour = 60.0 * 60.0
        //loads data once per hour
        if initialDate.addingTimeInterval(oneHour) < currentDate {
            viewModel.loadData()
            initialDate.addTimeInterval(oneHour)
        }
    }
}
