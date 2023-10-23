//
//  AppConstants.swift
//  MapPlans
//
//  Created by Tobias on 01.08.2023.
//

import Foundation

struct AppConstants {
    struct APIConstants {
        static let apiLink: String = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
        static let locationKey: String = "location"
        static let key: String = "key"
        static let radius: String = "radius"
    }
    
    static let searchRadius: Double = 300.0
    static let placeTypeExceptions: [String] = ["transit_station"]
    static let unknownPlaceId: String = "unknownPlaceId"
    
    static let locationNotificationId: String = "locationNotification"
    static let scheduleNotificationId: String = "scheduleNotification"
    
    static func getNotificationId(placeId: String, planId: String, isLocation: Bool) -> String{
        return "\(placeId)_\(isLocation ? Self.locationNotificationId : Self.scheduleNotificationId)_\(planId)";
    }
    static let notificationPlaceInfoKey: String = "PlaceId"
    static let notificationPlanInfoKey: String = "PlanId"
    
    static let plansCategoryKey: String = "PLANS"
    static let goToPlansActionKey: String = "GO_TO_PLANS"
    static let cancelNotificationKey: String = "CANCEL_NOTIFICATION"
}
