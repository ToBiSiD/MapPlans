//
//  PlanStateSwipeButtonView.swift
//  MapPlans
//
//  Created by Tobias on 08.08.2023.
//

import SwiftUI

struct PlanStateSwipeButtonView: View {
    @Binding var planState: PlanState
    let newState: PlanState
    
    var body: some View {
        Button() {
            planState = newState
        } label: {
            Label(newState.optionTitle, systemImage: newState.optionImage)
        }
        .tint(newState.optionColor)
    }
}
