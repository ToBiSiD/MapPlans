//
//  PlanSetupViewModel.swift
//  MapPlans
//
//  Created by Tobias on 02.08.2023.
//

import Foundation

class PlanSetupViewModel: ObservableObject {
    @Published var plan: Plan? = nil
    
    private let realmService = RealmService()
    
    init(plan: Plan? = nil) {
        self.plan = plan
    }
    
    func addPlan(title: String, finishDate: Date? = nil, placeId: String? = nil, planDescription : String? = nil, planState: PlanState = .toDo) {
        let plan = Plan(title: title,createDate: Date(), finishDate: finishDate, placeId: placeId,planDescription: planDescription, planState: planState.rawValue)
        realmService.addData(data: plan)
    }
    
    func updatePlan(title: String, finishDate: Date? = nil, planDescription : String? = nil, planState: PlanState? = nil) {
        
        if let plan = plan {
            realmService.updateData {
                if !title.isEmpty {
                    plan.title = title
                }
                
                if let finishDate = finishDate {
                    plan.finishDate = finishDate
                }
                
                if let description = planDescription {
                    plan.planDescription = description
                }
                
                if let planState = planState {
                    let prevValue = plan.planState
                    plan.planState = planState
                    if planState == .done || prevValue == .done {
                        MapViewModel.shared.updatePlanState(planId: plan.id)
                    }
                }
            }
        }
    }
    
    func removePlan() {
        if let plan = plan {
            let planId = plan.id
            realmService.removeData(id: planId) {
                MapViewModel.shared.removePlan(planId: planId)
                self.plan = nil
            }
        }
    }
}
