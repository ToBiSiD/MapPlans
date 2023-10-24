//
//  PlanSetupViewModel.swift
//  MapPlans
//
//  Created by Tobias on 02.08.2023.
//

import Foundation
import CoreLocation

class PlanSetupViewModel: ObservableObject {
    @Published var planTitle: String = ""
    @Published var planDescription: String = ""
    @Published var planState: PlanState = .toDo
    @Published var finishDate: Date = Date()
    
    @Published var notifyDate: Date = Date().dayBefore
    @Published var locationRadius: Int = 0
    
    @Published var plan: Plan? = nil
    @Inject private var placesCacheService: PlacesCacheServiceProtocol
    @Inject private var realmService: RealmStorageProtocol
    @Inject private var notificationService: NotificationServiceProtocol
    
    private var placeId: String
    
    init(plan: Plan? = nil, placeId: String) {
        self.plan = plan
        self.placeId = placeId
        setupPublishedParametrs()
    }
    
    private func setupPublishedParametrs() {
        if let plan = self.plan {
            planTitle = plan.title
            planDescription = plan.planDescription ?? ""
            planState = plan.planState
            finishDate = plan.finishDate ?? Date()
            
            for notification in plan.notifications {
                switch notification.notificationType {
                case .schedule:
                    if let date = notification.getSubInfo.date{
                        finishDate = date
                    }
                    break
                case .location:
                    if let radius = Int(notification.getSubInfo) {
                        locationRadius = radius
                    }
                    break
                }
            }
        }
    }
    
    func addPlan() {
        let createdPlan = Plan(title: planTitle, createDate: Date(), finishDate: finishDate, planDescription: planDescription, planState: planState.rawValue)
        self.plan = createdPlan
        setupNotificationData(notifications: createNotificationData(notifyAt: notifyDate, notifyRadius: locationRadius, placeId: placeId))
        placesCacheService.addPlan(createdPlan, for: placeId)
    }
    
    func updatePlan() {
        if let plan = plan {
            realmService.update {
                if !planTitle.isEmpty && planTitle != plan.title {
                    plan.title = planTitle
                }
                
                if finishDate != plan.finishDate && finishDate >= Date() {
                    plan.finishDate = finishDate
                }
                
                if let description = plan.planDescription, !planDescription.isEmpty && description != planDescription {
                    plan.planDescription = planDescription
                }
                
                if planState != plan.planState {
                    plan.planState = planState
                }
                
                setupNotificationData(notifications: createNotificationData(notifyAt: notifyDate, notifyRadius: locationRadius, placeId: placeId))
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
    
    private func createNotificationData(notifyAt: Date? = nil, notifyRadius: Int? = nil, placeId: String) -> [BaseNotification]? {
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
