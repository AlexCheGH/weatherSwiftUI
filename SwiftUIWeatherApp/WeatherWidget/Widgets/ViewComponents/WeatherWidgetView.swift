//
//  WeatherWidgetContentView.swift
//  WeatherWidgetExtension
//
//  Created by AP Aliaksandr Chekushkin on 3/21/21.
//

import SwiftUI

struct WeatherWidgetView: View {
    var city: String
    var icon: String
    var currentWeather: String
    
    var body: some View {
        Text(city)
            .font(.system(size: 20))
        Image(icon)
            .resizable()
            .aspectRatio(contentMode: .fit)
        Text(currentWeather + "º")
            .font(.system(size: 25))
    }
}
