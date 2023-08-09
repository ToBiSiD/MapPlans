//
//  PlanRowViewModel.swift
//  MapPlans
//
//  Created by Tobias on 05.08.2023.
//

import Foundation

class PlanRowViewModel: ObservableObject {
    @Published var plan: Plan
    
    private let realmService = RealmService()
    
    init(plan: Plan){
        self.plan = plan
    }
    
    func updateState(state: PlanState) {
        let prevValue = self.plan.planState
        if prevValue != state {
            realmService.updateData {
                self.plan.planState = state
                if self.plan.planState == .done || prevValue == .done {
                    MapViewModel.shared.updatePlanState(planId: self.plan.id)
                }
            }
        }
    }
}
