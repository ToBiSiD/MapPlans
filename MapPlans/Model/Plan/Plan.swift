//
//  Plan.swift
//  MapPlans
//
//  Created by Tobias on 01.08.2023.
//

import Foundation
import RealmSwift

class Plan: Object, ObjectKeyIdentifiable, Identifiable {
    @Persisted(primaryKey: true) var id : ObjectId
    @Persisted var title : String = ""
    @Persisted var createDate : Date?
    @Persisted var finishDate : Date?
    @Persisted var placeId : String?
    @Persisted var planDescription: String?
    @Persisted private var privatePlanState: String?
    
    var planState : PlanState {
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
    
    
    convenience init(title: String, createDate: Date? = nil, finishDate: Date? = nil, placeId: String? = nil, planDescription : String? = nil, planState: String = PlanState.toDo.rawValue) {
        
        self.init()
        self.title = title
        self.createDate = createDate
        self.finishDate = finishDate
        self.placeId = placeId
        self.planDescription = planDescription
        self.privatePlanState = planState
    }
}

extension Plan {
    static let MockPlan = Plan(title: "Title", createDate: Date(),finishDate: Date(), placeId: "unknown", planDescription: "description", planState: PlanState.done.rawValue)
}

