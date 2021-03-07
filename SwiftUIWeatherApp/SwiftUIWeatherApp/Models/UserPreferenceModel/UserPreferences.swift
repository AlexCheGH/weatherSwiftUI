//
//  UserPreferences.swift
//  SwiftUIWeatherApp
//
//  Created by AP Aliaksandr Chekushkin on 2/21/21.
//

import Foundation


class UserPreferences {
    
    private let cityKey = UserDefaultsKeysSettings.city.rawValue
    private let tempKey = UserDefaultsKeysSettings.tempSettings.rawValue
    private let windKey = UserDefaultsKeysSettings.windSpeedSettings.rawValue
    private let pressureKey = UserDefaultsKeysSettings.pressure.rawValue
    
    func defaultCity() -> String {
        let defaultCity = UserDefaults.standard.string(forKey: cityKey)
        
        if let city = defaultCity { return city }
        else { return "" }
    }
    
    func saveCity(named city: String) {
        UserDefaults.standard.set(city, forKey: UserDefaultsKeysSettings.city.rawValue)
    }
    
    func savePreference(section: SettingsField.Type, chosenIndex: Int) {
        switch section {
        case is Temperature.Type:
            UserDefaults.standard.set(chosenIndex, forKey: tempKey)
        case is WindSpeed.Type:
            UserDefaults.standard.set(chosenIndex, forKey: windKey)
        case is Pressure.Type:
            UserDefaults.standard.set(chosenIndex, forKey: pressureKey)
        default:
            print("Something went wrong.")
        }
    }
    
    func getTempPreference() -> Int {
        return UserDefaults.standard.integer(forKey: tempKey)
    }
    
    func getWindPreference() -> Int {
        return UserDefaults.standard.integer(forKey: windKey)
    }
    
    func getPressurePreference() -> Int {
        return UserDefaults.standard.integer(forKey: pressureKey)
    }
    
    //MARK:- WeatherTiles
    private let colorSchemeKey = UserDefaultsKeysTiles.tilesColorScheme.rawValue
    private let smoothedKey = UserDefaultsKeysTiles.smoothed.rawValue
    private let snowKey = UserDefaultsKeysTiles.snow.rawValue
    
    func checkTilesSettings () {
        self.checkTilesColorScheme()
        self.checkTilesSmootheness()
        self.checkSnow()
    }
    
    private func checkTilesColorScheme() {
        let colorScheme = UserDefaults.standard.integer(forKey: colorSchemeKey)
        
        if colorScheme == 0 {
            UserDefaults.standard.set(1, forKey: colorSchemeKey)
        }
    }
    
    private func checkTilesSmootheness() {
        let smoothedTiles = UserDefaults.standard.string(forKey: smoothedKey)
        
        if smoothedTiles == nil {
            UserDefaults.standard.set("0", forKey: smoothedKey)
        }
    }
    
    private func checkSnow() {
        let snowTiles = UserDefaults.standard.string(forKey: snowKey)
        
        if snowTiles == nil {
            UserDefaults.standard.set("0", forKey: snowKey)
        }
    }
    
    private func isSnowActive() -> Bool {
        
        if UserDefaults.standard.value(forKey: snowKey) as! String == "1" {
            return true
        } else {
            return false
        }
    }
    
    private func isSmoothActive() -> Bool {
        if UserDefaults.standard.value(forKey: smoothedKey) as! String == "1" {
            return true
        } else {
            return false
        }
    }
    
}

enum UserDefaultsKeysSettings: String {
    case tempSettings = "tempSettings"
    case windSpeedSettings = "windSpeedSettings"
    case pressure = "pressure"
    case city = "city"
}

//for future settings implementation
enum Temperature: Int, SettingsField {
    case celsious
    case farenheit
}

enum WindSpeed: Int, SettingsField {
    case kmh
    case mph
    case ms
    case knots
}

enum Pressure: Int, SettingsField {
    case mm
    case inches
    case kPa
    case mbar
}

protocol SettingsField {
    
}

enum WeatherColorScheme: Int {
    case blackWhite = 1, original, universalBlue, titan, weatherChannel, meteored, nexradLevel3, ranbowSelexIS, darkSky
}

enum WeatherOptions {
    case smoothed
    case snow
}

enum UserDefaultsKeysTiles: String {
    case tilesColorScheme = "tilesColorScheme"
    case smoothed = "smoothed"
    case snow = "snow"
}
