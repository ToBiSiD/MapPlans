//
//  DependencyInjector.swift
//  MapPlans
//
//  Created by Tobias on 13.10.2023.
//

import Foundation

struct DependencyInjector {
    private static var dependencies: [String: Any] = [:]
    
    static func resolve<T>() -> T {
        guard let t = dependencies[String(describing: T.self)] as? T else {
            DebugLogger.shared.printLog("No dependency in dictionary for \(T.self)")
            fatalError()
        }
        
        return t
    }
    
    static func register<T>(_ dependecy: T) {
        dependencies[String(describing: T.self)] = dependecy
    }
}

@propertyWrapper struct Inject<T> {
    var wrappedValue: T
    
    init() {
        self.wrappedValue = DependencyInjector.resolve()
        DebugLogger.shared.printLog("Injected \(self.wrappedValue)")
    }
}

@propertyWrapper struct Provider<T> {
    var wrappedValue: T
    
    init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
        DependencyInjector.register(wrappedValue)
        DebugLogger.shared.printLog("Provide \(self.wrappedValue)")
    }
}
