//
//  RealmService.swift
//  MapPlans
//
//  Created by Tobias on 01.08.2023.
//

import Foundation
import RealmSwift

protocol RealmStorageProtocol {
    func fetch<T: Object>() ->  Results<T>
    func addData(_ data: Object)
    func update(_ data: Object, with updates: [String: Any])
    func update(action: () -> Void)
    func remove(_ data: Object)
}

final class RealmService {
    private var realm: Realm
    
    init() {
        do {
            let config = Realm.Configuration(schemaVersion: 1)
            Realm.Configuration.defaultConfiguration = config
            realm = try Realm()
            DebugLogger.shared.printLog(realm.configuration.fileURL?.path ?? "")
        } catch {
            DebugLogger.shared.printLog(error.localizedDescription)
            fatalError()
        }
    }
}

//MARK: - Storage service protocol implementation
extension RealmService: RealmStorageProtocol {
    func fetch<T: Object>() -> Results<T> {
        return realm.objects(T.self)
    }
    
    func addData(_ data: Object) {
        do {
            try realm.write {
                realm.add(data)
            }
        } catch {
            DebugLogger.shared.printLog(error.localizedDescription)
        }
    }
    
    func update(action: () -> Void) {
        do {
            try realm.write {
                action()
            }
        } catch {
            DebugLogger.shared.printLog(error.localizedDescription)
        }
    }
    
    func update(_ data: Object, with updates: [String: Any]) {
        do {
            try realm.write {
                for (key, value) in updates {
                    data[key] = value
                }
            }
        } catch {
            DebugLogger.shared.printLog(error.localizedDescription)
        }
    }
    
    func remove(_ data: Object) {
        do {
            try realm.write {
                realm.delete(data)
            }
        } catch {
            DebugLogger.shared.printLog(error.localizedDescription)
        }
    }
}
