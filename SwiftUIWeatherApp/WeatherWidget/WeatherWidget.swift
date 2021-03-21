//
//  WeatherWidget.swift
//  WeatherWidget
//
//  Created by AP Aliaksandr Chekushkin on 3/18/21.
//

import WidgetKit
import SwiftUI

@main
struct MainWidget: Widget {
    
    private let widgetName = NSLocalizedString("widget_compact_name_key", comment: "")
    private let widgetDescription = NSLocalizedString("widget_description_key", comment: "")
    
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Widget", provider: Provider()) { entry in
            WidgetView(data: entry)
        }.description(widgetDescription)
        .configurationDisplayName(widgetName)
    }
}

struct WidgetView: View {
    var data: Model
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .green]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text(data.city)
                    .font(.system(size: 20))
                Image(data.icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Text(data.currentWeather + "º")
                    .font(.system(size: 25))
            }
            .padding()
        }
    }
}



