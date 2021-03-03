//
//  String + Utilities.swift
//  WeatherApp
//
//  Created by AP Aliaksandr Chekushkin on 9/1/20.
//  Copyright © 2020 AP Aliaksandr Chekushkin. All rights reserved.
//

import Foundation

extension String{
    var encodeUrl : String {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
    var decodeUrl : String { return self.removingPercentEncoding! } 
}
