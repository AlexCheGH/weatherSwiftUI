//
//  WeatherWidget.swift
//  WeatherWidget
//
//  Created by AP Aliaksandr Chekushkin on 3/18/21.
//

import WidgetKit
import SwiftUI
import Intents

struct Model: TimelineEntry {
    var date: Date
    var currentWeather: String
    var icon: String
}

struct JSONModel: Decodable, Hashable {
    var currentWeather: String
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> Model {
        Model(date: Date(), currentWeather: "Some", icon: "")
    }
    
    
    
    
    func getSnapshot(in context: Context, completion: @escaping (Model) -> Void) {
        let loadingData = Model(date: Date(), currentWeather: "some", icon: "")
        
        completion(loadingData)
        
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Model>) -> Void) {
        getData { (modelData) in
            let date = Date()
            let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: date)
            let timeline = Timeline(entries: [modelData], policy: .after(nextUpdate!))
            
            completion(timeline)
        }
    }
}

func getData(completion: @escaping (Model) -> ()) {
    let city = UserPreferences().defaultCity()
    
    let url = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=d993c7d8d3f4e8de63516cc737a6c16b"
    
    let session = URLSession(configuration: .default)
    session.dataTask(with: URL(string: url)!) {(data, _, err) in
        if err != nil {
            print(err!.localizedDescription)
            
            return
        }
        do {
            let jsonData = try JSONDecoder().decode(CurrentWeather.self, from: data!)
            
            let model = makeModelEntry(data: jsonData)
            
            completion(model)
        }
        catch {
            print(error.localizedDescription)
        }
    }.resume()
}


func makeModelEntry(data: CurrentWeather) -> Model {
    let preference = UserPreferences().getTempPreference()
    let rawTemperature = calculateTemperature(rawTemp: data.main.temp, tempSettings: preference)
    let icon = data.weather.first?.icon ?? ""
    let stringTemp = String(format: "%.0f", rawTemperature)
    
    return Model(date: Date(), currentWeather: stringTemp, icon: icon)
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
                Text("Now")
                    .font(.system(size: 20))
                Image(data.icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Text(data.currentWeather + "º")
                    .font(.system(size: 25))
            }.padding()
        }
    }
}


@main
struct MainWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Widget", provider: Provider()) { entry in
            WidgetView(data: entry)
        }.description("some description")
        .configurationDisplayName("some name to siplay")
    }
}


func calculateTemperature(rawTemp: Double, tempSettings: Int) -> Double {
    let kelvin = 273.15
    
    switch tempSettings {
    case 0:
        let result = (rawTemp - kelvin) * 9/5 + 32
        return result
    case 1:
        let result = rawTemp - kelvin
        return result
    default:
        return 0.0
    }
}
