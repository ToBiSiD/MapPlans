//
//  MapStyleOption.swift
//  MapPlans
//
//  Created by Tobias on 01.08.2023.
//

import Foundation
import MapKit
import SwiftUI

protocol CustomOption: CaseIterable, Equatable, Hashable {
    var optionTitle: String { get }
    var optionColor: Color { get }
    var defaultOption: any CustomOption { get }
    var optionImage: String { get }
}

enum MapStyleOption: UInt, CustomOption {
    case standard = 0
    case satellite = 1
    case hybrid = 2
    
    var optionImageName: String {
        switch self {
        case .standard: return "map"
        case .satellite: return "map.fill"
        case.hybrid: return "map.circle"
        }
    }
    
    var optionTitle: String {
        switch self {
        case .standard: return "Standart View"
        case .satellite: return "Satellite View"
        case.hybrid: return "Hybrid view"
        }
    }
    
    var mapType: MKMapType {
        switch self {
        case .standard: return MKMapType.standard
        case .satellite: return MKMapType.satellite
        case .hybrid: return MKMapType.hybrid
        }
    }
    
    var optionColor: Color {
        return .white
    }
    
    var defaultOption: any CustomOption { return Self.standard }
    
    var optionImage: String { return ""}
}
