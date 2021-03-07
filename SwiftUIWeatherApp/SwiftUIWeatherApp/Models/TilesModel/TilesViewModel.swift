//
//  TilesViewModel.swift
//  SwiftUIWeatherApp
//
//  Created by AP Aliaksandr Chekushkin on 3/7/21.
//

import Foundation
import MapKit

class TilesViewModel: ObservableObject {
    
    @Published private var tilesModel = TilesModel()
    
    var timestamps: [Int] {
        tilesModel.timestamps
    }
    
    func getTile(_ step: Int) -> MKTileOverlay {
        tilesModel.getTileStampPair(timeStamp: timestamps[step])
    }
}
