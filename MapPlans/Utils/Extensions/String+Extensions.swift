//
//  String+Extensions.swift
//  MapPlans
//
//  Created by Tobias on 23.10.2023.
//

import Foundation

extension String {
    var date: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return formatter.date(from: self)
    }
}
