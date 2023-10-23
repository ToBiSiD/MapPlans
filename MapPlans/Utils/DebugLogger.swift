//
//  DebugLogger.swift
//  MapPlans
//
//  Created by Tobias on 11.10.2023.
//

import Foundation

final class DebugLogger {
    static let shared = DebugLogger()
    
    func printLog(_ text: String) {
        print(text)
    }
}

