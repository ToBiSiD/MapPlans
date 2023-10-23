//
//  LocationNotification.swift
//  MapPlans
//
//  Created by Tobias on 27.08.2023.
//

import Foundation
import CoreLocation
import UserNotifications

struct LocationNotification: BaseNotification {
    var plan: Plan
    var placeId: String
    var radius: Int
    var target: CLLocationCoordinate2D
    
    var notificationType: NotificationType { .location }
    var radiusDouble: Double { Double(radius) }
    func getNotificationBody() -> String { "\(plan.planDescription ?? "") in \(radius)m" }
    func notificationId() -> String { "\(placeId)_\(AppConstants.locationNotificationId)_\(planId)" }
    func getSubInfo() -> String { "\(radius)"}
    
    func getTrigger() -> UNNotificationTrigger {
        let notificationRegion = CLCircularRegion(center: target, radius: radiusDouble, identifier: notificationId())
        return UNLocationNotificationTrigger(region: notificationRegion, repeats: false)
    }
}
