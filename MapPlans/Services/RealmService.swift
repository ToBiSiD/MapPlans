//
//  RealmService.swift
//  MapPlans
//
//  Created by Tobias on 01.08.2023.
//

import Foundation
import RealmSwift

class RealmService {
    public static var shared = RealmService()
    private var realm: Realm
    
    init() {
        do {
            let config = Realm.Configuration(schemaVersion: 1)
            Realm.Configuration.defaultConfiguration = config
            realm = try Realm()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func fetchPlans() -> Results<Plan> {
        return realm.objects(Plan.self)
    }
    
    func addPlan(_ plan: Plan) {
        do {
            try realm.write{
                realm.add(plan)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updatePlan(_ plan: Plan, with updates: [String: Any]){
        do {
            try realm.write {
                for (key, value) in updates {
                    plan[key] = value
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func removePlan(_ plan: Plan) {
        do {
            try realm.write {
                realm.delete(plan)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
