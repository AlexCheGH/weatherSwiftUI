//
//  LargeWidget.swift
//  WeatherWidgetExtension
//
//  Created by AP Aliaksandr Chekushkin on 3/21/21.
//

import WidgetKit
import SwiftUI

struct LargeWidget: Widget {
    
    private let widgetName = NSLocalizedString("widget_large_name_key", comment: "")
    private let widgetDescription = NSLocalizedString("widget_description_key", comment: "")
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: WidgetKind.largeDafault.rawValue,
                            provider: Provider()) { entry in
            LargeWidgetView(data: entry)
        }
        .description(widgetDescription)
        .configurationDisplayName(widgetName)
        .supportedFamilies([.systemLarge])
    }
}

struct LargeWidgetView: View {
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
                Group {
                    if data.decription != nil {
                        Text(data.decription!)
                    }
                }
                
            }
            .padding()
        }
    }
}
