//
//  Provider.swift
//  WeatherWidgetExtension
//
//  Created by AP Aliaksandr Chekushkin on 3/21/21.
//

import WidgetKit

struct Provider: TimelineProvider {
    
    private static let cityName = NSLocalizedString("city_dummy_key", comment: "")
    private static let defaultIcon = "10d"
    
    private let weatherManager = WeatherManager()
    
    private let dummyModel = Model(date: Date(),
                                   currentWeather: "25",
                                   icon: defaultIcon,
                                   city: cityName)
    
    func placeholder(in context: Context) -> Model {
        dummyModel
    }
    
    func getSnapshot(in context: Context, completion: @escaping (Model) -> Void) {
        completion(dummyModel)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Model>) -> Void) {
        weatherManager.getData { (modelData) in
            let date = Date()
            let nextUpdate = Calendar.current.date(byAdding: .minute, value: 60, to: date)
            let timeline = Timeline(entries: [modelData], policy: .after(nextUpdate!))
            
            completion(timeline)
        }
    }
}
