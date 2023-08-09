//
//  MapViewModel.swift
//  MapPlans
//
//  Created by Tobias on 01.08.2023.
//

import Foundation
import RealmSwift
import CoreLocation

class MapViewModel : ObservableObject {
    @Published var mapStyle: MapStyleOption = .standard
    @Published var annotations: [PlaceAnnotation] = []
    
    @Published var selectedAnnotation: PlaceAnnotation?
    @Published var targetPlace: CLLocationCoordinate2D?
    
    private var placePlans: [String : [Plan]] = [:]
    private let realmService: RealmService = RealmService()
    private let placesService: PlacesService = PlacesService()
    
    public static var shared: MapViewModel = MapViewModel()
    
    init() {
        fetchPlans()
    }
    
    //MARK: - Work with plans
    private func fetchPlans() {
        let allPlans: Results<Plan>? = realmService.fetchData()
        if let allPlans = allPlans {
            for plan in allPlans {
                var placeId: String
                if let planPlaceId = plan.placeId {
                    placeId = planPlaceId
                } else {
                    placeId = "unknown"
                }
                
                var plansForPlace = self.placePlans[placeId] ?? []
                plansForPlace.append(plan)
                
                self.placePlans[placeId] = plansForPlace
            }
        }
    }
    
    func updatePlanState(planId: ObjectId) {
        let existingPlaceSearchResult = tryGetExistingPlaceInfo(planId: planId)
        if let placeId = existingPlaceSearchResult.placeId, let plans = existingPlaceSearchResult.placePlans {
            for annotation in annotations.filter({ $0.placeId == placeId }) {
                annotation.completedPlans = plans.filter { $0.planState == .done }.count
            }
        }
    }
    
    func removePlan(planId: ObjectId) {
        let existingPlaceSearchResult = tryGetExistingPlaceInfo(planId: planId)
        if let placeId = existingPlaceSearchResult.placeId, var plans = existingPlaceSearchResult.placePlans {
            plans.removeAll { $0.id == planId }
            for annotation in annotations.filter({ $0.placeId == placeId }) {
                annotation.plans = plans.count
                annotation.completedPlans = plans.filter { $0.planState == .done }.count
            }
        }
    }
    
    //MARK: - Work with places
    func updatePlaces(center: CLLocationCoordinate2D) {
        placesService.fetchPlacesFromGoogleAPI(with: center, existingAnnotations: annotations, existingPlans: placePlans) { additionalPlaces in
            let convertedDictionary: [String : [Plan]] = Dictionary(uniqueKeysWithValues: additionalPlaces.map { placeData in
                (placeData.placeId, placeData.plans)
            })
            let combine = self.placePlans.merging(convertedDictionary) { $1 }
            self.placePlans = combine
            for place in additionalPlaces {
                self.createAnnotation(placeData: place)
            }
        }
    }
    
    private func createAnnotation(placeData: PlaceData) {
        if !annotations.contains(where: { $0.placeId == placeData.id }) {
            let plans = placePlans[placeData.id] ?? []
            let totalAmount = plans.count
            let completedAmount = plans.filter { $0.planState == .done }.count
            
            let annotation = PlaceAnnotation(name: placeData.name, placeDescription: "", coordinate: placeData.coordinate, image: placeData.imageUrl, placeId: placeData.id, completedPlans: completedAmount, plans: totalAmount)
            DispatchQueue.main.async {
                self.annotations.append(annotation)
            }
        }
    }
    
    private func tryGetExistingPlaceInfo(planId: ObjectId) -> (placeId: String?, placePlans: [Plan]?) {
        var existingPlaceId: String?
        var existingPlacePlans: [Plan]?
        for (key,value) in placePlans {
            if value.contains(where: { $0.id == planId }){
                existingPlaceId = key
                existingPlacePlans = value
                break
            }
        }
        
        return (existingPlaceId, existingPlacePlans)
    }
    
    func moveToPlace(coordinate: CLLocationCoordinate2D) {
        targetPlace = coordinate
    }
}
