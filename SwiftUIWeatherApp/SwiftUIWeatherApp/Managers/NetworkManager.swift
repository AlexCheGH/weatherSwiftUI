//
//  NetworkManager.swift
//  SwiftUIWeatherApp
//
//  Created by AP Aliaksandr Chekushkin on 3/22/21.
//

import Foundation

class NetworkManager {
    
    //find your key at api.openweathermap.org
    private static var apiKey: String {
      get {
        // 1
        guard let filePath = Bundle.main.path(forResource: "ApiKeys", ofType: "plist") else {
          fatalError("Couldn't find file 'ApiKeys.plist'.")
        }
        // 2
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "weatherKey") as? String else {
          fatalError("Couldn't find key 'weatherKey' in 'ApiKeys.plist'.")
        }
        return value
      }
    }
    
    
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
            let link = "https://api.openweathermap.org/data/2.5/\(weatherString)?lat=\(coordinates.lat)&lon=\(coordinates.lon)&appid=\(NetworkManager.apiKey)"
            return URL(string: link)!
        } else {
            let link = "https://api.openweathermap.org/data/2.5/\(weatherString)?q=\(encodedLocation)&appid=\(NetworkManager.apiKey)"
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
        
        let url = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(NetworkManager.apiKey)"
        
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
