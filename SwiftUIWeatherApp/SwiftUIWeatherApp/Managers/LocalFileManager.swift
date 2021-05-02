//
//  FileManager.swift
//  SwiftUIWeatherApp
//
//  Created by AP Aliaksandr Chekushkin on 4/26/21.
//

import Foundation


class LocalFileManager<T: Codable> {
    
    func saveToDisk(data: T, named: String) {
        let encoder = JSONEncoder()
        let newData = try? encoder.encode(data.self)
        
        if let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first, let newData = newData
        {
            let fileURL = directory.appendingPathComponent("/\(named).txt")
            if FileManager.default.fileExists(atPath: fileURL.path) {
                do {
                    var oldData = try Data(contentsOf: fileURL)
                    oldData += newData
                    try oldData.write(to: fileURL)
                }
                catch { print("Error with re-writing the file") }
            } else {
                do { try newData.write(to: fileURL) }
                catch {  }
            }
        }
    }
    
   
    
    
    func getDataFromDisk(named: String) -> [String] {
        
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return [] }
        let fileURL = directory.appendingPathComponent("/\(named).txt")
        
        guard let text = try? String(contentsOf: fileURL, encoding: .utf8) else { return [] }
        
        let rawArrayString = changeString(text: text)
        let returnArray = makeArray(text: rawArrayString)
        
        return returnArray
    }
    
    
    private func changeString(text: String) -> String {
        let quotationMark = "\u{0022}"
        let comma = "\u{002c}"
        
        var tempString = text.replacingOccurrences(of: quotationMark + quotationMark,
                                                   with: quotationMark + comma + quotationMark,
                                                   options: .literal,
                                                   range: nil)
        let firstIndex = tempString.indices.startIndex
        tempString.insert("[", at: firstIndex)
        tempString.append("]")
        
        return tempString
    }
    
    private func makeArray(text: String) -> [String] {
        let decoder = JSONDecoder()
        guard let data = text.data(using: .utf8) else { return [] }
        guard let array = try? decoder.decode([String].self, from: data) else { return [] }
        
        return array
    }
    
    
}
