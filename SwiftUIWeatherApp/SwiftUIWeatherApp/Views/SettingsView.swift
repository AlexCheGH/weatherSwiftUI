//
//  SettingsView.swift
//  SwiftUIWeatherApp
//
//  Created by AP Aliaksandr Chekushkin on 2/21/21.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject private var userPreference = UserPreferencesViewModel()
    
    private let temperatureString = NSLocalizedString("temperature_key", comment: "")
    private let farenheitString = NSLocalizedString("farenheit_key", comment: "")
    private let celciousString = NSLocalizedString("celcious_key", comment: "")
    
    private let pressureString = NSLocalizedString("pressure_key", comment: "")
    private let kpaString = NSLocalizedString("kpa_key", comment: "")
    private let mbarString = NSLocalizedString("mbar_key", comment: "")
    private let mmString = NSLocalizedString("mm_key", comment: "")
    private let inchesString = NSLocalizedString("inches_key", comment: "")
    
    private let windspeedString = NSLocalizedString("wind_speed_key", comment: "")
    private let mphString = NSLocalizedString("mph_key", comment: "")
    private let kmhString = NSLocalizedString("kmh_key", comment: "")
    private let msString = NSLocalizedString("ms_key", comment: "")
    private let knotsString = NSLocalizedString("knots_key", comment: "")
    
    
    private let settingsString = NSLocalizedString("settings_key", comment: "")
    private let doneString = NSLocalizedString("done_key", comment: "")
    
    var body: some View {
        VStack {
            Text(settingsString)
                .font(.system(size: 25, weight: .medium, design: .default))
                .padding()
            
            SegmentedControll(options: [farenheitString, celciousString],
                              title: temperatureString,
                              selection: $userPreference.tempPreference)
            
            SegmentedControll(options: [kpaString, mbarString, mmString, inchesString],
                              title: pressureString,
                              selection: $userPreference.pressurePreference)
            
            SegmentedControll(options: [mphString, kmhString, msString, knotsString],
                              title: windspeedString,
                              selection: $userPreference.windSpeedPreference)
        }
        .padding(.top, 10)
        Spacer()
    } 
}

struct SegmentedControll: View {
    @Binding var selection: Int
    var options: [String]
    var title: String
    
    init(options: [String], title: String, selection: Binding<Int>) {
        self.options = options
        self.title = title
        self._selection = selection
        
        UISegmentedControl.appearance().selectedSegmentTintColor = .blue
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.blue], for: .normal)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title).offset(x: 15).font(.system(size: 20,
                                                   weight: .medium,
                                                   design: .default))
            
            Picker(selection: $selection, label: Text("")) {
                ForEach(0..<options.count, id: \.self) { index in
                    Text(options[index]).tag(index)
                }
            }.pickerStyle(SegmentedPickerStyle())
        }
    }
}







struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

