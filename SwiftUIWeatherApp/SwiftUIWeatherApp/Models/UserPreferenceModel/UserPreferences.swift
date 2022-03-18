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
    
    
    private let userDefault = UserDefaults(suiteName: "group.com.weather.app.swiftui")!
    
    func defaultCity() -> String {
        let defaultCity = userDefault.string(forKey: cityKey)
        
        if let city = defaultCity { return city }
        else { return "" }
    }
    
    func saveCity(named city: String) {
        userDefault.set(city, forKey: UserDefaultsKeysSettings.city.rawValue)
    }
    
    func savePreference(section: SettingsField.Type, chosenIndex: Int) {
        switch section {
        case is Temperature.Type:
            userDefault.set(chosenIndex, forKey: tempKey)
        case is WindSpeed.Type:
            userDefault.set(chosenIndex, forKey: windKey)
        case is Pressure.Type:
            userDefault.set(chosenIndex, forKey: pressureKey)
        default:
            print("Something went wrong.")
        }
    }
    
    func getTempPreference() -> Int {
        return userDefault.integer(forKey: tempKey)
    }
    
    func getWindPreference() -> Int {
        return userDefault.integer(forKey: windKey)
    }
    
    func getPressurePreference() -> Int {
        return userDefault.integer(forKey: pressureKey)
    }
    
    //MARK:- WeatherTiles
    
   private let blackWhite = NSLocalizedString("black_white", comment: "")
   private let original = NSLocalizedString("original", comment: "")
   private let universalBlue = NSLocalizedString("universal_blue", comment: "")
   private let titan = NSLocalizedString("titan", comment: "")
   private let weather_channel = NSLocalizedString("the_weather_channel", comment: "")
   private let meteored = NSLocalizedString("meteored", comment: "")
   private let nexradLevel3 = NSLocalizedString("nexrad_level_3", comment: "")
   private let rainbowSelex = NSLocalizedString("rainbow_selex_is", comment: "")
   private let darkSky = NSLocalizedString("dark_sky", comment: "")
    
    var checklistItems: [ChecklistItem] {
        let colorSchemes = [blackWhite, original, universalBlue, titan, weather_channel, meteored, nexradLevel3, rainbowSelex, darkSky]
        
        var container = [ChecklistItem]()
        
        colorSchemes.forEach {
            let item = ChecklistItem(name: $0, isChecked: false)
            container.append(item)
        }
        
        let colorSchemeIndex = UserDefaults.standard.integer(forKey: colorSchemeKey)
        container[colorSchemeIndex].isChecked = true
        
        return container
    }
    
    func changeColorScheme(schemeNumber: Int) {
        //data comes from List, prevents crash if a user chosen the last option
        let value = schemeNumber > 0 ? schemeNumber - 1 : 0
        userDefault.set(value, forKey: colorSchemeKey)
    }
    
    private let colorSchemeKey = UserDefaultsKeysTiles.tilesColorScheme.rawValue
    private let smoothedKey = UserDefaultsKeysTiles.smoothed.rawValue
    private let snowKey = UserDefaultsKeysTiles.snow.rawValue
    
    func checkTilesSettings() {
        self.checkTilesColorScheme()
        self.checkTilesSmootheness()
        self.checkSnow()
    }
    
    /*****************************************************************/
    //Use only after running "CheckTilesSettings()"
    func getColorSchemePreference() -> Int {
        userDefault.integer(forKey: colorSchemeKey)
    }
    
    func getSnowPreference() -> String {
        userDefault.string(forKey: snowKey)!
    }
    
    func getSmoothPreference() -> String {
        userDefault.string(forKey: smoothedKey)!
    }
   /*****************************************************************/
    
    
    private func checkTilesColorScheme() {
        let colorScheme = userDefault.integer(forKey: colorSchemeKey)
        
        if colorScheme == 0 {
            userDefault.set(1, forKey: colorSchemeKey)
        }
    }
    
    private func checkTilesSmootheness() {
        let smoothedTiles = userDefault.string(forKey: smoothedKey)
        
        if smoothedTiles == nil {
            userDefault.set("0", forKey: smoothedKey)
        }
    }
    
    private func checkSnow() {
        let snowTiles = userDefault.string(forKey: snowKey)
        
        if snowTiles == nil {
            userDefault.set("0", forKey: snowKey)
        }
    }
    
    func changeSnow(isActive: Bool) {
        let value = isActive ? "1" : "0"
        userDefault.set(value, forKey: snowKey)
    }
    
    func isSnowActive() -> Bool {
        if userDefault.value(forKey: snowKey) as! String == "1" {
            return true
        } else {
            return false
        }
    }
    
    func isSmoothActive() -> Bool {
        if userDefault.value(forKey: smoothedKey) as! String == "1" {
            return true
        } else {
            return false
        }
    }
    
    func changeSmooth(isActive: Bool) {
        let value = isActive ? "1" : "0"
        userDefault.set(value, forKey: smoothedKey)
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
