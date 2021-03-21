//
//  WeatherModel.swift
//  SwiftUIWeatherApp
//
//  Created by AP Aliaksandr Chekushkin on 2/6/21.
//

import Foundation

class WeatherModel {
    
    var location: String
    var weeklyWeather: [WeatherInfo?] = [WeatherInfo?]()
    var rawWeather: WeeklyWeatherData? = nil
    var currentWeather: WeatherInfo? = nil
    
    var coordinates: Coord?
    
    private let apiKey = "d993c7d8d3f4e8de63516cc737a6c16b"  //need to setup config-file
    
    init(location: String) {
        self.location = location
        self.loadData { }
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
    
    //MARK:- Current weather Data calls
    private func makeCurrentForecastTask(completion: @escaping (Data) -> Void) {
        
        let url = prepareURL(location: location, coordinates: coordinates, weatherType: .current)
        
        makeURLSession(with: url) { (data) in
            completion(data)
        }.resume()
    }
    
    func loadData(completion: @escaping() -> Void) {
        makeCurrentForecastTask { [self] (data) in
            let weather = try? JSONDecoder().decode(CurrentWeather.self, from: data)
            prepareCurrentWeather(data: weather)
        }
        
        weeklyWeatherCall { [self] (data) in
            rawWeather = try? JSONDecoder().decode(WeeklyWeatherData.self, from: data)
            prepareWeeklyWeather()
            completion()
        }
    }
    
    
    private func prepareCurrentWeather(data: CurrentWeather?) {
        if let weather = data {
            var currentTemp = weather.main.temp
            let tempSetting = UserPreferences().getTempPreference()
            
            currentTemp = ValueConverter().calculateTemperature(rawTemp: currentTemp, tempSettings: tempSetting)
            
            let date = DateManager.makeFormatedString(date: weather.dt, format: "E")
            let icon = weather.weather.first?.icon
            
            currentWeather = WeatherInfo(date: date, currentTemp: String(format: "%.0f", currentTemp), icon: icon, id: 99)
        }
    }
    
    
    //MARK:- Weekly Weather
    
    private func weeklyWeatherCall(completion: @escaping(Data) -> Void) {
        let url = prepareURL(location: location, coordinates: coordinates, weatherType: .weekly)
        
        makeURLSession(with: url) { (data) in
            completion(data)
        }.resume()
    }
    
    //need to run tests. problems with getting mid of the day probly
    private func prepareWeeklyWeather() {
        
        weeklyWeather.removeAll()
        
        let date = Date()
        let currentDate = Int(date.timeIntervalSince1970)
        let stringDate = DateManager.makeFormatedString(date: currentDate, format: "E")
        let tempSetting = UserPreferences().getTempPreference()
        
        var midTemp: Double = 0
        
        var container = [WeeklyWeatherData.List]()
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
                midTemp = ValueConverter().calculateTemperature(rawTemp: midTemp, tempSettings: tempSetting)
                
                let date = DateManager.makeFormatedString(date: container[midDayIndex].dt, format: "E")
                let icon = $0.weather.first?.icon
                
                let weather = WeatherInfo(date: date, currentTemp: String(format: "%.0f", midTemp), icon: icon, id: numberOfElements)
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
                midTemp = ValueConverter().calculateTemperature(rawTemp: midTemp, tempSettings: tempSetting)
                
                let date = DateManager.makeFormatedString(date: container[midDayIndex].dt, format: "E")
                let icon = container[midDayIndex].weather.first?.icon
                
                let weather = WeatherInfo(date: date, currentTemp: String(format: "%.0f", midTemp), icon: icon, id: numberOfElements)
                weeklyWeather.append(weather)
            }
        }
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
    
}
