//
//  CheckListView.swift
//  SwiftUIWeatherApp
//
//  Created by AP Aliaksandr Chekushkin on 3/13/21.
//

import SwiftUI

struct ChecklistItem: Identifiable {
    let id = UUID()
    var name: String
    var isChecked: Bool = false
}

struct CheckList: View {
    @State var checklistItems: [ChecklistItem]
    @Binding var chosenOption: Int
    
    var body: some View {
        List {
            ForEach(checklistItems) { checklistItem in
                HStack {
                    Text(checklistItem.name)
                    Spacer()
                    Text(checklistItem.isChecked ? "✓" : "")
                }
                .background(Color.white) // makes the whole space clickable
                .onTapGesture {
                    let index = checklistItems.index(of: checklistItem)
                    toggleOffItems()
                    chooseItem(index: index)
                }
            }
        }
    }
   private func toggleOffItems() {
        checklistItems.forEach {
            let index = checklistItems.index(of: $0)
            
            if let index = index {
                checklistItems[index].isChecked = false
            }
        }
    }
    //changes selected row, changes @binding value
    private func chooseItem(index: Int?) {
        if let index = index {
            checklistItems[index].isChecked.toggle()
            chosenOption = index
        }
    }
}
