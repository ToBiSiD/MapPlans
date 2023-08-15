//
//  DropdownSelectorView.swift
//  MapPlans
//
//  Created by Tobias on 05.08.2023.
//

import SwiftUI

struct DropdownSelectorView: View {
        @State private var shouldShowDropdown = false
        @State private var selectedOption: PlanState? = nil
        var defaultOption: PlanState
        var options: [PlanState]
        var onOptionSelected: ((_ option: PlanState) -> Void)?
        private let buttonHeight: CGFloat = 45

        var body: some View {
            
            Button {
                withAnimation {
                    self.shouldShowDropdown.toggle()
                }
            } label: {
                ZStack {
                    RoundedBackgroundView()
                    
                    HStack {
                        if let planState = (selectedOption != nil ? selectedOption : defaultOption) {
                            PlanStateView(option: planState)
                        }
                        
                        Spacer()

                        Image(systemName: self.shouldShowDropdown ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
                            .resizable()
                            .frame(width: 9, height: 5)
                            .font(Font.system(size: 9, weight: .medium))
                            .foregroundColor(ColorConstants.textColor)
                    }
                    .padding(.horizontal)
                    
                }
                .frame(height: self.buttonHeight)
                .frame(maxWidth: 200)
                .overlay(
                    dropdown, alignment: .topLeading
                )
            }
        }
    
    var dropdown : some View {
        VStack {
            if self.shouldShowDropdown {
                Spacer(minLength: buttonHeight + 10)
                Dropdown(options: self.options, onOptionSelected: { option in
                    shouldShowDropdown = false
                    selectedOption = option
                    self.onOptionSelected?(option)
                } )
            }
        }
        .shadow(color: ColorConstants.shadowColor, radius: ValueConstants.defaultShadowRadius)
    }
}


struct DropdownSelectorView_Previews : PreviewProvider {
    static var previews: some View {
        DropdownSelectorView(defaultOption: PlanState.toDo, options: [PlanState.toDo, PlanState.inProgress , PlanState.done])
    }
}
