//
//  Plan.swift
//  MapPlans
//
//  Created by Tobias on 01.08.2023.
//

import Foundation
import RealmSwift
import CoreLocation

class Plan: Object, ObjectKeyIdentifiable, Identifiable {
    @Persisted(primaryKey: true) var planId: String
    @Persisted var title: String = ""
    @Persisted var createDate: Date?
    @Persisted var finishDate: Date?
    @Persisted var planDescription: String?
    @Persisted private(set) var privatePlanState: String?
    
    var planState: PlanState {
        get {
            if let state = privatePlanState {
                return PlanState(rawValue: state)!
            } else {
                privatePlanState = PlanState.toDo.rawValue
                return PlanState.toDo
            }
        }
        set { privatePlanState = newValue.rawValue }
    }
    
    //Relationship properties
    @Persisted var notifications: List<NotificationModel>
    @Persisted(originProperty: "plans") var place: LinkingObjects<Place>
    
    convenience init(title: String, createDate: Date? = nil, finishDate: Date? = nil, planDescription : String? = nil, planState: String = PlanState.toDo.rawValue) {
        
        self.init()
        self.planId = ObjectId.generate().stringValue
        DebugLogger.shared.printLog("planId: \(self.planId)")
        self.title = title
        self.createDate = createDate
        self.finishDate = finishDate
        self.planDescription = planDescription
        self.privatePlanState = planState
    }
}

//MARK: - computed properties
extension Plan {
    var placeId: String? {
        place.first?.placeId
    }
    
    var isCompleted: Bool {
        return planState == .done
    }
}

//MARK: - Mock plan
extension Plan {
    static let MockPlan = Plan(title: "Title", createDate: Date(),finishDate: Date(), planDescription: "description", planState: PlanState.done.rawValue)
}

