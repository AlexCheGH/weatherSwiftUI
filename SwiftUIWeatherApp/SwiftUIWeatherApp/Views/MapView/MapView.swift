//
//  MapView.swift
//  SwiftUIWeatherApp
//
//  Created by AP Aliaksandr Chekushkin on 2/28/21.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @ObservedObject var tiles = OverlayViewModel()
    
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
        .onAppear(perform: {
            sliderValue = 0.01 // re-renders view on appear, adds tiles on screen
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
