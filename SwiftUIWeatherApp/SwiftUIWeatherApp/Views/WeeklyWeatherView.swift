//
//  WeeklyWeatherView.swift
//  SwiftUIWeatherApp
//
//  Created by AP Aliaksandr Chekushkin on 1/3/21.
//

import SwiftUI

struct WeeklyWeatherView: View {
    
    var weekday: String?
    var temperature: String?
    var imageName: String?
    var size: CGSize
    var viewType: WeatherViewType
    var fontColor: UIColor = UIColor.black
    
    var body: some View {
        VStack {
            Text(weekday ?? "...")
                .font(.system(size: fontSize(for: size),
                              weight: .medium,
                              design: .default))
                .foregroundColor(Color(fontColor))
            
            WeatherImage(imageName: imageName)
                .frame(width: size.width,
                       height: size.height)
            
            Text("\(temperature ?? "...")º")
                .font(.system(size: fontSize(for: size),
                              weight: .semibold,
                              design: .default))
                .foregroundColor(Color(fontColor))
        }
    }
    
    private func fontSize(for size: CGSize) -> CGFloat {
        let currentFontMultiplier: CGFloat = 0.25
        let weeklyFontMultiplier: CGFloat = 0.25
        
        if viewType == .currentWeather {
            return min(size.width, size.height) * currentFontMultiplier
        }
        else {
            return min(size.width, size.height) * weeklyFontMultiplier
        }
    }
}

enum WeatherViewType {
    case currentWeather
    case weeklyWeather
}

struct WeatherImage: View {
    var imageName: String?
    
    var body: some View {
        makeBody()
    }
    
    private func makeBody() -> some View {
        Unwrap(imageName) { imageName in
            Image(uiImage: UIImage(named: "\(imageName).png")!)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fill)
        }
    }
}

