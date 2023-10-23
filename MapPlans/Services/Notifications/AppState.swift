//
//  AppState.swift
//  MapPlans
//
//  Created by Tobias on 20.10.2023.
//

import Foundation

final class AppState: ObservableObject {
    static var shared = AppState()
    @Published var planId : String?
    @Published var placeId: String?
}
