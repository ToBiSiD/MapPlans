//
//  BasePlansViewModel.swift
//  MapPlans
//
//  Created by Tobias on 23.10.2023.
//

import Foundation
import RealmSwift
import Combine

class BasePlansViewModel: ObservableObject {
    @Published var plans: [Plan]?
    @Published var progressText: String?
    
    @Inject private var realmStorageService: RealmStorageProtocol
    @Inject private var cacheService: PlacesCacheServiceProtocol
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        subscribeOnRealmService()
    }
    
    func onUpdatePlans(_ plans: [Plan]) {
    }
    
    private func updateProgressText() {
        if let plans = plans {
            let completedPlans = plans.filter({ $0.planState == .done })
            progressText = "\(completedPlans.count)/\(plans.count)"
        } else {
            progressText = nil
        }
    }
    
    func removePlanFromCache(plan: Plan, for placeId: String) {
        cacheService.removePlan(plan, for: placeId)
    }
}

extension BasePlansViewModel {
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
        onUpdatePlans(plans)
        updateProgressText()
    }
}
