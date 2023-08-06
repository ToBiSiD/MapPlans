//
//  PlacePlansViewModel.swift
//  MapPlans
//
//  Created by Tobias on 02.08.2023.
//

import Foundation
import RealmSwift

class PlacePlansViewModel: ObservableObject {
    @Published var plans: [Plan]?
    let placeId: String
    
    private let realmService = RealmService()
    
    init(placeId: String) {
        self.placeId = placeId
        fetchPlacePlans()
    }
    
    private func fetchPlacePlans() {
        let allPlans: Results<Plan>? = realmService.fetchData()
        if let allPlans = allPlans {
            self.plans = Array(allPlans).filter { $0.placeId == self.placeId }
        }
    }
}
