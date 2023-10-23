//
//  DropdownRow.swift
//  MapPlans
//
//  Created by Tobias on 08.08.2023.
//

import SwiftUI

struct DropdownRow: View {
    var option: PlanState
    var onOptionSelected: ((_ option: PlanState) -> Void)?

    var body: some View {
        Button(action: {
            if let onOptionSelected = self.onOptionSelected {
                onOptionSelected(self.option)
            }
        }) {
            HStack {
                PlanStateView(option: option)
                
                Spacer()
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 5)
    }
}

