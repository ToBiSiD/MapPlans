//
//  NotificationServiceHandler.swift
//  MapPlans
//
//  Created by Tobias on 20.10.2023.
//

import Foundation
import UserNotifications

protocol NotificationInitializerProtocol {
    func addNotificationCategory(_ category: UNNotificationCategory)
    func addNotificationRequest(_ request: UNNotificationRequest)
    func removeNotifications(ids: [String])
}

final class NotificationInitializer: NSObject {
    private let notificationCenter = UNUserNotificationCenter.current()
    
    override init() {
        super.init()
        setupNotificationCenter()
    }
}

//MARK: - Setup
private extension NotificationInitializer {
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
    }
}

//MARK: - NotificationInitializerProtocol implementation
extension NotificationInitializer: NotificationInitializerProtocol {
    func addNotificationCategory(_ category: UNNotificationCategory) {
        notificationCenter.setNotificationCategories([category])
    }
    
    func addNotificationRequest(_ request: UNNotificationRequest) {
        notificationCenter.add(request)
    }
    
    func removeNotifications(ids: [String]) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: ids)
    }
}

//MARK: - UNUserNotificationCenterDelegate implementation
extension NotificationInitializer: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let info = response.notification.request.content.userInfo
        let identifier = response.notification.request.content.categoryIdentifier
        
        switch identifier {
        case AppConstants.plansCategoryKey:
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                AppState.shared.placeId = info[AppConstants.notificationPlaceInfoKey] as? String
                AppState.shared.planId = info[AppConstants.notificationPlanInfoKey] as? String
                
                switch response.actionIdentifier {
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
            break
        default: break
        }
        
    }
}
