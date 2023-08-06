//
//  PlanState.swift
//  MapPlans
//
//  Created by Tobias on 01.08.2023.
//

import Foundation
import SwiftUI

enum PlanState: String , CustomOption {
    case toDo = "toDo"
    case inProgress = "inProgress"
    case done = "done"
    
    var optionTitle: String {
        switch self {
        case .toDo: return "To Do"
        case .inProgress: return "In progress"
        case .done: return "Done"
        }
    }
    
    var optionColor: Color {
        switch self {
        case .toDo: return .blue
        case .inProgress: return .yellow
        case .done: return .green
        }
    }
    
    var defaultOption: any CustomOption { return Self.toDo}
}
