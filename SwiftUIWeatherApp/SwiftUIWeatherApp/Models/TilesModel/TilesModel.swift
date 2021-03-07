//
//  TilesModel.swift
//  SwiftUIWeatherApp
//
//  Created by AP Aliaksandr Chekushkin on 3/6/21.
//

import Foundation
import MapKit

class TilesModel {
    var timestamps: [Int]
    
    var tilesCollection: [Int: MKTileOverlay]
    
    //get timestamps
    //make network call with a timestap
    //add tile to an array(dictionary?) [timeStamp: tile]
    
    
    init() {
        timestamps = []
        
        tilesCollection = [Int():MKTileOverlay()]
        
        self.getTimestamps { (timestamps) in
            self.timestamps = timestamps
        }
        
        timestamps.forEach{ tilesCollection[$0] = nil }
    }
    
    
    
    func getOverlays(timestamps: [Int]) -> [MKTileOverlay] {
        var overlays: [MKTileOverlay] = []
        for time in timestamps {
            let template = "https://tilecache.rainviewer.com/v2/radar/\(time)/256/{z}/{x}/{y}/7/1_1.png"
            
            let overlay = MKTileOverlay(urlTemplate:template)
            overlays.append(overlay)
        }

        return overlays
        
    }
    
    
    func getTileStampPair(timeStamp: Int) -> MKTileOverlay {
        let value = tilesCollection[timeStamp]
            if let tile = value {
                return tile
            }
        
        
        let tile = getTileOverlay(timestamp: timeStamp)
        tilesCollection[timeStamp] = tile
                
        return tile
    }
    
    private func getTimestamps(completion: ([Int]) -> Void) {
        let decoder = JSONDecoder()
        
        let stringURL = "https://api.rainviewer.com/public/maps.json"
        let url = URL(string: stringURL)
        
        guard let data = try? Data(contentsOf: url!) else { return }
        guard let tempValue = try? decoder.decode([Int].self, from: data) else { return }
        
        timestamps = tempValue
        completion(tempValue)
    }
    
    func getTileOverlay(timestamp: Int) -> MKTileOverlay {
        let userPreference = UserPreferences()
        userPreference.checkTilesSettings()
        
        let colorScheme = UserDefaults.standard.value(forKey: UserDefaultsKeysTiles.tilesColorScheme.rawValue)
        let snow = UserDefaults.standard.value(forKey: UserDefaultsKeysTiles.snow.rawValue)
        let smootheness = UserDefaults.standard.value(forKey: UserDefaultsKeysTiles.smoothed.rawValue)
        
        let template = "https://tilecache.rainviewer.com/v2/radar/\(timestamp)/512/{z}/{x}/{y}/\(colorScheme!)/\(smootheness!)_\(snow!).png"
        
        let tempOverlay = MKTileOverlay(urlTemplate: template)
        tempOverlay.canReplaceMapContent = false
        
        return tempOverlay
    }
    
}









