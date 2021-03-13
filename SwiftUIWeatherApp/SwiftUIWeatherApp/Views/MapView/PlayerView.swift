//
//  PlayerView.swift
//  SwiftUIWeatherApp
//
//  Created by AP Aliaksandr Chekushkin on 3/13/21.
//

import SwiftUI
import PartialSheet

struct PlayerView: View {
    
    @EnvironmentObject var partialSheetManager: PartialSheetManager
    @ObservedObject private var userPreference = UserPreferencesViewModel()
    
    @State var chosenScheme = 0
    
    @Binding var isPlaying: Bool
    @Binding var currentValue: Double
    @Binding var isChanged: Bool
    
    var endPoint: Int
    var text: String
    
    var body: some View {
        makeBody()
    }
    
    private func makeBody() -> some View {
        
        ZStack {
            GeometryReader { geo in
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.white)
                    .opacity(0.8)
                HStack {
                    playButton()
                        .frame(width: geo.size.width * 0.15,
                               height: geo.size.height)
                    VStack {
                        dateText()
                        slider()
                    }
                    settingsButton()
                        .frame(width: geo.size.width * 0.2,
                               height: geo.size.height)
                }
            }
        }
        .onChange(of: chosenScheme, perform: { value in
            userPreference.changeColorScheme(schemeNumber: chosenScheme + 1) //list items start with 0, json with 1
            isChanged.toggle()
        })
    }
    
    
    private func playButton() -> some View {
        let playIcon = "play.fill"
        let pauseIcon = "pause.fill"
        
        return Button(action: {
            isPlaying.toggle()
        }, label: {
            Image(systemName: !isPlaying ? playIcon : pauseIcon)
                .resizable()
                .font(.system(size: 10))
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.black)
                .padding()
        })
    }
    
    
    private func slider() -> some View {
        Slider(value: $currentValue, in: 0...Double(endPoint - 1), step: 1)
    }
    
    private func dateText() -> some View {
        Text(text)
    }
    
    private func settingsButton() -> some View {
        let gearIcon = "gear"
        
        return Button(action: {
            self.partialSheetManager.showPartialSheet({
    
            }) {
                settingsOptions()
            }
        }, label: {
            Image(systemName: gearIcon)
                .resizable()
                .font(.system(size: 10))
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.black)
                .padding()
        })
    }
    private func settingsOptions() -> some View {
        let snowString = NSLocalizedString("snow_key", comment: "")
        let smoothString = NSLocalizedString("smooth_key", comment: "")
        let colorSchemeString = NSLocalizedString("color_scheme_key", comment: "")
        
        return VStack {
            Toggle(snowString, isOn: $userPreference.isSnowActive)
            Toggle(smoothString, isOn: $userPreference.isSmoothActive)
            VStack {
                Text(colorSchemeString)
                    .font(.system(.headline))
                CheckList(checklistItems: userPreference.checkListItems, chosenOption: $chosenScheme)
                    .frame(height: 250)
            }.padding(.top)
        }
        .padding([.leading, .trailing])
    }
}
