//
//  PlanRowViewModel.swift
//  MapPlans
//
//  Created by Tobias on 05.08.2023.
//

import Foundation

class PlanRowViewModel: ObservableObject {
    let plan: Plan
    @Published var planState: PlanState
    {
        didSet {
            updateState(state: planState)
        }
    }
    
    private let realmService = RealmService()
    
    init(plan: Plan){
        self.plan = plan
        planState = plan.planState
    }
    
    func updateState(state: PlanState) {
        realmService.updateData {
            let prevValue = self.plan.planState
            if self.planState == .done || prevValue == .done {
                MapViewModel.shared.updatePlanState(planId: self.plan.id)
            }
        }
    }
}
