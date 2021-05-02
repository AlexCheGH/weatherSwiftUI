//
//  LocationSelectionTextFieldView.swift
//  WeatherAppSwiftUIWatch Extension
//
//  Created by AP Aliaksandr Chekushkin on 5/2/21.
//

import SwiftUI

struct LocationSelectionTextFieldView: View {
    
    @State var userInput = ""
    
    private let enterLocationString = NSLocalizedString("location_placeholder", comment: "")
    private let doneString = NSLocalizedString("done_key", comment: "")
    private let closeString = NSLocalizedString("close_key", comment: "")
    private let textGuideString = NSLocalizedString("input_you_location_textField_watch_key", comment: "")
    
    var body: some View {
        makeBody()
    }
    
    
    private func makeBody() -> some View {
        VStack {
            TextField(enterLocationString, text: $userInput)
            Spacer()
            
            Text(textGuideString)
                .multilineTextAlignment(.center)
            Spacer()
            HStack {
                Button(doneString) {
                    print("done")
                }
                .buttonStyle(BorderedButtonStyle(tint: .blue))
                .disabled( userInput == "" ? true : false )
            }
        }
    }
}


struct LocationSelectionTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSelectionTextFieldView()
    }
}
