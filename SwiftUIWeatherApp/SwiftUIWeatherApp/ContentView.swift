//
//  ContentView.swift
//  SwiftUIWeatherApp
//
//  Created by AP Aliaksandr Chekushkin on 1/3/21.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .white]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center, spacing: 10) {
                Text("New York")
                    .font(.system(size: 30, weight: .medium, design: .default))
                    .foregroundColor(.white)
                    .padding()
                
                VStack {
                    Image(systemName: "sunrise.fill")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 180, height: 180)
                        .padding()
                    
                    Text(" 72º")
                        .font(.system(size: 70, weight: .bold, design: .default))
                        .foregroundColor(.white)
                        .frame(width: 200, height: 100)
                }
                Spacer()
                
                HStack(alignment: .center, spacing: 30) {
                    WeeklyWeatherView(weekday: "Tue", temperature: "70", imageName: "sunrise.fill")
                    WeeklyWeatherView(weekday: "Tue", temperature: "70", imageName: "sunrise.fill")
                    WeeklyWeatherView(weekday: "Tue", temperature: "70", imageName: "sunrise.fill")
                    WeeklyWeatherView(weekday: "Tue", temperature: "70", imageName: "sunrise.fill")
                    WeeklyWeatherView(weekday: "Tue", temperature: "70", imageName: "sunrise.fill")
                }
                Spacer()
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
