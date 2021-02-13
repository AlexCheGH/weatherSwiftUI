//
//  WeeklyWeather.swift
//  SwiftUIWeatherApp
//
//  Created by AP Aliaksandr Chekushkin on 2/13/21.
//

import Foundation

//MARK:- RAW Weather Data
struct WeeklyWeatherData: Codable {
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
