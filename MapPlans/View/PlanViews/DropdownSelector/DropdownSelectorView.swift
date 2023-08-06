//
//  DropdownSelectorView.swift
//  MapPlans
//
//  Created by Tobias on 05.08.2023.
//

import SwiftUI

struct DropdownSelectorView<Option : CustomOption>: View {
        @State private var shouldShowDropdown = false
        @State private var selectedOption: Option? = nil
        var defaultOption: Option
        var options: [Option]
        var onOptionSelected: ((_ option: Option) -> Void)?
        private let buttonHeight: CGFloat = 45

        var body: some View {
            Button(action: {
                withAnimation {
                    self.shouldShowDropdown.toggle()
                }
            }) {
                HStack {
                    HStack {
                        ZStack {
                            Circle()
                                .background(Color.gray)
                                .frame(width: 20)
                            
                            if let color = selectedOption?.optionColor {
                                Circle()
                                    .background(color)
                                    .frame(width: 16)
                            } else {
                                Circle()
                                    .background(defaultOption.optionColor)
                                    .frame(width: 16)
                            }
                        }
                        Text(selectedOption == nil ? defaultOption.optionTitle : selectedOption!.optionTitle)
                            .font(.system(size: 14))
                            .foregroundColor(selectedOption == nil ? Color.gray: Color.black)
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
            .frame(maxWidth: 150)
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

struct Dropdown<Option : CustomOption>: View {
    var options: [Option]
    var onOptionSelected: ((_ option: Option) -> Void)?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(self.options, id: \.self) { option in
                    DropdownRow(option: option, onOptionSelected: self.onOptionSelected)
                }
            }
        }
        .frame(height: 100)
        .padding(.vertical, 5)
        .background(Color.white)
        .cornerRadius(5)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.gray, lineWidth: 1)
        )
    }
}

struct DropdownRow<Option : CustomOption>: View {
    var option: Option
    var onOptionSelected: ((_ option: Option) -> Void)?

    var body: some View {
        Button(action: {
            if let onOptionSelected = self.onOptionSelected {
                onOptionSelected(self.option)
            }
        }) {
            HStack {
                Text(self.option.optionTitle)
                    .font(.system(size: 14))
                    .foregroundColor(Color.black)
                Spacer()
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 5)
    }
}
