//
//  NetworkManager.swift
//  SwiftUIWeatherApp
//
//  Created by AP Aliaksandr Chekushkin on 3/21/21.
//

import Foundation

struct WeatherManager {
    
    func getData(completion: @escaping (Model) -> ()) {
        let city = UserPreferences().defaultCity()
        
        let url = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=d993c7d8d3f4e8de63516cc737a6c16b"
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: URL(string: url)!) {(data, _, err) in
            if err != nil {
                print(err!.localizedDescription)
                
                return
            }
            do {
                let jsonData = try JSONDecoder().decode(CurrentWeather.self, from: data!)
                
                let model = makeModelEntry(data: jsonData)
                
                completion(model)
            }
            catch {
                print(error.localizedDescription)
            }
        }.resume()
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
