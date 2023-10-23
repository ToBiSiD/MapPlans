//
//  NotificationService.swift
//  MapPlans
//
//  Created by Tobias on 21.08.2023.
//

import Foundation
import UserNotifications
import CoreLocation

protocol NotificationServiceProtocol {
    func setupNotifications(_ notifications: [BaseNotification],for plan: Plan)
    func cancelNotifications(ids: [String])
}

final class NotificationService {
    private let notificationInitializer: NotificationInitializerProtocol
    
    init(notificationInitializer: NotificationInitializerProtocol)
    {
        self.notificationInitializer = notificationInitializer
        setNotificationCategory()
    }
}

//MARK: - Setup NotificationService
extension NotificationService {
    private func setNotificationCategory(){
        let cancelAction = UNNotificationAction(identifier: AppConstants.cancelNotificationKey, title: "Cancel")
        let goToPlansAction = UNNotificationAction(identifier: AppConstants.goToPlansActionKey, title: "Go to plans")
        let plansCategory = UNNotificationCategory(identifier: AppConstants.plansCategoryKey, actions: [goToPlansAction,cancelAction], intentIdentifiers: [], options: .customDismissAction)
        notificationInitializer.addNotificationCategory(plansCategory)
    }
}

//MARK: - NotificationServiceProtocol implementation
extension NotificationService: NotificationServiceProtocol {
    func setupNotifications(_ notifications: [BaseNotification],for plan: Plan) {
        for notification in notifications {
            let content = UNMutableNotificationContent()
            content.title = notification.getNotificationTitle()
            content.body = notification.getNotificationBody()
            content.userInfo = [AppConstants.notificationPlaceInfoKey : plan.placeId ?? AppConstants.unknownPlaceId, AppConstants.notificationPlanInfoKey: plan.id]
            content.categoryIdentifier = AppConstants.plansCategoryKey
            
            plan.notifications.append(notification.getNotificationModel())
            let request = UNNotificationRequest(identifier: notification.notificationId(), content: content, trigger: notification.getTrigger())
            notificationInitializer.addNotificationRequest(request)
        }
    }
    
    func cancelNotifications(ids: [String]) {
        notificationInitializer.removeNotifications(ids: ids)
    }
}

