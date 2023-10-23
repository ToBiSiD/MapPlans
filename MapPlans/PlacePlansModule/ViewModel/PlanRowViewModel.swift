//
//  PlanRowViewModel.swift
//  MapPlans
//
//  Created by Tobias on 05.08.2023.
//

import Foundation

class PlanRowViewModel: ObservableObject {
    @Published var plan: Plan
    @Inject private var realmService: RealmStorageProtocol
    @Inject private var cacheService: PlacesCacheServiceProtocol

    init(plan: Plan){
        self.plan = plan
    }
    
    func updateState(state: PlanState) {
        realmService.update {
            plan.planState = state
        }
    }
    
    func removePlan() {
        cacheService.removePlan(plan, for: plan.place.first?.placeId ?? AppConstants.unknownPlaceId)
    }
}
