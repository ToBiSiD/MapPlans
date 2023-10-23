//
//  PlansViewModel.swift
//  MapPlans
//
//  Created by Tobias on 02.08.2023.
//

import Foundation
import RealmSwift
import Combine

final class PlacePlansViewModel: BasePlansViewModel {
    let placeId: String
    
    init(placeId: String) {
        self.placeId = placeId
        super.init()
    }
    
    func removePlan(plan: Plan) {
        removePlanFromCache(plan: plan, for: placeId)
    }
    
    override func onUpdatePlans(_ plans: [Plan]) {
        self.plans = plans.filter { $0.placeId == placeId }
    }
}
