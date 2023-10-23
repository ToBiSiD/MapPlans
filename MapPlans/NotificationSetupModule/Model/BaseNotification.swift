//
//  BaseNotification.swift
//  MapPlans
//
//  Created by Tobias on 27.08.2023.
//

import Foundation
import UserNotifications

protocol BaseNotification {
    var plan: Plan { get set }
    var placeId: String { get set }
    var notificationType: NotificationType { get }
    
    func notificationId() -> String
    func getNotificationTitle() -> String
    func getNotificationBody() -> String
    func getSubInfo() -> String
    func getTrigger() -> UNNotificationTrigger
    func getNotificationModel() -> NotificationModel
}

extension BaseNotification {
    var placeId: String { plan.place.first?.placeId ?? AppConstants.unknownPlaceId }
    var planId: String { "\(plan.planId)" }
    var notificationType: NotificationType { .location }
    
    func notificationId() -> String { "\(placeId)_\(AppConstants.scheduleNotificationId)_\(planId)" }
    func getNotificationTitle() -> String { plan.title }
    func getNotificationBody() -> String { plan.planDescription ?? "" }
    func getSubInfo() -> String { "sub info"}
    func getNotificationModel() -> NotificationModel { NotificationModel(notification: self)}
}
