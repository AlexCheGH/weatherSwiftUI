//
//  MapView.swift
//  SwiftUIWeatherApp
//
//  Created by AP Aliaksandr Chekushkin on 2/28/21.
//

import SwiftUI
import PartialSheet
import MapKit

struct MapView: View {
    
    @ObservedObject var tiles = TilesViewModel()
    
    @Binding var coordinates: CGPoint
    @Binding var isMapTapped: Bool
    
    @State var isPlaying = false
    @State private var sliderValue = 0.0
    @State var timer: Timer?
    @State var isNewScheme = false
    
    var body: some View {
        makeBody()
    }
    
    func makeBody() -> some View {
        ZStack {
            GeometryReader { geo in
                Map(overlay: tiles.overlays[Int(sliderValue)],
                    coordinate: $coordinates)
                    .ignoresSafeArea()
                
                VStack(alignment: .center) {
                    Spacer()
                    PlayerView(isPlaying: $isPlaying,
                               currentValue: $sliderValue,
                               isChanged: $isNewScheme,
                               endPoint: tiles.timestamps.count,
                               text: tiles.dates[Int(sliderValue)])
                        .frame(width: geo.size.width * 0.8, height: 70)
                        .padding(.leading, geo.size.width * 0.1)
                }
            }
        }
        .onChange(of: coordinates, perform: { value in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                isMapTapped = false
            })
        })
        .onChange(of: isPlaying) { (_) in
            isPlaying ? fireAnimation() : invalidateAnimation()
        }
        .onChange(of: isNewScheme, perform: { value in
            isPlaying = false
            sliderValue = 0.0
            tiles.refreshOverlays()
        })
    }
    
    private func fireAnimation() {
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
            
           if Int(sliderValue) >= tiles.timestamps.count - 1 {
            sliderValue = 0.0 }
           else {
            sliderValue += 1
           }
        }
        timer?.fire()
    }
    
    private func invalidateAnimation() {
        timer?.invalidate()
        sliderValue += 0.01 // tiles won't dissapear from map, as it forces to re-render the view
    }
    
}

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
