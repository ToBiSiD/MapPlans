//
//  UIApplication+Extensions.swift
//  MapPlans
//
//  Created by Tobias on 23.10.2023.
//

import Foundation
import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
