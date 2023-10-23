//
//  Place.swift
//  MapPlans
//
//  Created by Tobias on 12.09.2023.
//

import Foundation
import RealmSwift
import CoreLocation

class Place: Object, ObjectKeyIdentifiable, Identifiable {
    @Persisted(primaryKey: true) var placeId: String
    @Persisted var placeTitle: String
    @Persisted var placeLon: Double
    @Persisted var placeLat: Double
    @Persisted var imageUrl: String?
    @Persisted var plans: List<Plan>
    
    convenience init(id: String, title: String, lon: Double, lat: Double, imageUrl: String? = "") {
        self.init()
        
        self.placeId = id
        self.placeTitle = title
        self.placeLon = lon
        self.placeLat = lat
        self.imageUrl = imageUrl
    }
}

//MARK: - computed properties
extension Place {
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: placeLat, longitude: placeLon)
    }
    
    var completedPlans: Int {
        Array(plans).filter { $0.isCompleted }.count
    }
    
    var allPlans: Int {
        Array(plans).count
    }
}
