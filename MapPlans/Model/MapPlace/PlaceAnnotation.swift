//
//  PlaceAnnotation.swift
//  MapPlans
//
//  Created by Tobias on 01.08.2023.
//

import Foundation
import CoreLocation
import MapKit

class PlaceAnnotation : NSObject, MKAnnotation, Identifiable {
    let id = UUID()
    var name: String?
    var placeDescription: String?
    var coordinate: CLLocationCoordinate2D
    var image: String?
    var placeId: String?
    var completedPlans: Int
    var plans: Int
    
    init(name: String? = nil, placeDescription: String? = nil, coordinate: CLLocationCoordinate2D, image: String? = nil, placeId: String? = nil, completedPlans: Int = 0, plans:Int = 0) {
        self.name = name
        self.placeDescription = placeDescription
        self.coordinate = coordinate
        self.image = image
        self.placeId = placeId
        self.completedPlans = completedPlans
        self.plans = plans
        
        super.init()
    }
    
    var title: String? {
        return name
    }
    
    override var description: String {
        return placeDescription ?? ""
    }
    
    var plansProgress: String {
        return "Completed plans: \(completedPlans)/\(plans)"
    }
    
    var plansProgressValue: Double {
        return Double(completedPlans)/Double(plans)
    }
    
}

extension PlaceAnnotation {
    static let MockAnnotation = PlaceAnnotation(name: "Mock Annotation",placeDescription: "Mock annotation place description",coordinate: CLLocationCoordinate2D(latitude: 37.33459999999999, longitude: -122.00919999999999),placeId: "___", completedPlans: 5, plans: 7)
}
