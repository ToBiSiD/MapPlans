//
//  MapPlansApp.swift
//  MapPlans
//
//  Created by Tobias on 01.08.2023.
//

import SwiftUI

@main
struct MapPlansApp: App {
    @StateObject var locationManager = LocationManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
