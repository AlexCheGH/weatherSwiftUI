//
//  WeatherViewModel.swift
//  SwiftUIWeatherApp
//
//  Created by AP Aliaksandr Chekushkin on 2/6/21.
//

import Foundation

class WeatherViewModel: ObservableObject {
    @Published private var weatherModel = WeatherModel()
    
    @Published var weather: WeeklyWeatherData? = nil
    
    var location: String {
        weatherModel.location
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
    
    init() {
        weatherModel.loadData { [self] in
            weather = weatherModel.rawWeather
        }
    }
}
