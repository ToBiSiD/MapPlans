//
//  Dropdown.swift
//  MapPlans
//
//  Created by Tobias on 08.08.2023.
//

import SwiftUI

struct Dropdown: View {
    var options: [PlanState]
    var onOptionSelected: ((_ option: PlanState) -> Void)?

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
        .background(ColorConstants.backgroundColor)
        .cornerRadius(ValueConstants.defaultCornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: ValueConstants.defaultCornerRadius)
                .stroke(ColorConstants.shadowColor, lineWidth: 1)
        )
    }
}
