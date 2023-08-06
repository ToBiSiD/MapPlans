//
//  PlaceData.swift
//  MapPlans
//
//  Created by Tobias on 02.08.2023.
//

import Foundation

struct PlaceData: Identifiable {
    var placeId: String
    var name: String
    var lat: Double
    var lng: Double
    
    var plans: [Plan] = []
    
    var id: String {
        return placeId
    }
    
}
