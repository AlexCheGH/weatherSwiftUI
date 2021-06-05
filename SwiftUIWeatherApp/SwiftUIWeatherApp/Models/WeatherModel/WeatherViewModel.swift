//
//  WeatherViewModel.swift
//  SwiftUIWeatherApp
//
//  Created by AP Aliaksandr Chekushkin on 2/6/21.
//

import Foundation

class WeatherViewModel: ObservableObject {
    
    @Published private var weatherModel: WeatherModel = WeatherModel(location: UserPreferences().defaultCity())
    
    var location: String
    var coordinates: Coord?
    
    init(location: String = UserPreferences().defaultCity()) {
        self.location = location
    }
    
    var currentWeather: WeatherInfo? { weatherModel.currentWeather }
    var weeklyWeather: [WeatherInfo] { weatherModel.weeklyWeather ?? [] }
    
    func loadData() {
        weatherModel.location = location
        weatherModel.loadData {
            self.objectWillChange.send()
        }
    }
    
    func saveLocation() {
        UserPreferences().saveCity(named: location)
    }
    
    func updateCoordinates(coordinates: Coord) {
        self.coordinates = coordinates
        weatherModel.coordinates = coordinates
    }
}
