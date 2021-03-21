//
//  Model.swift
//  WeatherWidgetExtension
//
//  Created by AP Aliaksandr Chekushkin on 3/21/21.
//

import WidgetKit

struct Model: TimelineEntry {
    var date: Date
    var currentWeather: String
    var icon: String
    var city: String
}

struct JSONModel: Decodable, Hashable {
    var currentWeather: String
}
