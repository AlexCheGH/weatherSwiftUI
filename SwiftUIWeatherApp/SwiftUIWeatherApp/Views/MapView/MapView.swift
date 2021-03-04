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
        }.onChange(of: coordinates, perform: { value in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                isMapTapped = false
            })
        })
    }
    
}

struct PlayerView: View {
    @EnvironmentObject var partialSheetManager: PartialSheetManager
    
    var body: some View {
        makeBody()
    }
    
    
    
    
    
    
    private func makeBody() -> some View {
        
        ZStack {
            
            RoundedRectangle(cornerRadius: 10).foregroundColor(.green)
            
            HStack {
                
                //play button
                playButton().padding(.leading)
                
                //Vstack = timeFrames + stepper
                VStack {
                    dateText()
                    slider()
                }
                
                settingsButton()
            }
        }
    }
    
    
    
    private func playButton() -> some View {
        Button(action: {
        }, label: {
            Image(systemName: "play.fill").foregroundColor(.black)
        })
    }
    
    
    @State var start: Double = 1
    private func slider() -> some View {
    
    
        
        Slider(value: $start, in: 1...100) {
            
        }
    }
    
    private func dateText() -> some View {
        Text("dummy")
    }
    
    
    private func settingsButton() -> some View {
        Button(action: {
            self.partialSheetManager.showPartialSheet({
                
            }) {
                VStack {
                    Text("This is a Partial Sheet")
                }
            }
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.blue)
                Image(systemName: "gear")
                    .font(.system(size: 15))
                    .foregroundColor(.black)
            }
        })
    }
    
    
}

