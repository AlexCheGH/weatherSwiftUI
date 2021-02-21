//
//  UserPreferences.swift
//  SwiftUIWeatherApp
//
//  Created by AP Aliaksandr Chekushkin on 2/21/21.
//

import Foundation


class UserPreferences {
    
    func defaultCity() -> String {
        let cityKey = UserDefaultsKeysSettings.city.rawValue
        let defaultCity = UserDefaults.standard.string(forKey: cityKey)
        
        if let city = defaultCity { return city }
        else { return "" }
    }
    
    func saveCity(named city: String) {
        UserDefaults.standard.set(city, forKey: UserDefaultsKeysSettings.city.rawValue)
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


protocol SettingsPreferences {
    func savePreference(cellTittle: String?, selectedSegment: Int)
}

protocol SettingsField {
    
}
