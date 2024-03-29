//
//  TilesModel.swift
//  SwiftUIWeatherApp
//
//  Created by AP Aliaksandr Chekushkin on 3/6/21.
//

import Foundation
import MapKit

class OverlayModel {
    var timestamps: [Int]
    var overlayCollection: [Int: MKTileOverlay]
    
    private let networkManager = NetworkManager()
    
    var dates: [String]
    var overlays: [MKTileOverlay]

    init() {
        timestamps = []
        dates = []
        overlays = []
        overlayCollection = [Int():MKTileOverlay()]
        
        self.getTimestamps { (timestamps) in
            self.timestamps = timestamps
        }
        
        timestamps.forEach{
            overlayCollection[$0] = nil
            
            let stringDate = DateManager.makeFormatedString(date: $0, format: "MM-dd-yyyy HH:mm")
            dates.append(stringDate)
        }
        refreshOverlays()
    }
    
    func refreshOverlays() {
        overlays.removeAll()
        timestamps.forEach{
            let overlay = getTileOverlay(timestamp: $0)
            overlays.append(overlay)
        }
    }
    
    func getTileStampPair(timeStamp: Int) -> MKTileOverlay {
        let value = overlayCollection[timeStamp]
            if let overlay = value {
                return overlay
            }
        let overlay = getTileOverlay(timestamp: timeStamp)
        overlayCollection[timeStamp] = overlay
                
        return overlay
    }
    
    private func getTimestamps(completion: ([Int]) -> Void) {
        networkManager.getTileTimestams { (timestamps) in
            self.timestamps = timestamps
            completion(timestamps)
        }
    }
    
    func getTileOverlay(timestamp: Int) -> MKTileOverlay {
        let userPreference = UserPreferences()
        userPreference.checkTilesSettings()
        
        let colorScheme = userPreference.getColorSchemePreference()
        let snow = userPreference.getSnowPreference()
        let smootheness = userPreference.getSmoothPreference()
        
        let template = "https://tilecache.rainviewer.com/v2/radar/\(timestamp)/256/{z}/{x}/{y}/\(colorScheme)/\(smootheness)_\(snow).png"
        
        let tempOverlay = MKTileOverlay(urlTemplate: template)
        tempOverlay.canReplaceMapContent = false
        
        return tempOverlay
    }
}









