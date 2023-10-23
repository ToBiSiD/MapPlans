//
//  Animation+Extensions.swift
//  MapPlans
//
//  Created by Tobias on 19.10.2023.
//

import SwiftUI

extension Animation {
    static func ripple(_ index: Int) -> Animation {
        Animation.spring(dampingFraction: 0.5)
            .speed(2)
            .delay(0.05 * Double(index))
    }
}
