//
//  WeatherModel.swift
//  SwiftUIWeatherApp
//
//  Created by AP Aliaksandr Chekushkin on 2/6/21.
//

import Foundation

class WeatherModel {
    
    var location: String = "Minsk"
    
    var weeklyWeather: [Weather?] = [Weather?]()
    
    var rawWeather: WeatherData? = nil
    
    func weeklyWeatherCall(completion: @escaping(Data) -> Void) {
        let apiKey = "d993c7d8d3f4e8de63516cc737a6c16b"
        let string = "https://api.openweathermap.org/data/2.5/forecast?q=\(location)&appid=\(apiKey)"
        let stringURL = URL(string: string.encodeUrl)
        
        URLSession.shared.dataTask(with: stringURL!) { data, _, _ in
            DispatchQueue.main.async {
                if let data = data {
                    completion(data)
                }
            }
        }.resume()
    }
    
    func loadData(completion: @escaping() -> Void) {
        weeklyWeatherCall { (data) in
            self.rawWeather = try? JSONDecoder().decode(WeatherData.self, from: data)
            self.prepareWeeklyWeather()
            completion()
        }
    }
    
    init() {
        self.loadData {  }
    }
    
    
    
    func prepareWeeklyWeather() {
        
        weeklyWeather.removeAll()
        
        let date = Date()
        let currentDate = Int(date.timeIntervalSince1970)
        let stringDate = DateManager.makeFormatedString(date: currentDate, format: "E")
        
        var midTemp: Double = 0
        
        var container = [WeatherData.List]()
        var numberOfElements = 0
        
        rawWeather?.list.filter {
            let comparableString = DateManager.makeFormatedString(date: $0.dt, format: "E")
            
            if stringDate != comparableString { return true } else { return false }
        }.forEach {
            container.append($0)
            numberOfElements += 1
            
            if container.count == 8 {
                let midDayIndex = 8 / 2 - 1
                midTemp = container[midDayIndex].main.temp
                midTemp = calculateTemperature(rawTemp: midTemp, tempSettings: 2)
                
                let date = DateManager.makeFormatedString(date: container[midDayIndex].dt, format: "E")
                let icon = $0.weather.first?.icon
                
                let weather = Weather(date: date, currentTemp: String(format: "%.0f", midTemp), icon: icon, id: numberOfElements)
                weeklyWeather.append(weather)
                
                container.removeAll()
            }
        }
        container.removeAll()
        
        if let elements = rawWeather?.list.count {
            if numberOfElements != elements {
                for index in numberOfElements..<elements {
                    container.append((rawWeather?.list[index])!)
                    
                }
                let midDayIndex = container.count > 1 ? container.count / 2 - 1 : 0
                
                midTemp = container[midDayIndex].main.temp
                midTemp = calculateTemperature(rawTemp: midTemp, tempSettings: 2)
                
                let date = DateManager.makeFormatedString(date: container[midDayIndex].dt, format: "E")
                let icon = container[midDayIndex].weather.first?.icon
                
                let weather = Weather(date: date, currentTemp: String(format: "%.0f", midTemp), icon: icon, id: numberOfElements)
                weeklyWeather.append(weather)
            }
        }
    }
    
    //temp setting  - future userpreferences choise
    func calculateTemperature(rawTemp: Double, tempSettings: Int) -> Double {
        let kelvin = 273.15
        
        switch tempSettings {
        case 1:
            let result = (rawTemp - kelvin) * 9/5 + 32
            return result
        case 2:
            let result = rawTemp - kelvin
            return result
        default:
            return 0.0
        }
    }
    
    
    //MARK:- RAW Weather Data
    struct WeatherData: Codable {
        // let cod: String
        // let message, cnt: Int
        let list: [List]
        let city: City
        
        
        struct City: Codable {
            let id: Int
            let name: String
            let coord: Coord
            let country: String
            let population, timezone, sunrise, sunset: Int
        }
        
        struct Coord: Codable {
            let lat, lon: Double
        }
        
        struct List: Codable {
            let dt: Int
            let main: MainClass
            let weather: [Weather]
            // let clouds: Clouds
            // let wind: Wind
            // let visibility: Int
            // let pop: Double
            //  let sys: Sys
            //  let dtTxt: String
            //  let rain: Rain?
            
            //    enum CodingKeys: String, CodingKey {
            //      case dt, main, weather, clouds, wind, visibility, pop,  sys
            //      case dtTxt = "dt_txt"
            //      case rain
            //    }
        }
        
        struct Clouds: Codable {
            let all: Int
        }
        
        struct MainClass: Codable {
            let temp /*, feelsLike*/, tempMin, tempMax: Double
            // let pressure, seaLevel, grndLevel, humidity: Int
            // let tempKf: Double
            
            enum CodingKeys: String, CodingKey {
                case temp
                //  case feelsLike = "feels_like"
                case tempMin = "temp_min"
                case tempMax = "temp_max"
                //  case pressure
                //  case seaLevel = "sea_level"
                //  case grndLevel = "grnd_level"
                //  case humidity
                //  case tempKf = "temp_kf"
            }
        }
        
        struct Rain: Codable {
            let the3H: Double
            
            enum CodingKeys: String, CodingKey {
                case the3H = "3h"
            }
        }
        
        struct Sys: Codable {
            let pod: Pod
        }
        
        enum Pod: String, Codable {
            case d = "d"
            case n = "n"
        }
        
        struct Weather: Codable {
            // let id: Int
            // let main: MainEnum
            // let weatherDescription: Description
            let icon: String
            
            // enum CodingKeys: String, CodingKey {
            //  case id, main
            //  case weatherDescription = "description"
            //  case icon
            //  }
        }
        
        enum MainEnum: String, Codable {
            case clear = "Clear"
            case clouds = "Clouds"
            case rain = "Rain"
        }
        
        enum Description: String, Codable {
            case brokenClouds = "broken clouds"
            case clearSky = "clear sky"
            case fewClouds = "few clouds"
            case lightRain = "light rain"
            case overcastClouds = "overcast clouds"
            case scatteredClouds = "scattered clouds"
        }
        
        struct Wind: Codable {
            let speed: Double
            let deg: Int
        }
    }
}
