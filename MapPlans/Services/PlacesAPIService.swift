//
//  PlacesAPIService.swift
//  MapPlans
//
//  Created by Tobias on 01.08.2023.
//

import Foundation
import CoreLocation
import Combine

class PlacesAPIService {
    static var shared = PlacesAPIService()
    
    func fetchPlaces(with url: URL) -> AnyPublisher<[SearchResult], Never> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .map{$0.data}
            .decode(type: PlacesResult.self, decoder: JSONDecoder())
            .map{$0.results}
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
