//
//  ApiKeys.swift
//  MapPlans
//
//  Created by Tobias on 18.08.2023.
//

import Foundation

enum APIKeyId: String {
    case googlePlaceAPIKey = "googlePlacesApiKey"
}

struct APIKeys {
    private static let apiKeysPlistTitle: String = "ApiKeys"
    
    static func getValueForAPIKey(named keyname: String) -> String {
        guard let filePath = Bundle.main.path(forResource: apiKeysPlistTitle, ofType: "plist") else { fatalError() }
        let plist = NSDictionary(contentsOfFile: filePath)
        let value = plist?.object(forKey: keyname)
        guard let value = plist?.object(forKey: keyname) as? String else { fatalError() }
        return value
    }
}
