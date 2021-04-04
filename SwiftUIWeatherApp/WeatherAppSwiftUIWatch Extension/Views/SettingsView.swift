//
//  SettingsView.swift
//  WeatherAppSwiftUIWatch Extension
//
//  Created by AP Aliaksandr Chekushkin on 4/4/21.
//

import SwiftUI

struct SettingsView: View {
    private let settingsString = NSLocalizedString("settings_key", comment: "")
    private let celciousString = NSLocalizedString("celcious_key", comment: "")
    private let farenheighString = NSLocalizedString("farenheit_key", comment: "")
    
    @State var isOn = UserPreferences().getTempPreference() == 1 ? true : false
    var body: some View {
        VStack(alignment: .leading) {
            Text(settingsString)
            Spacer()
            Toggle(isOn ? celciousString : farenheighString, isOn: $isOn)
        }
        .padding()
        .onChange(of: isOn, perform: { value in
            UserPreferences().savePreference(section: Temperature.self, chosenIndex: isOn ? 1 : 0)
        })
    }
}





struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
