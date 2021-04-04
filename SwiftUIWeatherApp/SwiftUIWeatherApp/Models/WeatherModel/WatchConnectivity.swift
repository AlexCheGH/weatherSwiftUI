//
//  WatchConnectivity.swift
//  SwiftUIWeatherApp
//
//  Created by AP Aliaksandr Chekushkin on 3/30/21.
//

import Foundation
import WatchConnectivity

class WatchConnectivity : NSObject,  WCSessionDelegate {
    
   private let userPrefernces = UserPreferences()
    
    var session: WCSession
    
    var receivedMessage = ""
    var tempSetting = 0
    
    init(session: WCSession = .default){
        self.session = session
        super.init()
        self.session.delegate = self
        session.activate()
        
        self.receivedMessage = userPrefernces.defaultCity()
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        self.receivedMessage = applicationContext[WatchKeyPath.city.rawValue] as? String ?? "Error"
        saveCity(city: receivedMessage)
  
    }
    
    
    
    
    
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
    }
    func sessionDidDeactivate(_ session: WCSession) {
    }
    #endif
    
    
    
    
    
    func saveCity(city: String) {
        userPrefernces.saveCity(named: city)
    }
    
    func saveTemperaturePreference(index: Int) {
        userPrefernces.savePreference(section: Temperature.self, chosenIndex: index)
    }
}

enum WatchKeyPath: String {
    case city = "city"
}
