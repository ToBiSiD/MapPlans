//
//  PlanSetupViewModel.swift
//  MapPlans
//
//  Created by Tobias on 02.08.2023.
//

import Foundation
import CoreLocation

class PlanSetupViewModel: ObservableObject {
    @Published var plan: Plan? = nil
    @Inject private var placesCacheService: PlacesCacheServiceProtocol
    @Inject private var realmService: RealmStorageProtocol
    @Inject private var notificationService: NotificationServiceProtocol
    
    init(plan: Plan? = nil) {
        self.plan = plan
    }
    
    func addPlan(title: String, finishDate: Date? = nil, placeId: String? = nil, planDescription : String? = nil, planState: PlanState = .toDo, placeCoordinate: CLLocationCoordinate2D, notifyAt: Date? = nil, notifyRadius: Int? = nil) {
        
        let createdPlan = Plan(title: title,createDate: Date(), finishDate: finishDate,planDescription: planDescription, planState: planState.rawValue)
        self.plan = createdPlan
        setupNotificationData(notifications: createNotificationData(notifyAt: notifyAt, notifyRadius: notifyRadius, placeId: placeId ?? AppConstants.unknownPlaceId))
        
        if let placeId = placeId {
            placesCacheService.addPlan(createdPlan, for: placeId)
        }
    }
    
    func updatePlan(title: String, finishDate: Date? = nil, planDescription : String? = nil, planState: PlanState? = nil, notifications: [BaseNotification]? = nil) {
        
        if let plan = plan {
            realmService.update {
                if !title.isEmpty {
                    plan.title = title
                }
                
                if let finishDate = finishDate {
                    plan.finishDate = finishDate
                }
                
                if let description = planDescription, !description.isEmpty {
                    plan.planDescription = description
                }
                
                if let planState = planState {
                    plan.planState = planState
                }
                setupNotificationData(notifications: notifications)
            }
        }
    }
    
    func removePlan() {
        if let plan = plan {
            placesCacheService.removePlan(plan, for: plan.placeId ?? AppConstants.unknownPlaceId)
        }
    }
    
    private func setupNotificationData(notifications: [BaseNotification]?) {
        if let notifications = notifications, let plan = plan {
            notificationService.cancelNotifications(ids: plan.notifications.map({ $0.notificationId }))
            notificationService.setupNotifications(notifications, for: plan)
        }
    }
    
    func createNotificationData(notifyAt: Date? = nil, notifyRadius: Int? = nil, placeId: String) -> [BaseNotification]? {
        if let plan = plan {
            var notifications: [BaseNotification] = []
            if let notifyAt = notifyAt, notifyAt > plan.createDate ?? Date() {
                notifications.append(ScheduleNotification(plan: plan, placeId: placeId, notificationDate: notifyAt))
            }
            
            if let notifyRadius = notifyRadius, let place = plan.place.first?.coordinate {
                notifications.append(LocationNotification(plan: plan, placeId: placeId, radius: notifyRadius, target: place))
            }
            
            return notifications
        }
        return nil
    }
}
