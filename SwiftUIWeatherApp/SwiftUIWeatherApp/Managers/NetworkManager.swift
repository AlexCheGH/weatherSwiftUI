//
//  NetworkManager.swift
//  SwiftUIWeatherApp
//
//  Created by AP Aliaksandr Chekushkin on 3/22/21.
//

import Foundation

class NetworkManager {
    
    private let apiKey = "d993c7d8d3f4e8de63516cc737a6c16b"
    
    //MARK:- WeatherCalls
    func requestWeather<T: Codable>(location: String, coordinates: Coord?, weatherType: WeatherForecastType, completion: @escaping(T) -> Void) {
        
        let url = prepareURL(location: location, coordinates: coordinates, weatherType: weatherType)
        
        makeURLSession(with: url) { (data) in
            
            let item = try? JSONDecoder().decode(T.self, from: data)
            
            if let item = item {
                completion(item)
            }
        }.resume()
    }
    
    private func prepareURL(location: String, coordinates: Coord?, weatherType: WeatherForecastType) -> URL {
        var weatherString: String {
            weatherType == .current ? "weather" : "forecast"
        }
        
        let encodedLocation = location.encodeUrl
        
        if let coordinates = coordinates {
            let link = "https://api.openweathermap.org/data/2.5/\(weatherString)?lat=\(coordinates.lat)&lon=\(coordinates.lon)&appid=\(apiKey)"
            return URL(string: link)!
        } else {
            let link = "https://api.openweathermap.org/data/2.5/\(weatherString)?q=\(encodedLocation)&appid=\(apiKey)"
            return URL(string: link)!
        }
    }
    
    enum WeatherForecastType {
        case current
        case weekly
    }
    
    
    
    
    
    private func makeURLSession(with url: URL, completion: @escaping (Data) -> Void) -> URLSessionDataTask {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            DispatchQueue.main.async {
                if let data = data {
                    completion(data)
                }
            }
        }
    }
    
    
    //MARK:- TilesCall
    func getTileTimestams(completion: ([Int]) -> Void) {
        let decoder = JSONDecoder()
        
        let stringURL = "https://api.rainviewer.com/public/maps.json"
        let url = URL(string: stringURL)
        
        guard let data = try? Data(contentsOf: url!) else { return }
        guard let tempValue = try? decoder.decode([Int].self, from: data) else { return }
        
        completion(tempValue)
    }
    
    
    func getWidgetData(completion: @escaping (CurrentWeather) -> ()) {
        
        let city = UserPreferences().defaultCity()
        
        let url = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)"
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: URL(string: url)!) {(data, _, err) in
            if err != nil {
                print(err!.localizedDescription)
                
                return
            }
            do {
                let jsonData = try JSONDecoder().decode(CurrentWeather.self, from: data!)
                
                completion(jsonData)
            }
            catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
}
