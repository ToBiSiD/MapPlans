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
    private(set) var realm: Realm?
    
    init() {
        print("Realm open")
        openRealm()
    }
    
    func openRealm() {
        do {
            let config = Realm.Configuration(schemaVersion: 1)
            
            Realm.Configuration.defaultConfiguration = config
            realm = try Realm()
            print(config.fileURL!)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    func fetchData<T: Object>() -> Results<T>? {
        print("Realm fetch")
        return realm?.objects(T.self)
    }
    
    func addData<T: Object>(data: T) {
        print("Realm add")
        if let realm = realm {
            do {
                try realm.write{
                    realm.add(data)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func updateData(completion: @escaping () -> Void ) {
        print("Realm update")
        if let realm = realm {
            do {
                try realm.write{
                    completion()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func removeData(id: ObjectId, completion: @escaping () -> Void ) {
        print("Realm remove")
        if let realm = realm {
            do {
                let plan = realm.objects(Plan.self).filter(NSPredicate(format: "id == %@", id))
                guard !plan.isEmpty else {return}
                
                try realm.write {
                    realm.delete(plan)
                    completion()
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func refresh()
    {
        if let realm = realm {
            realm.refresh()
        }
    }
    
}
