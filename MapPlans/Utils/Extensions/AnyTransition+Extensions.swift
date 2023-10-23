//
//  AnyTransition+Extensions.swift
//  MapPlans
//
//  Created by Tobias on 19.10.2023.
//

import SwiftUI

extension AnyTransition {
    static var moveFromFadeBottom: AnyTransition {
        .move(edge: .bottom).combined(with: opacity)
    }
    
    static var moveFromTrailing: AnyTransition {
        .move(edge: .trailing).combined(with: opacity)
    }
}
