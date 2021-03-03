//
//  WeatherViewModel.swift
//  SwiftUIWeatherApp
//
//  Created by AP Aliaksandr Chekushkin on 2/6/21.
//

import Foundation

class WeatherViewModel: ObservableObject {
    @Published private var weatherModel: WeatherModel
    
    @Published var weather: WeeklyWeatherData? = nil
    
    var location: String
    
    var coordinates: Coord?
    
    init(location: String) {
        self.location = UserPreferences().defaultCity()
        self.weatherModel = WeatherModel(location: self.location)
    }
    
    var currentWeather: WeatherInfo? {
        weatherModel.currentWeather
    }
    
    var weeklyWeather: [WeatherInfo] {
        
        var container = [WeatherInfo]()
        weatherModel.weeklyWeather.forEach {
            if let item = $0 {
                container.append(item)
            }
        }
        return container
    }
    
    func loadData() {
        weatherModel.location = location
        weatherModel.loadData { [self] in
            weather = weatherModel.rawWeather
            location = weather?.city.name ?? "..."
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
