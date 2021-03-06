//
//  MapView.swift
//  SwiftUIWeatherApp
//
//  Created by AP Aliaksandr Chekushkin on 2/28/21.
//

import SwiftUI
import PartialSheet

struct MapView: View {
    @Binding var coordinates: CGPoint
    @Binding var isMapTapped: Bool
    
    var body: some View {
        makeBody()
    }
    
    func makeBody() -> some View {
        ZStack {
            GeometryReader { geo in
                Map(coordinate: $coordinates)
                    .ignoresSafeArea()
                
                VStack(alignment: .center) {
                    Spacer()
                    
                    PlayerView()
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
    }
    
}

struct PlayerView: View {
    @EnvironmentObject var partialSheetManager: PartialSheetManager
    @State var start: Double = 1
    
    var body: some View {
        makeBody()
    }
    
    private func makeBody() -> some View {
        
        ZStack {
            GeometryReader { geo in
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.green)
                HStack {
                    
                    //play button
                    playButton()
                        .frame(width: geo.size.width * 0.15,
                               height: geo.size.height)
                    //Vstack = timeFrames + stepper
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
    }
    
    
    private func playButton() -> some View {
        let buttonIcon = "play.fill"
        
        return Button(action: {
        }, label: {
            Image(systemName: buttonIcon)
                .resizable()
                .font(.system(size: 10))
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.black)
                .padding()
        })
    }
    
    
    
    private func slider() -> some View {
        Slider(value: $start, in: 1...100) {
    
        }
    }
    
    private func dateText() -> some View {
        let text = String(format: "%.0f", start)
        return Text("\(text)")
    }
    
    private func settingsButton() -> some View {
        let gearIcon = "gear"
        
        return Button(action: {
            self.partialSheetManager.showPartialSheet({
                
            }) {
                VStack {
                    Text("This is a Partial Sheet")
                }
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
    
    
}

