//
//  Navigation_Modifier.swift
//  SwiftUIWeatherApp
//
//  Created by AP Aliaksandr Chekushkin on 2/21/21.
//

import Foundation
import SwiftUI


extension View {
    
    /// Navigate to a new view.
    /// - Parameters:
    ///   - view: View to navigate to.
    ///   - binding: Only navigates when this condition is `true`.
    func navigate<NewView: View>(to view: NewView, when binding: Binding<Bool>) -> some View {
        let doneString = NSLocalizedString("done_key", comment: "")
        
        return NavigationView {
            ZStack {
                self
                    .navigationBarTitle(doneString)
                    .navigationBarHidden(true)
                NavigationLink(
                    destination: view
                        .navigationBarHidden(false)
                    ,
                    isActive: binding
                ) {
                    EmptyView()
                }
            }
        }
    }
}
