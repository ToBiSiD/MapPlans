//
//  PlaceData.swift
//  MapPlans
//
//  Created by Tobias on 02.08.2023.
//

import Foundation
import CoreLocation

struct PlaceData: Identifiable {
    var placeId: String
    var name: String
    var lat: Double
    var lng: Double
    var imageUrl: String?
    var plans: [Plan] = []
    
    var id: String {
        return placeId
    }
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }
}
