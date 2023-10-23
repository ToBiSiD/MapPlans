//
//  ScheduleNotification.swift
//  MapPlans
//
//  Created by Tobias on 27.08.2023.
//

import Foundation
import UserNotifications

struct ScheduleNotification: BaseNotification {
    var plan: Plan
    var placeId: String
    var notificationDate: Date
    var notificationType: NotificationType { .schedule }
    
    func getNotificationBody() -> String { "\(plan.planDescription ?? "") -> \(formattedNotificationDate)" }
    
    var formattedNotificationDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: notificationDate)
    }
    
    func getSubInfo() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: notificationDate)
        return dateString
    }
    
    func getTrigger() -> UNNotificationTrigger {
        let dateComponents = Calendar.current
            .dateComponents([.year, .month, .day, .hour, .minute], from: notificationDate)
        
        return UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
    }
}

