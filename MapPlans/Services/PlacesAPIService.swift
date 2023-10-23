//
//  PlacesAPIService.swift
//  MapPlans
//
//  Created by Tobias on 01.08.2023.
//

import Foundation
import CoreLocation

typealias NetworkDownloadService = DataHandler & NetworkHandler

protocol PlacesNetworkServiceProtocol: NetworkDownloadService {
    func fetchPlaces(with url: URL?) async throws -> [SearchResult]
}

final class PlacesAPIService: PlacesNetworkServiceProtocol {
    func fetchPlaces(with url: URL?) async throws -> [SearchResult] {
        guard let url = url else { throw NetworkError.invalidLink }
        
        DebugLogger.shared.printLog("\(url)")
        let (data, response) = try await URLSession.shared.data(from: url)
        try tryCheckResponse(response: response)
        let decodeData: PlacesResult = try decodeData(data: data)
        return decodeData.results
    }
}
