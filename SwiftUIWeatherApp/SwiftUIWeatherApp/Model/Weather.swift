//
//  Weather.swift
//  SwiftUIWeatherApp
//
//  Created by AP Aliaksandr Chekushkin on 2/7/21.
//

import Foundation

struct Weather: Identifiable {
    
    var date: String?
    var currentTemp: String?
    var icon: String?
    
    var id: Int
    
    init(date: String? = nil, currentTemp: String? = nil, icon: String? = nil, id: Int) {
        self.date = date
        self.currentTemp = currentTemp
        self.icon = icon
        self.id = id
    }
}

