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
