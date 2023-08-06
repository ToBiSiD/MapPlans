//
//  Root.swift
//  MapPlans
//
//  Created by Tobias on 01.08.2023.
//

import Foundation

struct Root: Codable {
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
}
