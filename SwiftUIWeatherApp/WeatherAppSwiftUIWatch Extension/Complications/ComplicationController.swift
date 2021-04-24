//
//  ComplicationController.swift
//  WeatherAppSwiftUIWatch Extension
//
//  Created by AP Aliaksandr Chekushkin on 3/24/21.
//

import ClockKit
import SwiftUI

class ComplicationController: NSObject, CLKComplicationDataSource {
    
    private static let location = UserPreferences().defaultCity()
    private let weatherManager = WeatherModel(location: location)
    
    private let todayString = NSLocalizedString("today_weekdat", comment: "")
    
    // MARK: - Complication Configuration
    func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
        let appName = NSLocalizedString("WeatherApp", comment: "")
        let identifier = "WeatherApp_complication"
        
        // All the families: https://blog.drkaka.com/apple-watch-complication-templates-f78b75a80bb1
        let supportedFamilies: [CLKComplicationFamily] = [.circularSmall, .graphicCorner, .graphicCircular, .graphicRectangular, .graphicExtraLarge]
        
        let descriptors = [CLKComplicationDescriptor(identifier: identifier, displayName: appName, supportedFamilies: supportedFamilies)]
    
        handler(descriptors)
    }
    
    func handleSharedComplicationDescriptors(_ complicationDescriptors: [CLKComplicationDescriptor]) {
        // Do any necessary work to support these newly shared complication descriptors
    }
    
    // MARK: - Timeline Configuration
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        // Call the handler with the last entry date you can currently provide or nil if you can't support future timelines
        // Indicate that the app can provide timeline entries for the next 24 hours.
        handler(Date().addingTimeInterval(24.0 * 60.0 * 60.0))
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        // Call the handler with your desired behavior when the device is locked
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
        
        weatherManager.loadData { [self] in
            let data = WeatherInfo(date: todayString,
                                   currentTemp: weatherManager.currentWeather?.currentTemp,
                                   icon: weatherManager.currentWeather?.icon,
                                   id: Int.random(in: 1..<999))
            
            handler(createTimelineEntry(forComplication: complication, data: data))
        }
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after the given date
        let oneHour = 60.0 * 60.0
        let twentyFourHours = 24.0 * 60.0 * 60.0
        
        // Create an array to hold the timeline entries.
        var entries = [CLKComplicationTimelineEntry]()
        
        // Calculate the start and end dates.
        var current = date.addingTimeInterval(oneHour)
        let endDate = date.addingTimeInterval(twentyFourHours)
        
        // Create a timeline entry for every hour from the starting time.
        // Stop once you reach the limit or the end date.
        weatherManager.loadData { [self] in
            
            while (current.compare(endDate) == .orderedAscending) && (entries.count < limit) {
                let data = WeatherInfo(date: todayString,
                                       currentTemp: weatherManager.currentWeather?.currentTemp,
                                       icon: weatherManager.currentWeather?.icon,
                                       id: Int.random(in: 1..<999))
                
                guard let timelineEntry = createTimelineEntry(forComplication: complication, data: data) else {
                    handler(nil)
                    return
                }
                
                entries.append(timelineEntry)
                current = current.addingTimeInterval(oneHour)
            }
            handler(entries)
        }
    }
    
    // MARK: - Sample Templates
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        let currentTemp = "25"
        let icon = "02d"
        
        let data = WeatherInfo(date: todayString,
                               currentTemp: currentTemp,
                               icon: icon,
                               id: Int.random(in: 1..<999))
        let template = createTemplate(forComplication: complication, data: data)
        
        handler(template)
    }
    
    private func createTimelineEntry(forComplication complication: CLKComplication, data: WeatherInfo) -> CLKComplicationTimelineEntry? {
        let date = Date()
        // Get the correct template based on the complication.
        let template = createTemplate(forComplication: complication, data: data)
        
        // Use the template and date to create a timeline entry.
        if let template = template {
            return CLKComplicationTimelineEntry(date: date, complicationTemplate: template)
        } else {
            return nil
        }
    }
    
    //MARK:- Add more complications for every size family
    private func createTemplate(forComplication complication: CLKComplication, data:  WeatherInfo) -> CLKComplicationTemplate? {
        
        let icon = data.icon ?? ""
        let temperature = data.currentTemp ?? ""
        
        switch complication.family {
        case .circularSmall:
            return CLKComplicationTemplateGraphicCircularView(ComplicationViewCircular(image: icon))
        case .graphicCircular:
            return CLKComplicationTemplateGraphicCircularView(ComplicationViewCircular(image: icon))
        case .graphicCorner:
            return CLKComplicationTemplateGraphicCornerCircularView(ComplicationViewCircular(image: icon))
        case .graphicRectangular:
            return CLKComplicationTemplateGraphicRectangularFullView(ComplicationWeatherViewRectangular(image: icon,
                                                                                                        temperature: temperature))
        case .graphicExtraLarge:
            return CLKComplicationTemplateGraphicExtraLargeCircularView(ComplicationWeatherViewLargeGraphic(image: icon,
                                                                                                            temperature: temperature))
        default:
            return nil
        }
    }
}

