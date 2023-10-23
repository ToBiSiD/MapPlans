//
//  CLLocation+Extensions.swift
//  MapPlans
//
//  Created by Tobias on 16.10.2023.
//

import Foundation
import CoreLocation

extension CLLocation {
    /// A method that shows if 2 CLLocations out of the range
    ///  - Parameter other: other CLLocation
    ///  - Parameter range: checked range between 2 locations
    func isOutOfTheRange(form other: CLLocation, range: Int) -> Bool {
        return isOutOfTheRange(form: other, range: Double(range))
    }
    
    func isOutOfTheRange(form other: CLLocation, range: Float) -> Bool {
        return isOutOfTheRange(form: other, range: Double(range))
    }
    
    func isOutOfTheRange(form other: CLLocation, range: Double) -> Bool {
        return other.distance(from: self) >= range
    }
}
