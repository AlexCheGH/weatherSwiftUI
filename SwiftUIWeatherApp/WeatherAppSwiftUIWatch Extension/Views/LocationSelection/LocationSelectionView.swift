//
//  LocationSelectionView.swift
//  WeatherAppSwiftUIWatch Extension
//
//  Created by AP Aliaksandr Chekushkin on 4/26/21.
//

import SwiftUI
import Marquee

struct LocationSelectionView: View {
    
    @ObservedObject private var viewModel = LocationSelectionViewModel(fileName: "locations")
    
    @State var addLocationTapped = false
    @State var userInputedLocation = ""
    
    private let addLocationString = NSLocalizedString("add_location_key", comment: "")
    private let locationsString = NSLocalizedString("location_key", comment: "")
    
    private let cellHeight: CGFloat = 50
    
    var body: some View {
        makeBody()
    }
    
    private func makeBody() -> some View {
        VStack {
            List {
                ForEach (viewModel.locations, id: \.self) { location in
                    WeatherLocationCard(location: location,
                                        height: cellHeight)
                        .onLongPressGesture {
                            delete(location)
                        }
                        .padding(.leading)
                        
                }
                makeAddLocationButton()
            }
        }
        .navigationBarTitle(locationsString)
        .sheet(isPresented: $addLocationTapped, content: {
            LocationSelectionTextFieldView(userInput: $userInputedLocation, shouldDismiss: $addLocationTapped)
        })
        .onChange(of: userInputedLocation, perform: { value in
            value == "" ? () : viewModel.saveToDisk(item: value)
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
        guard let index = viewModel.locations.firstIndex(of: item) else { return }
        viewModel.deleteFromDisk(item: viewModel.locations[index])
    }
    
    //future implementation
    //    private func deleteRow(at indexSet: IndexSet) {
    //        self.someTexts.remove(atOffsets: indexSet)
    //    }
    
    
}

struct WeatherLocationCard: View {
    
    @ObservedObject var weather = WeatherViewModel()
    @State var durationValue: Double = 2
    
    var height: CGFloat
    
    init(location: String, height: CGFloat) {
        self.height = height
        self.weather = WeatherViewModel(location: location)
        self.weather.loadData()
    }
    
    var body: some View {
        makeBody()
    }
    
    private func makeBody() -> some View {
        GeometryReader { geo in
            HStack {
                Marquee {
                    Text(weather.location)
                        .onAppear {
                            fireTimer()
                        }
                }
                .marqueeWhenNotFit(true)
                .marqueeDuration(durationValue)
                .frame(width: geo.size.width * 0.5)
                
                WeatherImage(imageName: weather.currentWeather?.icon)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geo.size.width * 0.2)
                
                Text(weather.currentWeather?.currentTemp ?? "...")
                    .frame(width: geo.size.width * 0.2)
            }
        }
        .frame(height: height)
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

