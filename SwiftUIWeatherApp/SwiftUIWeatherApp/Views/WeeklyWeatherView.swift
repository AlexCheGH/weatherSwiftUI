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
    private let fontMultiplier: CGFloat = 0.15
    
    var body: some View {
                VStack {
                    Text(weekday ?? "...")
                        .font(.system(size: 15, weight: .medium, design: .default))
                        .foregroundColor(.black)
                    
                    WeatherImage(imageName: imageName)
                        .frame(width: 50, height: 50)
                    
                    Text("\(temperature ?? "...")º")
                        .font(.system(size: 15, weight: .semibold, design: .default))
                        .foregroundColor(.black)
                }
    }
    
   private func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * fontMultiplier
    }
    
}


struct WeatherImage: View {
    var imageName: String?
    
    var body: some View {
        makeBody()
    }
    
   private func makeBody() -> some View {
        Unwrap(imageName) { imageName in
            GeometryReader {geo in
            Image(uiImage: UIImage(named: "\(imageName).png")!)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fill)
        }
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
