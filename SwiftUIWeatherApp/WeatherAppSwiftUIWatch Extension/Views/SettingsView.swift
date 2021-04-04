//
//  SettingsView.swift
//  WeatherAppSwiftUIWatch Extension
//
//  Created by AP Aliaksandr Chekushkin on 4/4/21.
//

import SwiftUI

struct SettingsView: View {
    
    @State var isOn = UserPreferences().getTempPreference() == 1 ? true : false
    var body: some View {
        VStack(alignment: .leading) {
            Text("Settings")
            Spacer()
            Toggle(isOn ? "Celcious" : "Farenheight", isOn: $isOn)
        }
        .padding()
        .onChange(of: isOn, perform: { value in
            UserPreferences().savePreference(section: Temperature.self, chosenIndex: isOn ? 1 : 0)
            print(UserPreferences().defaultCity())
            print(UserPreferences().getTempPreference())
        })
        .onAppear { print(UserPreferences().getTempPreference()) }
    }
}





struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
