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
    
    let networkManager = NetworkManager()
    
    init(location: String) {
        self.location = location
        self.loadData { }
    }
    
    func loadData(completion: @escaping() -> Void) {
        prepareCurrentWeather()
        prepareWeeklyWeather { completion() } //completion makes sure location loaded correctly
    }
    
    //MARK:- Current weather Data calls
    private func prepareCurrentWeather() {
        networkManager.requestWeather(location: location, coordinates: coordinates, weatherType: .current) { (currentWeather: CurrentWeather) in
            var currentTemp = currentWeather.main.temp
            let tempSetting = UserPreferences().getTempPreference()
            
            currentTemp = ValueConverter().calculateTemperature(rawTemp: currentTemp, tempSettings: tempSetting)
            
            let date = DateManager.makeFormatedString(date: currentWeather.dt, format: "E")
            let icon = currentWeather.weather.first?.icon
            
            self.currentWeather = WeatherInfo(date: date, currentTemp: String(format: "%.0f", currentTemp), icon: icon, id: 99)
        }
    }
    
    
    //MARK:- Weekly Weather
    //need to run tests. problems with getting mid of the day probly
    private func prepareWeeklyWeather(completion: @escaping() -> Void) {
        networkManager.requestWeather(location: location, coordinates: coordinates, weatherType: .weekly) { (weeklyWeather: WeeklyWeatherData) in
            self.rawWeather = weeklyWeather
            self.processWeeklyWeather()
            completion()
        }
    }
    
    private func processWeeklyWeather() {
        
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
}
