//
//  NotificationModel.swift
//  MapPlans
//
//  Created by Tobias on 12.09.2023.
//

import Foundation
import RealmSwift

class NotificationModel: Object, ObjectKeyIdentifiable, Identifiable {
    @Persisted(primaryKey: true) var notificationId: String
    @Persisted private var notificationTypeValue: String
    @Persisted private var subInfo: String
    
    @Persisted(originProperty: "notifications") var plan: LinkingObjects<Plan>
    
    convenience init(notification: BaseNotification) {
        self.init()
        
        self.notificationId = notification.notificationId()
        self.notificationTypeValue = notification.notificationType.rawValue
        self.subInfo = notification.getSubInfo()
    }
}

//MARK: - computed properties
extension NotificationModel {
    var notificationType: NotificationType {
        if let result = NotificationType(rawValue: notificationTypeValue){
            return result
        }
        return .location
    }
    
    var placeId: String? {
        plan.first?.placeId
    }
    
    var planId: String? {
        plan.first?.planId
    }
    
    var getSubInfo: String {
        subInfo
    }
}
