//
//  PlanRowView.swift
//  MapPlans
//
//  Created by Tobias on 02.08.2023.
//

import SwiftUI

struct PlanRowView: View {
    @ObservedObject var viewModel: PlanRowViewModel
    
    init(plan: Plan) {
        viewModel = PlanRowViewModel(plan: plan)
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(viewModel.plan.title)
                if let description = viewModel.plan.planDescription {
                    Text(description)
                }
            }
            
            Spacer()
            
            HStack(alignment: .center) {
                Spacer()
                
               /* if let options = PlanState.allCases as? [PlanState] {
                    
                    DropdownSelectorView(placeholder: viewModel.planState, options: options) { option in
                        viewModel.planState = option
                    }
                }*/
            }
        }
    }
}

struct PlanRowView_Previews: PreviewProvider {
    static var previews: some View {
        PlanRowView(plan: Plan.MockPlan)
    }
}
