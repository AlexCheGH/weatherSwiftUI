//
//  MediumWidget.swift
//  WeatherWidgetExtension
//
//  Created by AP Aliaksandr Chekushkin on 3/21/21.
//

import WidgetKit
import SwiftUI


//need to find a way of preparing generic object and inject it with different <Content>
struct MediumWidget: Widget {
    
    private let widgetName = NSLocalizedString("widget_medium_name_key", comment: "")
    private let widgetDescription = NSLocalizedString("widget_description_key", comment: "")
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: WidgetKind.mediumDefault.rawValue,
                            provider: Provider()) { entry in
            MediumWidgetView(data: entry)
        }
        .description(widgetDescription)
        .configurationDisplayName(widgetName)
        .supportedFamilies([.systemMedium])
    }
}

struct MediumWidgetView: View {
    var data: Model
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .green]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            HStack {
                WeatherWidgetView(city: data.city,
                                  icon: data.icon,
                                  currentWeather: data.currentWeather)
            }
            .padding()
        }
    }
}
