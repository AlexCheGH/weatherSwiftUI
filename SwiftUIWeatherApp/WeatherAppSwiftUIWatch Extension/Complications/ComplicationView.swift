//
//  ComplicationView.swift
//  WeatherAppSwiftUIWatch Extension
//
//  Created by AP Aliaksandr Chekushkin on 4/10/21.
//

import SwiftUI
import ClockKit

struct ComplicationViewCircular: View {
    @State var image: String
    
    var body: some View {
            WeatherImage(imageName: image)
    }
}

struct ComplicationWeatherViewRectangular: View {
    @State var image: String
    @State var temperature: String
    
    private let todayString = NSLocalizedString("today_weekdat", comment: "")
    
    var body: some View {
        HStack {
            Text(todayString)
            WeatherImage(imageName: image)
            Text(temperature)
        }
    }
}


struct ComplicationWeatherViewLargeGraphic: View {
    @State var image: String
    @State var temperature: String
    
    var body: some View {
        VStack {
            Text(temperature)
            WeatherImage(imageName: image)
                .aspectRatio(contentMode: .fit)
        }
    }
}


struct ComplicationView_Previews: PreviewProvider {
    static var image = "02d"
    static var temperature = "25º"
    
    static var previews: some View {
        Group {
            CLKComplicationTemplateGraphicCircularView(
                ComplicationViewCircular(image: image)
            ).previewContext()
            CLKComplicationTemplateGraphicRectangularFullView(ComplicationWeatherViewRectangular(image: image, temperature: temperature))
                .previewContext()
            CLKComplicationTemplateGraphicExtraLargeCircularView(ComplicationWeatherViewLargeGraphic(image: image, temperature: temperature))
                .previewContext()
        }
    }
}
