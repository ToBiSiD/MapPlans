//
//  AllPlansViewModel.swift
//  MapPlans
//
//  Created by Tobias on 23.10.2023.
//

import Foundation

final class AllPlansViewModel: BasePlansViewModel {
    override func onUpdatePlans(_ plans: [Plan]) {
        self.plans = plans
    }
    
    func removePlan(_ plan: Plan) {
        removePlanFromCache(plan: plan, for: plan.placeId ?? AppConstants.unknownPlaceId)
    }
}
