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
    var buttonHeight: CGFloat = 45
    var onOptionSelected: ((_ option: PlanState) -> Void)?
    
    var body: some View {
        VStack {
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
            }
            
            dropdown
        }
        .frame(maxWidth: 200)
    }
    
    var dropdown : some View {
        HStack {
            if self.shouldShowDropdown {
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


