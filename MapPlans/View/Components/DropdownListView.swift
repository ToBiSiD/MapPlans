//
//  DropdownListView.swift
//  MapPlans
//
//  Created by Tobias on 05.08.2023.
//

import SwiftUI

struct DropdownListView<Option : CustomOption> : View {
    @Binding var selectedOption: Option
    @State private var isOpen: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    withAnimation {
                        isOpen.toggle()
                    }
                } label: {
                    HStack{
                        Text(selectedOption.optionTitle)
                            .padding(.horizontal)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.down")
                            .rotationEffect(.degrees( isOpen ? -180 : 0))
                            .padding(.horizontal)
                    }
                    //.foregroundColor(ColorConstants.buttonTextColor)
                    .frame(height: 44)
                }
            }
            
            if isOpen {
                dropdownListView
                    .padding(.vertical)
            }
        }
        //.background(ColorConstants.disableButtonColor)
        .cornerRadius(15)
        //.shadow(color: ColorConstants.shadowColor, radius: 8)
        .padding(.horizontal)
    }
    
    private var dropdownListView: some View {
        VStack(spacing: 12) {
            if let allCases = Option.allCases as? [Option] {
                ForEachCustomOptionView(data: allCases) { option in
                    DropdownListRow(title: option.optionTitle, isSelected: isSelected(option)) {
                        selectOption(option)
                    }
                }
            }
        }
    }
    
    private func selectOption(_ option: Option){
        if !isSelected(option) {
            selectedOption = option
        }
    }
    
    private func isSelected(_ option: Option) -> Bool {
        return selectedOption == option
    }
}

