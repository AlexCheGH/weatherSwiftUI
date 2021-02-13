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
    
    var body: some View {
        HStack {
            VStack {
                Text(weekday ?? "...")
                    .font(.system(size: 15, weight: .medium, design: .default))
                    .foregroundColor(.white)
                
                WeatherImage(imageName: imageName)
                
                Text("\(temperature ?? "...")º")
                    .font(.system(size: 15, weight: .semibold, design: .default))
                    .foregroundColor(.white)
            }
        }
    }
}


struct WeatherImage: View {
    var imageName: String?
    
    var body: some View {
        makeBody()
    }
    
    func makeBody() -> some View {
        Unwrap(imageName) { imageName in
            Image(uiImage: UIImage(named: "\(imageName).png")!)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
}

struct Unwrap<Value, Content: View>: View {
    private let value: Value?
    private let contentProvider: (Value) -> Content

    init(_ value: Value?,
         @ViewBuilder content: @escaping (Value) -> Content) {
        self.value = value
        self.contentProvider = content
    }

    var body: some View {
        value.map(contentProvider)
    }
}
