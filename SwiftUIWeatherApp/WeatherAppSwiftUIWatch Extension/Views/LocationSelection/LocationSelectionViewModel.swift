//
//  LocationSelectionViewModel.swift
//  WeatherAppSwiftUIWatch Extension
//
//  Created by AP Aliaksandr Chekushkin on 4/26/21.
//

import Foundation


class LocationSelectionViewModel : ObservableObject {
    private let fileManager = LocalFileManager<String>()
    
    let fileName: String
    
    private var counter = 0
    
    init(fileName: String) {
        self.fileName = fileName
    }
    
    var item: [String] {
        let item = fileManager.getDataFromDisk(named: fileName)
        return item
    }
    
    func saveToDisk(item: String) {
        fileManager.saveToDisk(data: item, named: fileName)
    }
    
    
    
    
}
