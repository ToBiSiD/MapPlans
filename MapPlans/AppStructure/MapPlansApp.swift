//
//  MapPlansApp.swift
//  MapPlans
//
//  Created by Tobias on 01.08.2023.
//

import SwiftUI

@main
struct MapPlansApp: App {
    @StateObject var locationManager = LocationManager.shared
    private var notificationInitializer = NotificationInitializer()

    init() {
        @Provider var notificationService = NotificationService(notificationInitializer: notificationInitializer) as NotificationServiceProtocol
        @Provider var placesNetworkService = PlacesAPIService() as PlacesNetworkServiceProtocol
        @Provider var realmService = RealmService() as RealmStorageProtocol
        @Provider var placesCachingService = PlacesCacheService() as PlacesCacheServiceProtocol
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
