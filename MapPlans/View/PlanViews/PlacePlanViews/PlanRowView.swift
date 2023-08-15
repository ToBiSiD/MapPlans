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
    
    init(plan: Plan) {
        
        self.viewModel = PlanRowViewModel(plan: plan)
        self.planState = plan.planState
    }
    
    var body: some View {
        mainContent
            .swipeActions(allowsFullSwipe: false, content: {
                Button(role: .destructive) {
                    viewModel.removePlan()
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
                    if let placeId = viewModel.plan.placeId {
                        PlanSetupView(placeId: placeId, plan: viewModel.plan)
                    }
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
            .foregroundColor(ColorConstants.textColor)
            
            Spacer()
            
            PlanStateView(option: viewModel.plan.planState, isReverse: true)
        }
        .padding(.vertical, 10)
    }
}

struct PlanRowView_Previews: PreviewProvider {
    static var previews: some View {
        PlanRowView(plan: Plan.MockPlan)
    }
}
