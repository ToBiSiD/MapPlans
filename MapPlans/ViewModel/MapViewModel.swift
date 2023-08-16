//
//  MapViewModel.swift
//  MapPlans
//
//  Created by Tobias on 01.08.2023.
//

import Foundation
import RealmSwift
import CoreLocation
import Combine

class MapViewModel : ObservableObject {
    @Published var mapStyle: MapStyleOption = .standard
    @Published var annotations: [PlaceAnnotation] = []
    
    @Published var selectedAnnotation: PlaceAnnotation?
    @Published var targetPlace: CLLocationCoordinate2D?
    
    @Published var currentMapPlace: CLLocationCoordinate2D?
    @Published var trackUserLocation: Bool = false
    
    private var cancellables: Set<AnyCancellable> = []
    private var placePlans: [String: [Plan]] = [:]
    
    private var url : URL? {
        if let center = currentMapPlace {
            let urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(center.latitude),\(center.longitude)&radius=\(AppConstants.searchRadius)&key=\(ApiKeys.googlePlacesApiKey)"
            return URL(string: urlString)
        } else {
            return nil
        }
    }
    
    init() {
        subscribeOnRealmService()
        subscribeOnPlacesService()
    }
    
    private func subscribeOnRealmService() {
        RealmService.shared.fetchPlans().collectionPublisher
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }, receiveValue: { updatedPlans in
                self.updatePlans(Array(updatedPlans))
            })
            .store(in: &cancellables)
        
    }
    
    
    private func subscribeOnPlacesService() {
        $currentMapPlace
            .compactMap { location in
                self.url
            }
            .flatMap { url in
                PlacesAPIService.shared.fetchPlaces(with: url)
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Fetching places failed with error: \(error)")
                }
            }, receiveValue: { searchResults in
                self.tryAddPlaces(places: searchResults)
            })
            .store(in: &cancellables)
    }
    
    deinit {
        for cancellable in cancellables {
            cancellable.cancel()
        }
    }
    
    private func tryAddPlaces(places: [SearchResult]) {
        let placesToAdd = places.filter { !$0.types.contains(where: AppConstants.placeTypeExceptions.contains) }
        
        for place in placesToAdd {
            if annotations.contains(where: { $0.placeId == place.placeId }) {
                continue
            }
            
            createPlaceAnnotation(place: place)
        }
    }
    
    private func createPlaceAnnotation(place: SearchResult) {
        let placePlanAmounts = getPlacePlansAmount(for: place.placeId)
        
        let annotation = PlaceAnnotation(name: place.name, placeDescription: "", coordinate: place.coordinate, image: place.imageUrl, placeId: place.placeId, completedPlans: placePlanAmounts.completed, plans: placePlanAmounts.total)
        DispatchQueue.main.async {
            self.annotations.append(annotation)
        }
        
    }
    
    private func updatePlans(_ plans: [Plan]) {
        placePlans = Dictionary(grouping: plans, by: { $0.placeId ?? "unknown" })
        
        for placeId in placePlans.keys {
            recalculateAnnotation(for: placeId)
        }
    }
    
    private func recalculateAnnotation(for placeId: String?) {
        if let placeId = placeId, let annotation = annotations.first(where: { $0.placeId == placeId }) {
            let placePlanAmounts = getPlacePlansAmount(for: placeId)
            
            annotation.completedPlans = placePlanAmounts.completed
            annotation.plans = placePlanAmounts.total
        }
    }
    
    private func getPlacePlansAmount(for placeId: String) -> (total: Int , completed: Int) {
        let placePlans = placePlans[placeId] ?? []
        return (placePlans.count, placePlans.filter { $0.planState == .done }.count)
    }
    
    func moveToPlace(coordinate: CLLocationCoordinate2D) {
        targetPlace = coordinate
        trackUserLocation = true
    }
    
    func tryUpdateCurrentMapPlace(_ newPosition : CLLocationCoordinate2D){
        if let cashed = currentMapPlace {
            let sourceLocation = CLLocation(latitude: newPosition.latitude, longitude: newPosition.longitude)
            let currentLocation = CLLocation(latitude: cashed.latitude, longitude: cashed.longitude)
            let distance = sourceLocation.distance(from: currentLocation)
            if (distance/2) > AppConstants.searchRadius {
                currentMapPlace = newPosition
            }
        } else {
            currentMapPlace = newPosition
        }
    }
}
