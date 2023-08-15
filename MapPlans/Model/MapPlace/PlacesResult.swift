//
//  PlacesResult.swift
//  MapPlans
//
//  Created by Tobias on 01.08.2023.
//

import Foundation
import CoreLocation

struct PlacesResult: Codable {
    var results: [SearchResult]
    var status: String
}

struct SearchResult: Codable {
    var placeId: String
    var geometry: Geometry
    var name: String
    var reference: String
    var types: [String]
    var vicinity: String
    var icon: String
    
    var photos: [Photo]?
    var openingHours: [String:Bool]?
    var businessStatus: String?
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: geometry.location.lat, longitude: geometry.location.lng)
    }
    
    var imageUrl: String? {
        return photos?.first?.photoReference
    }
    
    enum CodingKeys: String, CodingKey {
        case placeId = "place_id"
        case geometry
        case name
        case reference
        case types
        case vicinity
        case icon
        case photos
        case openingHours = "opening_hours"
        case businessStatus = "business_status"
    }
}

struct Geometry: Codable  {
    var location: Location
}

struct Location: Codable  {
    var lat: Double
    var lng: Double
}

struct Photo: Codable {
    var height: Double
    var width: Double
    var photoReference: String
    
    enum CodingKeys: String, CodingKey {
        case height
        case width
        case photoReference = "photo_reference"
    }
}
