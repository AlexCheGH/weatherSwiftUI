//
//  LocationSelectionViewModel.swift
//  WeatherAppSwiftUIWatch Extension
//
//  Created by AP Aliaksandr Chekushkin on 4/26/21.
//

import Foundation


class LocationSelectionViewModel : ObservableObject {
    @Published private var fileManager = LocalFileManager<String>()
    @Published var locations: [String] = [String]()
    
   private let userPreferences = UserPreferences()
    
    let fileName: String
    
    init(fileName: String) {
        self.fileName = fileName
        self.locations = fileManager.getDataFromDisk(named: fileName)
    }
      
    func setDefaultLocation(location: String) {
        userPreferences.saveCity(named: location)
    }
    
    func saveToDisk(item: String) {
        fileManager.saveToDisk(data: item, named: fileName)
        refreshItems()
    }
    
    func deleteFromDisk(item: String) {
        fileManager.deleteDataPiece(item: item, from: locations, fileName: fileName)
        refreshItems()
    }
    
    private func refreshItems() {
        locations = fileManager.getDataFromDisk(named: fileName)
    }
}
