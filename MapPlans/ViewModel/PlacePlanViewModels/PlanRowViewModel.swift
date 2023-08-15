//
//  PlanRowViewModel.swift
//  MapPlans
//
//  Created by Tobias on 05.08.2023.
//

import Foundation

class PlanRowViewModel: ObservableObject {
    @Published var plan: Plan

    init(plan: Plan){
        self.plan = plan
    }
    
    func updateState(state: PlanState) {
        RealmService.shared.updatePlan(plan, with: [PlanKeys.state : "\(state.rawValue)"])
    }
    
    func removePlan() {
        RealmService.shared.removePlan(plan)
    }
}
