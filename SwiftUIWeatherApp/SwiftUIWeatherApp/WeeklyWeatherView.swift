//
//  WeeklyWeatherView.swift
//  SwiftUIWeatherApp
//
//  Created by AP Aliaksandr Chekushkin on 1/3/21.
//

import SwiftUI

struct WeeklyWeatherView: View {
    
    var weekday: String
    var temperature: String
    var imageName: String
    
    var body: some View {
        HStack {
            VStack {
                Text(weekday)
                    .font(.system(size: 20, weight: .medium, design: .default))
                    .foregroundColor(.white)
                Image(systemName: imageName)
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                Text("\(temperature)º")
                    .font(.system(size: 20, weight: .semibold, design: .default))
                    .foregroundColor(.white)
            }
        }
    }
}

struct WeeklyWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeeklyWeatherView(weekday: "TEST", temperature: "21", imageName: "sunrise.fill")
    }
}
