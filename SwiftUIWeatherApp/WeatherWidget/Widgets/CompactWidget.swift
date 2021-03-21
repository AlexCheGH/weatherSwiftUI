//
//  WeatherWidget.swift
//  WeatherWidget
//
//  Created by AP Aliaksandr Chekushkin on 3/18/21.
//

import WidgetKit
import SwiftUI

struct CompactWidget: Widget {
    
    private let widgetName = NSLocalizedString("widget_compact_name_key", comment: "")
    private let widgetDescription = NSLocalizedString("widget_description_key", comment: "")
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: WidgetKind.smallDefault.rawValue,
                            provider: Provider()) { entry in
            CompactWidgetView(data: entry)
        }
        .description(widgetDescription)
        .configurationDisplayName(widgetName)
        .supportedFamilies([.systemSmall])
    }
}

struct CompactWidgetView: View {
    var data: Model
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .green]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            VStack {
                WeatherWidgetView(city: data.city,
                                  icon: data.icon,
                                  currentWeather: data.currentWeather)
            }
            .padding()
        }
    }
}



