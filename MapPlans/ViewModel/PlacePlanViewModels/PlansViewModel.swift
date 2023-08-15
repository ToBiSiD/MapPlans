//
//  PlansViewModel.swift
//  MapPlans
//
//  Created by Tobias on 02.08.2023.
//

import Foundation
import RealmSwift
import Combine

class PlansViewModel: ObservableObject {
    @Published var plans: [Plan]?
    let placeId: String?
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(placeId: String? = nil) {
        self.placeId = placeId
        subscribeOnRealmService()
    }
    
    private func subscribeOnRealmService() {
        RealmService.shared.fetchPlans().collectionPublisher
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }, receiveValue: { updatedPlans in
                self.updatePlans(Array(updatedPlans))
            })
            .store(in: &cancellables)
    }
    
    private func updatePlans(_ plans: [Plan]) {
        if let placeId = self.placeId {
            self.plans = plans.filter { $0.placeId == placeId }
        } else {
            self.plans = plans
        }
    }
    
    func removePlan(plan: Plan) {
        RealmService.shared.removePlan(plan)
    }
    
    func getInfo() -> String {
        if let plans = plans {
            let completedPlans = plans.filter({ $0.planState == .done })
            return "\(completedPlans.count)/\(plans.count)"
        } else {
            return ""
        }
    }
}

