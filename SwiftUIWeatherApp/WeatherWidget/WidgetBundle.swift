//
//  WidgetBundle.swift
//  WeatherWidgetExtension
//
//  Created by AP Aliaksandr Chekushkin on 3/21/21.
//

import SwiftUI
import WidgetKit

@main

struct WeatherWidgets: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        CompactWidget()
        MediumWidget()
        LargeWidget()
    }
    
}
