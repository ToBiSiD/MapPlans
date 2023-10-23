//
//  NotificationOption.swift
//  MapPlans
//
//  Created by Tobias on 18.08.2023.
//

import Foundation

enum NotificationOption: String {
    case schedule = "schedule"
    case location = "location"
    case all = "all"
}

//MARK: - UICustomOption implementation
extension NotificationOption: UICustomOption {
    var defaultOption: any UICustomOption { return Self.schedule }
    
    var optionImage: String {
        switch self {
        case .schedule: return "calendar.circle"
        case .location: return "location.circle"
        case .all: return "ellipsis.circle"
        }
    }
    
    var optionTitle: String {
        switch self {
        case .schedule: return "Schedule notification"
        case .location: return "Location notification"
        case .all: return ""
        }
    }
}
