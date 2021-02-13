//
//  WeatherViewModel.swift
//  SwiftUIWeatherApp
//
//  Created by AP Aliaksandr Chekushkin on 2/6/21.
//

import Foundation

class WeatherViewModel: ObservableObject {
    @Published private var weatherModel = WeatherModel()
    
    @Published var weather: WeatherModel.WeatherData? = nil
    
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
    
    
    class DateManager {
        static func makeFormatedString(date: Int?, format: String = "HH:mm") -> String {
            let date = Date(timeIntervalSince1970: Double(date ?? 0))
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = format
            
            return dateFormat.string(from: date)
        }
    }
