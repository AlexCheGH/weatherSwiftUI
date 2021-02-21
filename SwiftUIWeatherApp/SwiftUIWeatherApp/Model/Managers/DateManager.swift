//
//  DateManager.swift
//  SwiftUIWeatherApp
//
//  Created by AP Aliaksandr Chekushkin on 2/21/21.
//

import Foundation


class DateManager {
    static func makeFormatedString(date: Int?, format: String = "HH:mm") -> String {
        let date = Date(timeIntervalSince1970: Double(date ?? 0))
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = format
        
        return dateFormat.string(from: date)
    }
}
