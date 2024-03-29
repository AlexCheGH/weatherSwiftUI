//
//  ContentView.swift
//  SwiftUIWeatherApp
//
//  Created by AP Aliaksandr Chekushkin on 1/3/21.
//

import SwiftUI
import PartialSheet
import WatchConnectivity

struct ContentView: View {
    
    @ObservedObject var forecast = WeatherViewModel()
    @State var isSettingsTapped = false
    @State var isMapTapped = false
    @State var selectedLocation = CGPoint()
    
    private let watchConnectivity = WatchConnectivity()
    
    private let locationPlaceholderString = NSLocalizedString("location_placeholder", comment: "")
    private let todayString = NSLocalizedString("today_weekdat", comment: "")
    private let gearIcon = "gear"
    private let globeIcon = "globe"
    private let buttonsSize: CGFloat = 30
    private let textFieldTextSize: CGFloat = 35
    private let weeklyWeatherSize: CGSize = CGSize(width: 50, height: 50)
    
    init() {
        UINavigationBar.appearance().isUserInteractionEnabled = false
        UINavigationBar.appearance().backgroundColor = .clear
        UINavigationBar.appearance().tintColor = .black
    }
    
    var body: some View {
        makeBody()
    }
    
    private func makeBody() -> some View {
        ZStack()  {
            gradient()
            VStack(alignment: .center) {
                GeometryReader { geo in
                    VStack {
                        HStack {
                            mapButton()
                            textField()
                            settingsButton()
                        }
                        currentWeatherCard(size: sizeCard(geo.size))
                            .padding()
                    }
                }
                HStack(alignment: .center) {
                    weeklyWeatherCards()
                }
                .padding()
            }
            .onAppear{ forecast.loadData() }
        }
        .navigate(to: MapView(coordinates: $selectedLocation, isMapTapped: $isMapTapped),
                  when: $isMapTapped)
        .onChange(of: selectedLocation, perform: { value in
            let lat = Double(selectedLocation.x)
            let long = Double(selectedLocation.y)
            forecast.updateCoordinates(coordinates: Coord(lon: long, lat: lat))
            forecast.loadData()
        })
        .addPartialSheet()
    }
    
    //MARK:- UI Elements
    private func gradient() -> some View {
        LinearGradient(gradient: Gradient(colors: [.blue, .green]),
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all)
    }
    
    private func textField() -> some View {
        TextField(locationPlaceholderString, text: $forecast.location, onCommit:  {
            forecast.loadData()
            forecast.saveLocation()
            try? self.watchConnectivity.session.updateApplicationContext([WatchKeyPath.city.rawValue : forecast.location])
        })
        .font(.system(size: textFieldTextSize,
                      weight: .medium,
                      design: .default))
        .foregroundColor(.black)
        .multilineTextAlignment(.center)
    }
    
    private func mapButton() -> some View {
        Button(action: {
            isMapTapped = true
        })
        {
            makeImage(named: globeIcon, padding: .leading)
        }
    }
    
    private func settingsButton() -> some View {
        Button(action: {
            isSettingsTapped.toggle()
        }) {
            makeImage(named: gearIcon, padding: .trailing)
        }
        .sheet(isPresented: $isSettingsTapped) {
            SettingsView().onDisappear{ forecast.loadData() }
        }
    }
    
    private func makeImage(named name: String, padding: Edge.Set) -> some View {
        Image(systemName: name)
            .foregroundColor(.black)
            .font(.system(size: buttonsSize))
            .padding(padding)
    }
    
    private func currentWeatherCard(size: CGSize) -> some View {
        WeeklyWeatherView(weekday: todayString,
                          temperature: forecast.currentWeather?.currentTemp,
                          imageName: forecast.currentWeather?.icon,
                          size: size,
                          viewType: .currentWeather)
    }
    
    private func weeklyWeatherCards() -> some View {
        ForEach(forecast.weeklyWeather) { item in
            WeeklyWeatherView(weekday: item.date,
                              temperature: item.currentTemp,
                              imageName: item.icon,
                              size: weeklyWeatherSize,
                              viewType: .weeklyWeather)
        }
    }
    
    //MARK:- Dynamic size functions
    private func sizeCard(_ size: CGSize) -> CGSize {
        let multiplier: CGFloat = 0.4
        
        if size.width > size.height {
            return CGSize(width: size.height * multiplier, height: size.height * multiplier)
        } else {
            return CGSize(width: size.width * multiplier, height: size.width * multiplier)
        }
    }
}
