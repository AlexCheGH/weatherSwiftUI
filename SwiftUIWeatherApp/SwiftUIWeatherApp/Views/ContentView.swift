//
//  ContentView.swift
//  SwiftUIWeatherApp
//
//  Created by AP Aliaksandr Chekushkin on 1/3/21.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var forecast = WeatherViewModel(location: "Minsk")
    
    private let locationPlaceholderString = NSLocalizedString("location_placeholder", comment: "")
    private let todayString = NSLocalizedString("today_weekdat", comment: "")
    
    var body: some View {
        makeBody()
    }
    
    private func makeBody() -> some View {
        ZStack()  {
            gradient()
            VStack(alignment: .center) {
                GeometryReader { geo in
                    VStack {
                        textField(fontSize: size(geo.size))
                            .multilineTextAlignment(.center)
                        currentWeatherCard(size: sizeCard(geo.size))
                            .padding()
                    }
                }
                HStack(alignment: .center) {
                    ForEach(forecast.weeklyWeather) { item in
                        
                        WeeklyWeatherView(weekday: item.date,
                                          temperature: item.currentTemp,
                                          imageName: item.icon,
                                          size: CGSize(width: 50, height: 50),
                                          viewType: .weeklyWeather)
                    }
                }
                .padding()
            }
            .onAppear{ forecast.loadData() }
        }
    }
    
    
    
    
    private func gradient() -> some View {
        LinearGradient(gradient: Gradient(colors: [.blue, .green]),
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all)
    }
    
    private func textField(fontSize: CGFloat) -> some View {
        TextField(locationPlaceholderString, text: $forecast.location, onCommit:  {
            forecast.loadData()
            forecast.saveLocation()
        })
        .font(.system(size: fontSize,
                      weight: .medium,
                      design: .default))
        .foregroundColor(.black)
    }
    
    private func currentWeatherCard(size: CGSize) -> some View {
        WeeklyWeatherView(weekday: todayString,
                          temperature: forecast.currentWeather?.currentTemp,
                          imageName: forecast.currentWeather?.icon,
                          size: size,
                          viewType: .currentWeather)
    }
    
    private func sizeCard(_ size: CGSize) -> CGSize {
        let multiplier: CGFloat = 0.4
        
        if size.width > size.height {
            return CGSize(width: size.height * multiplier, height: size.height * multiplier)
        } else {
            return CGSize(width: size.width * multiplier, height: size.width * multiplier)
        }
    }
    
    private func size(_ size: CGSize) -> CGFloat {
        if size.width > size.height {
            return size.height * 0.15
        } else {
            return size.width * 0.15
        }
    }
    
}
