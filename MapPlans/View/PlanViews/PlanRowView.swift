//
//  PlanRowView.swift
//  MapPlans
//
//  Created by Tobias on 02.08.2023.
//

import SwiftUI

struct PlanRowView: View {
    @ObservedObject var viewModel: PlanRowViewModel
    @State var planState: PlanState
    let placeId: String
    
    init(plan: Plan, placeId: String) {
        self.viewModel = PlanRowViewModel(plan: plan)
        self.placeId = placeId
        self.planState = plan.planState
    }
    
    var body: some View {
        mainContent
            .swipeActions(allowsFullSwipe: false, content: {
                Button(role: .destructive) {
                    MapViewModel.shared.removePlan(planId: viewModel.plan.id)
                } label: {
                    Label("Remove", systemImage: "trash.fill")
                }
                
                PlanStateSwipeButtonView(planState: $planState, newState: .toDo)
                    .disabled(planState == .toDo)
                
                PlanStateSwipeButtonView(planState: $planState, newState: .inProgress)
                    .disabled(planState == .inProgress)
                
                PlanStateSwipeButtonView(planState: $planState, newState: .done)
                    .disabled(planState == .done)
            })
            .overlay {
                NavigationLink {
                    PlanSetupView(placeId: placeId, plan: viewModel.plan)
                } label: {

                }
            }
            .onChange(of: planState) { newValue in
                viewModel.updateState(state: planState)
            }
    }
    
    var mainContent: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(viewModel.plan.title)
                if let description = viewModel.plan.planDescription {
                    Text(description)
                }
            }
            
            Spacer()
            
            PlanStateView(option: viewModel.plan.planState, isReverse: true)
        }
    }
}

struct PlanRowView_Previews: PreviewProvider {
    static var previews: some View {
        PlanRowView(plan: Plan.MockPlan, placeId: "")
    }
}
