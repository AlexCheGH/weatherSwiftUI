//
//  NetworkManager.swift
//  SwiftUIWeatherApp
//
//  Created by AP Aliaksandr Chekushkin on 3/21/21.
//

import Foundation

struct WeatherManager {
    private let networkManager = NetworkManager()
    
    func getData(completion: @escaping (Model) -> ()) {
        networkManager.getWidgetData { (data) in
            let model = makeModelEntry(data: data)
            completion(model)
        }
    }
    
    private func makeModelEntry(data: CurrentWeather) -> Model {
        let preference = UserPreferences().getTempPreference()
        let rawTemperature = ValueConverter().calculateTemperature(rawTemp: data.main.temp, tempSettings: preference)
        let icon = data.weather.first?.icon ?? ""
        let stringTemp = String(format: "%.0f", rawTemperature)
        let city = data.name
        let description = data.weather.first?.weatherDescription.firstUppercased
        
        return Model(date: Date(), currentWeather: stringTemp, icon: icon, city: city, decription: description)
    }
}
