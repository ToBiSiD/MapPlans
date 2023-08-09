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
            Button(action: {
                withAnimation {
                    self.shouldShowDropdown.toggle()
                }
            }) {
                HStack {
                    if let planState = (selectedOption != nil ? selectedOption : defaultOption) {
                        PlanStateView(option: planState)
                    }
                    
                    Spacer()

                    Image(systemName: self.shouldShowDropdown ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
                        .resizable()
                        .frame(width: 9, height: 5)
                        .font(Font.system(size: 9, weight: .medium))
                        .foregroundColor(Color.black)
                }
            }
            .padding(.horizontal)
            .cornerRadius(5)
            .frame(height: self.buttonHeight)
            .frame(maxWidth: 200)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 1)
            )
            .overlay(
                VStack {
                    if self.shouldShowDropdown {
                        Spacer(minLength: buttonHeight + 10)
                        Dropdown(options: self.options, onOptionSelected: { option in
                            shouldShowDropdown = false
                            selectedOption = option
                            self.onOptionSelected?(option)
                        } )
                    }
                }, alignment: .topLeading
            )
            .background(
                RoundedRectangle(cornerRadius: 5).fill(Color.white)
            )
        }
}
