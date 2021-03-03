//
//  CustomAnnotation.swift
//  SwiftUIWeatherApp
//
//  Created by AP Aliaksandr Chekushkin on 3/2/21.
//

import MapKit
import Foundation

class LocationAnnotationView: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    
    var title: String?

    init(coord: CLLocationCoordinate2D, title: String? = nil) {
        self.coordinate = coord
        self.title = title
    }
    
}
