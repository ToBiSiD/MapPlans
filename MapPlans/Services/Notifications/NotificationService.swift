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

final class NotificationService: NSObject {
    static var shared = NotificationService()
    private let notificationCenter = UNUserNotificationCenter.current()
    
    override init()
    {
        super.init()
        setupNotificationCenter()
    }
}

//MARK: - Setup NotificationService
extension NotificationService {
    private func setupNotificationCenter() {
        notificationCenter.delegate = self
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                DebugLogger.shared.printLog("All set!")
            } else if let error = error {
                DebugLogger.shared.printLog(error.localizedDescription)
            }
        }
        
        notificationCenter.removeAllDeliveredNotifications()
        
        setNotificationCategory()
    }
    
    private func setNotificationCategory(){
        let cancelAction = UNNotificationAction(identifier: AppConstants.cancelNotificationKey, title: "Cancel")
        let goToPlansAction = UNNotificationAction(identifier: AppConstants.goToPlansActionKey, title: "Go to plans")
        let plansCategory = UNNotificationCategory(identifier: AppConstants.plansCategoryKey, actions: [goToPlansAction,cancelAction], intentIdentifiers: [], options: .customDismissAction)
        notificationCenter.setNotificationCategories([plansCategory])
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
            
            var trigger = notification.getTrigger()
            if let locationNotification = notification as? LocationNotification {
                //plan.notifyRadius = locationNotification.radius
            } else if let scheduleNotification = notification as? ScheduleNotification {
                //plan.notifyDate = scheduleNotification.notificationDate
            }
            
            let request = UNNotificationRequest(identifier: notification.notificationId(), content: content, trigger: trigger)
            notificationCenter.add(request)
        }
    }
    
    func cancelNotifications(ids: [String]) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: ids)
    }
}

class AppState: ObservableObject {
    static var shared = AppState()
    @Published var planId : String?
    @Published var placeId: String?
}


//MARK: - UNUserNotificationCenterDelegate implementation
extension NotificationService : UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let info = response.notification.request.content.userInfo
        
        if response.notification.request.content.categoryIdentifier == AppConstants.plansCategoryKey {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                DebugLogger.shared.printLog("Dispatch")
                AppState.shared.placeId = info[AppConstants.notificationPlaceInfoKey] as? String
                AppState.shared.planId = info[AppConstants.notificationPlanInfoKey] as? String
                
                switch response.actionIdentifier{
                case "ACCEPT_ACTION":
                    DebugLogger.shared.printLog("Accept for: \(AppState.shared.planId) in \(AppState.shared.placeId)")
                    break
                case "DECLINE_ACTION":
                    DebugLogger.shared.printLog("Decline foe: \(AppState.shared.planId) in \(AppState.shared.placeId)")
                    break
                default:
                    break
                }
            }
        }
    }
}

