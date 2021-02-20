//
//  ContentView.swift
//  SwiftUIWeatherApp
//
//  Created by AP Aliaksandr Chekushkin on 1/3/21.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var forecast = WeatherViewModel(location: "Minsk")
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    private let locationPlaceholderString = NSLocalizedString("location_placeholder", comment: "")
    private let todayString = NSLocalizedString("today_weekdat", comment: "")
    
    var body: some View {
        //        if horizontalSizeClass == .regular {
        makeRegularBody()
        //        } else {
        //            makeCompactBody()
        //        }
    }
    
    private func makeCompactBody() -> some View {
        ZStack {
            gradient()
            
            GeometryReader { geo in
                
                VStack {
                    
                    VStack {
                        textField(fontSize: 15)
                        currentWeatherCard()
                    }.padding()
                    
                    HStack(alignment: .center) {
                        ForEach(forecast.weeklyWeather) { item in
                            WeeklyWeatherView(weekday: item.date, temperature: item.currentTemp, imageName: item.icon)
                        }
                    }
                }
            }.onAppear{ forecast.loadData() }
        }
    }
    
    
    
    
    private func makeRegularBody() -> some View {
        ZStack()  {
            gradient()
            VStack(alignment: .center) {
                
                    GeometryReader { geo in
                        VStack {
                        textField(fontSize: size(geo.size))
                    .multilineTextAlignment(.center)
                
                currentWeatherCard()
                    .padding()
                }
                }
                
                Spacer()
                
                HStack {
                    ForEach(forecast.weeklyWeather) { item in
                        WeeklyWeatherView(weekday: item.date, temperature: item.currentTemp, imageName: item.icon)
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
        TextField(locationPlaceholderString, text: $forecast.location, onCommit:  { forecast.loadData() })
            .font(.system(size: fontSize,
                          weight: .medium,
                          design: .default))
            .foregroundColor(.black)
    }
    
    private func currentWeatherCard() -> some View {
        WeeklyWeatherView(weekday: todayString, temperature: forecast.currentWeather?.currentTemp, imageName: forecast.currentWeather?.icon)
    }
    
    
    
    private func size(_ size: CGSize) -> CGFloat {
        if size.width > size.height {
            return size.height * 0.15
        } else {
            return size.width * 0.15
        }
    }
    
}
