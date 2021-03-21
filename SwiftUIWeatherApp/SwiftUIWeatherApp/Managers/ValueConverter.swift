//
//  ValueConverter.swift
//  SwiftUIWeatherApp
//
//  Created by AP Aliaksandr Chekushkin on 3/21/21.
//

import Foundation

class ValueConverter {
    
    ///TempSettings: 1 = Farenheit; 2 = Celcious
    func calculateTemperature(rawTemp: Double, tempSettings: Int) -> Double {
        let kelvin = 273.15
        
        switch tempSettings {
        case 0:
            let result = (rawTemp - kelvin) * 9/5 + 32
            return result
        case 1:
            let result = rawTemp - kelvin
            return result
        default:
            return 0.0
        }
    }
}
