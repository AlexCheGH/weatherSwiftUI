//
//  ContentView.swift
//  WeatherAppSwiftUIWatch Extension
//
//  Created by AP Aliaksandr Chekushkin on 3/24/21.
//

import SwiftUI

struct WeatherView: View {
    
    @State var selector = 1
    
    var sessionModel = WatchConnectivity()
    @ObservedObject var viewModel = WeatherViewModel()
    
    
    var body: some View {
        makeBody()
    }
    
    
    private func makeBody() -> some View {
        VStack(alignment: .center){
            GeometryReader { geo in
                WeeklyWeatherView(weekday: viewModel.location,
                                  temperature: viewModel.currentWeather?.currentTemp,
                                  imageName: viewModel.currentWeather?.icon,
                                  size: CGSize(width: geo.size.width,
                                               height: geo.size.height * 0.6),
                                  viewType: .currentWeather,
                                  fontColor: .white)
            }
        }.onAppear {
            viewModel.loadData()
        }
    }
}
