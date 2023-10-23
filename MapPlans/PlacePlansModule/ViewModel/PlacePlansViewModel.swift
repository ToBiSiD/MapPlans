//
//  PlansViewModel.swift
//  MapPlans
//
//  Created by Tobias on 02.08.2023.
//

import Foundation
import RealmSwift
import Combine

class PlacePlansViewModel: BasePlansViewModel {
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
/*
class PlansViewModel: ObservableObject {
    @Published var plans: [Plan]?
    let placeId: String?
    
    @Inject private var realmStorageService: RealmStorageProtocol
    @Inject private var cacheService: PlacesCacheServiceProtocol
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(placeId: String? = nil) {
        self.placeId = placeId
        subscribeOnRealmService()
    }
    
    func removePlan(plan: Plan) {
        cacheService.removePlan(plan, for: placeId ?? AppConstants.unknownPlaceId)
    }
}

//MARK: - Setup
extension PlansViewModel {
    private func subscribeOnRealmService() {
        realmStorageService.fetch().collectionPublisher
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    DebugLogger.shared.printLog(error.localizedDescription)
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
}

//MARK: - Computed properties
extension PlansViewModel {
    func getInfo() -> String {
        if let plans = plans {
            let completedPlans = plans.filter({ $0.planState == .done })
            return "\(completedPlans.count)/\(plans.count)"
        } else {
            return ""
        }
    }
}*/
