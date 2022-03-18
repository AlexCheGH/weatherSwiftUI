//
//  TilesViewModel.swift
//  SwiftUIWeatherApp
//
//  Created by AP Aliaksandr Chekushkin on 3/7/21.
//

import Foundation
import MapKit

class OverlayViewModel: ObservableObject {
    @Published private var overlayModel = OverlayModel()
    
    var timestamps: [Int] { overlayModel.timestamps }
    var dates: [String] { overlayModel.dates }
    var overlays: [MKTileOverlay] { overlayModel.overlays }
    
    func refreshOverlays() {
        overlayModel.refreshOverlays()
    }
    
}
