//
//  PlacesCacheService.swift
//  MapPlans
//
//  Created by Tobias on 12.10.2023.
//

import Foundation
import CoreLocation
import Combine

protocol PlacesDownloadTrackerProtocol {
    func checkPosition(_ location: CLLocation) async throws
}

protocol PlacesCacheServiceProtocol: PlacesDownloadTrackerProtocol {
    var annotationsPublisher: Published<[PlaceAnnotation]>.Publisher { get }
    var errorTextPublisher: Published<String?>.Publisher { get }
    func addPlan(_ item: Plan, for id: String)
    func removePlan(_ item: Plan, for id: String)
}

final class PlacesCacheService {
    @Inject private var realmService: RealmStorageProtocol
    @Inject private var placesNetworkService: PlacesNetworkServiceProtocol
    @Inject private var notificationService: NotificationServiceProtocol
    
    @Published private var cachedAnnotations: [PlaceAnnotation] = []
    @Published private var errorText: String?
    
    private var cachedPlaces: [Place] = [Place]()
    private var cachedDownloads: [CLLocation] = []
    private var cancellables: Set<AnyCancellable> = []
    
    private lazy var apiKey: String = {
        return APIKeys.getValueForAPIKey(named: APIKeyId.googlePlaceAPIKey.rawValue)
    }()
    
    init() {
        subscribeOnRealmService()
    }
    
    deinit {
        for cancellable in cancellables {
            cancellable.cancel()
        }
    }
}

//MARK: - Setup
extension PlacesCacheService {
    private func subscribeOnRealmService() {
        realmService.fetch().collectionPublisher
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.errorText = nil
                    break
                case .failure(let error):
                    self.errorText = error.localizedDescription
                }
            }, receiveValue: { newValue in
                self.updatePlaces(Array(newValue))
            })
            .store(in: &cancellables)
    }
    
    private func updatePlaces(_ places: [Place]) {
        cachedPlaces = places
        
        for place in cachedPlaces {
            if cachedAnnotations.first(where: { $0.placeId == place.placeId }) == nil {
                cachedAnnotations.append(createPlaceAnnotation(place: place))
            }
            
            recalculateAnnotation(for: place.placeId, total: place.allPlans, completed: place.completedPlans)
        }
        
        cachedAnnotations = cachedAnnotations
    }
    
    private func recalculateAnnotation(for placeId: String?, total: Int = 0, completed: Int = 0) {
        if let placeId = placeId, let annotation = cachedAnnotations.first(where: { $0.placeId == placeId }) {
            annotation.completedPlans = completed
            annotation.plans = total
        }
    }
}

//MARK: - PlacesCacheServiceProtocol implementation
extension PlacesCacheService: PlacesCacheServiceProtocol {
    var annotationsPublisher: Published<[PlaceAnnotation]>.Publisher { $cachedAnnotations }
    var errorTextPublisher: Published<String?>.Publisher { $errorText }
    
    func checkPosition(_ location: CLLocation) async throws {
        try await tryDownloadData(for: location)
    }
    
    func addPlan(_ item: Plan, for id: String) {
        if let place = cachedPlaces.first(where: { $0.placeId == id }) {
            realmService.update {
                place.plans.append(item)
            }
        } else {
            if let place = cachedAnnotations.first(where: { $0.placeId == id}) {
                let place = Place(id: id, title: place.title ?? "", lon: place.coordinate.longitude, lat: place.coordinate.latitude)
                place.plans.append(item)
                realmService.addData(place)
            }
        }
    }
    
    func removePlan(_ item: Plan, for id: String) {
        if let place = cachedPlaces.first(where: { $0.placeId == id }) {
            if let planId = place.plans.index(of: item) {
                notificationService.cancelNotifications(ids: item.notifications.map({ $0.notificationId }))
                realmService.update {
                    place.plans.remove(at: planId)
                }
            } else {
                self.errorText = "No \(item.title) for \(place.placeTitle)"
            }
        } else {
            self.errorText = "Can't find place with id \(id)"
        }
    }
}

//MARK: - Download Places data logic
extension PlacesCacheService {
    private func tryDownloadData(for location: CLLocation) async throws {
        if !isDataDownloaded(for: location) {
            cachedDownloads.append(location)
            var urlComponents = URLComponents(string: AppConstants.APIConstants.apiLink)
            urlComponents?.queryItems = [
                URLQueryItem(name: AppConstants.APIConstants.locationKey, value: "\(location.coordinate.latitude),\(location.coordinate.longitude)"),
                URLQueryItem(name: AppConstants.APIConstants.radius, value: "\(AppConstants.searchRadius)"),
                URLQueryItem(name: AppConstants.APIConstants.key, value: apiKey)
            ]
            
            let nearPlaces = try await placesNetworkService.fetchPlaces(with: urlComponents?.url)
            tryCachePlaces(places: nearPlaces)
        }
    }
    
    private func isDataDownloaded(for location: CLLocation) -> Bool {
        for loc in cachedDownloads {
            if !loc.isOutOfTheRange(form: location, range: AppConstants.searchRadius) {
                return true
            }
        }
        
        return false
    }
}

//MARK: - Cache places data Logic
extension PlacesCacheService {
    private func tryCachePlaces(places: [SearchResult]) {
        let placesToAdd = places.filter { place in
            if Set(place.types).isDisjoint(with: AppConstants.placeTypeExceptions)
                && !cachedAnnotations.contains(where: { $0.placeId == place.placeId }) {
                return true
            } else {
                return false
            }
        }
        
        DispatchQueue.main.async {
            placesToAdd.forEach { self.addAnnotation(for: $0) }
        }
    }
    
    private func addAnnotation(for place: SearchResult) {
        cachedAnnotations.append(createPlaceAnnotation(place: place))
    }
    
    private func createPlaceAnnotation(place: SearchResult) -> PlaceAnnotation {
        let placeInCache = cachedPlaces.first { $0.placeId == place.placeId }
        let annotation = PlaceAnnotation(name: place.name, placeDescription: "", coordinate: place.coordinate, image: place.imageUrl, placeId: place.placeId, completedPlans: placeInCache?.completedPlans ?? 0, plans: placeInCache?.allPlans ?? 0)
        return annotation
    }
    
    private func createPlaceAnnotation(place: Place) -> PlaceAnnotation {
        let annotation = PlaceAnnotation(name: place.placeTitle, coordinate: place.coordinate, placeId: place.placeId, completedPlans: place.completedPlans, plans: place.allPlans)
        return annotation
    }
}
