//
//  UserPreferenceViewModel.swift
//  SwiftUIWeatherApp
//
//  Created by AP Aliaksandr Chekushkin on 2/22/21.
//

import Foundation

class UserPreferencesViewModel: ObservableObject {
    
    @Published private var userPreferenceModel = UserPreferences()
    
    var tempPreference: Int {
        get { userPreferenceModel.getTempPreference() }
        set { userPreferenceModel.savePreference(section: Temperature.self, chosenIndex: newValue)  }
    }
    
    var windSpeedPreference: Int {
        get { userPreferenceModel.getWindPreference() }
        set { userPreferenceModel.savePreference(section: WindSpeed.self, chosenIndex: newValue) }
    }
    
    var pressurePreference: Int {
        get { userPreferenceModel.getPressurePreference() }
        set { userPreferenceModel.savePreference(section: Pressure.self, chosenIndex: newValue) }
    }
    
    var checkListItems: [ChecklistItem] {
        userPreferenceModel.checklistItems
    }
    
    func changeColorScheme(schemeNumber: Int) {
        userPreferenceModel.changeColorScheme(schemeNumber: schemeNumber)
    }
    
}
