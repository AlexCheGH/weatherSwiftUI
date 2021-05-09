//
//  LocationSelectionViewModel.swift
//  WeatherAppSwiftUIWatch Extension
//
//  Created by AP Aliaksandr Chekushkin on 4/26/21.
//

import Foundation


class LocationSelectionViewModel : ObservableObject {
    @Published private var fileManager = LocalFileManager<String>()
    
    let fileName: String
    
    init(fileName: String) {
        self.fileName = fileName
        self.locations = fileManager.getDataFromDisk(named: fileName)
    }
    
    @Published var locations: [String] = [String]()
    @Published var weatherItems: [WeatherViewModel] = [WeatherViewModel]()
        
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
