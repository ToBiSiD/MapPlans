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
    
    @Published var selectedPlaceId: String = ""
    @Published var selectedPlaceTitle: String = ""
    @Published var openCreateView: Bool = false
    @Published var openPlacePlansView: Bool = false
    
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
            for annotation in annotations {
                if annotation.placeId == placeId {
                    annotation.completedPlans = plans.filter { $0.planState == .done }.count
                }
            }
        }
    }
    
    func removePlan(planId: ObjectId) {
        let existingPlaceSearchResult = tryGetExistingPlaceInfo(planId: planId)
        if let placeId = existingPlaceSearchResult.placeId, var plans = existingPlaceSearchResult.placePlans {
            plans.removeAll { $0.id == planId }
            for annotation in annotations {
                if annotation.placeId == placeId {
                    annotation.plans = plans.count
                    annotation.completedPlans = plans.filter { $0.planState == .done }.count
                }
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
                self.createAnnotation(placeId: place.placeId, placeName: place.name, coordinate: CLLocationCoordinate2D(latitude: place.lat, longitude: place.lng))
            }
        }
    }
    
    private func createAnnotation(placeId: String, placeName: String, coordinate: CLLocationCoordinate2D) {
        if !annotations.contains(where: { $0.placeId == placeId }) {
            let plans = placePlans[placeId] ?? []
            let totalAmount = plans.count
            let completedAmount = plans.filter { $0.planState == .done }.count
            
            let annotation = PlaceAnnotation(name: placeName, placeDescription: "", coordinate: coordinate, image: "", placeId: placeId, completedPlans: completedAmount, plans: totalAmount)
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
    
    func makePlaceAction(placeAction: PlaceActions){
        switch placeAction {
        case .createPlan(let placeId):
            selectedPlaceId = placeId
            openCreateView.toggle()
        case .openPlacePlans(let placeData):
            selectedPlaceId = placeData.id
            selectedPlaceTitle = placeData.name
            openPlacePlansView.toggle()
        }
    }
    
    /*
    func resetSubValues() {
        selectedPlaceId = nil
        selectedPlaceTitle = nil
        openCreateView = false
        openPlacePlansView = false
    }*/
}
