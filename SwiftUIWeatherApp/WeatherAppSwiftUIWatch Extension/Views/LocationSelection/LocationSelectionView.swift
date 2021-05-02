//
//  LocationSelectionView.swift
//  WeatherAppSwiftUIWatch Extension
//
//  Created by AP Aliaksandr Chekushkin on 4/26/21.
//

import SwiftUI
import Marquee

struct LocationSelectionView: View {
    
    private static let fileName = "LocationsWeatherSwiftUI"
    @ObservedObject private var viewModel = LocationSelectionViewModel(fileName: "locations")
    
    private let locationsString = "Locations"
    @State var someTexts = ["Moscow","London"]
    
    private let cellHeight: CGFloat = 50
    private let addLocationString = NSLocalizedString("add_location_key", comment: "")
    
    @State var addLocationTapped = false
    
    
    var body: some View {
        makeBody()
    }
    
    
    private func makeBody() -> some View {
        VStack {
            List {
                ForEach (someTexts, id: \.self) { location in
                    LocationCard(location: location, height: cellHeight)
                        .padding(.leading)
                        .onLongPressGesture {
                            delete(location)
                        }
                }
               
                
                
                makeAddLocationButton()
                
            }
            
        }
        .navigationBarTitle(locationsString)
        .sheet(isPresented: $addLocationTapped, content: {
            LocationSelectionTextFieldView()
        })
        
    }
    
    private func makeAddLocationButton() -> some View {
        Button(action: {
            addLocationTapped.toggle()
        }, label: {
            HStack{
                Spacer()
                Text(addLocationString)
                    .font(Font.system(size: 24))
                    .foregroundColor(.blue)
                Spacer()
            }
        })
        .frame(height: cellHeight)
    }
    
    
    
    
    
    private func delete(_ item: String) {
        let index = someTexts.firstIndex(of: item)
        someTexts.remove(at: index!)
    }
    
    private func deleteRow(at indexSet: IndexSet) {
        self.someTexts.remove(atOffsets: indexSet)
    }
    
    
}

struct LocationCard: View {
    var location: String
    var height: CGFloat
    
    @State var durationValue: Double = 2
    
    var tempImage = "02d"
    var tempTemp = "25º"
    
    var body: some View {
        makeBody()
    }
    
    private func makeBody() -> some View {
        HStack {
            
            Marquee {
                Text(location)
                    .onAppear {
                        fireTimer()
                    }
            }
            .marqueeWhenNotFit(true)
            .marqueeDuration(durationValue)
              
            Spacer()
            WeatherImage(imageName: tempImage)
                .frame(height: height)
                .aspectRatio(contentMode: .fit)
            Text(tempTemp)
        }
        
    }
    
    
    //TO-DO:- make reasonable marquee text
    private func fireTimer() {
        let timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) {_ in
            if self.durationValue != 0 {
            self.durationValue = 0
            } else {
                durationValue = 2
            }
        }
        
        timer.fireDate = Date() + 3
        
    }
    
    
    
    
}


struct LocationSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSelectionView()
    }
}

