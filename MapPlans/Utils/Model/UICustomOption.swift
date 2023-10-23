//
//  UICustomOption.swift
//  MapPlans
//
//  Created by Tobias on 12.09.2023.
//

import Foundation
import SwiftUI

protocol UICustomOption: CaseIterable, Equatable, Hashable {
    var optionTitle: String { get }
    var optionColor: Color { get }
    var defaultOption: any UICustomOption { get }
    var optionImage: String { get }
}

extension UICustomOption {
    var optionTitle: String {
        return ""
    }
    
    var optionColor: Color {
        return Color.clear
    }
    
    var optionImage: String {
        return ""
    }
}
