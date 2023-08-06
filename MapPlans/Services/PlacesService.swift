//
//  PlacesService.swift
//  MapPlans
//
//  Created by Tobias on 01.08.2023.
//

import Foundation
import CoreLocation

class PlacesService {
    private var cashedPosition : CLLocationCoordinate2D?
    
    func fetchPlacesFromGoogleAPI(with center: CLLocationCoordinate2D, existingAnnotations: [PlaceAnnotation], existingPlans: [String : [Plan]], completion: @escaping ([PlaceData]) -> Void) {
        if !isNeedToUpdateMarkers(center)
        {
            return
        }
        
        cashedPosition = center
        let urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(center.latitude),\(center.longitude)&radius=\(Constants.radius)&key=\(Constants.googlePlacesApiKey)"
        
        if let url = URL(string: urlString) {
            let sesion = URLSession(configuration: .default)
            let task = sesion.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    return
                }
                
                if let safeData = data {
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let root = try decoder.decode(Root.self, from: safeData)
                        let additionalPlaces = self.additionalPlaces(places: root.results, existingAnnotation: existingAnnotations, existingPlans: existingPlans)
                        DispatchQueue.main.async {
                            completion(additionalPlaces)
                        }
                    } catch {
                        print(error)
                    }
                }
            }
            
            task.resume()
        }
        
    }
    
    
    private func additionalPlaces(places: [SearchResult], existingAnnotation: [PlaceAnnotation], existingPlans: [String : [Plan]]) -> [PlaceData] {
        let placesToAdd = places.filter { !$0.types.contains(where: Constants.placeTypeExceptions.contains) }
        let existingPlaceIds = existingAnnotation.map { $0.placeId }
        var placesData: [PlaceData] = []
        
        for place in placesToAdd {
            if existingPlaceIds.contains(place.placeId) || placesData.contains(where: { $0.placeId == place.placeId }) {
                continue
            }

            let plans = existingPlans[place.placeId] ?? []
            let placeData = PlaceData(placeId: place.placeId, name: place.name, lat: place.geometry.location.lat, lng: place.geometry.location.lng, plans: plans)
            placesData.append(placeData)
        }
        
        return placesData
    }

    
    private func isNeedToUpdateMarkers(_ newPosition : CLLocationCoordinate2D) -> Bool {
        
        if let cashed = cashedPosition {
            let sourceLocation = CLLocation(latitude: newPosition.latitude, longitude: newPosition.longitude)
            let currentLocation = CLLocation(latitude: cashed.latitude, longitude: cashed.longitude)
            let distance = sourceLocation.distance(from: currentLocation)
            return (distance/2) > Constants.radius
        } else {
            return true
        }
    }
    
}
