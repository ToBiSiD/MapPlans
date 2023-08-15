//
//  PlanSetupViewModel.swift
//  MapPlans
//
//  Created by Tobias on 02.08.2023.
//

import Foundation

class PlanSetupViewModel: ObservableObject {
    @Published var plan: Plan? = nil

    init(plan: Plan? = nil) {
        self.plan = plan
    }
    
    func addPlan(title: String, finishDate: Date? = nil, placeId: String? = nil, planDescription : String? = nil, planState: PlanState = .toDo) {
        
        let plan = Plan(title: title,createDate: Date(), finishDate: finishDate, placeId: placeId,planDescription: planDescription, planState: planState.rawValue)
        RealmService.shared.addPlan(plan)
    }
    
    func updatePlan(title: String, finishDate: Date? = nil, planDescription : String? = nil, planState: PlanState? = nil) {
        
        if let plan = plan {
            var updatedValues: [String : Any] = [:]
            if !title.isEmpty {
                updatedValues[PlanKeys.title] = title
            }
            
            if let finishDate = finishDate {
                updatedValues[PlanKeys.finishDate] = finishDate
            }
            
            if let description = planDescription, !description.isEmpty {
                updatedValues[PlanKeys.description] = description
            }
            
            if let planState = planState {
                updatedValues[PlanKeys.state] = planState.rawValue
            }
            
            RealmService.shared.updatePlan(plan, with: updatedValues)
        }
    }
    
    func removePlan() {
        if let plan = plan {
            RealmService.shared.removePlan(plan)
        }
    }
}
