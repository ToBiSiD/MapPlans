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

protocol MapUpdateProtocol {
    func moveToPlace(coordinate: CLLocationCoordinate2D)
    func tryUpdateCurrentMapPlace(_ newPosition: CLLocationCoordinate2D)
}

class MapViewModel: ObservableObject {
    @Published var mapStyle: MapStyleOption = .standard
    @Published var annotations: [PlaceAnnotation] = []
    
    @Published var selectedAnnotation: PlaceAnnotation?
    @Published var targetPlace: CLLocationCoordinate2D?
    @Published var trackUserLocation: Bool = false
    @Published var errorText: String?
    
    private var cancellables: Set<AnyCancellable> = []
    
    @Inject private var placesCacheService: PlacesCacheServiceProtocol
    
    init() {
        subscribeOnCacheService()
    }
    
    deinit {
        for cancellable in cancellables {
            cancellable.cancel()
        }
    }
}

//MARK: - Setup
extension MapViewModel {
    private func subscribeOnCacheService() {
        placesCacheService.annotationsPublisher
            .sink { [weak self] newValue in
                DispatchQueue.main.async {
                    self?.annotations = newValue
                    self?.updateSelected()
                }
            }
            .store(in: &cancellables)
        
        placesCacheService.errorTextPublisher
            .sink { [weak self] error in
                DispatchQueue.main.async {
                    self?.errorText = error
                }
            }
            .store(in: &cancellables)
    }
    
    private func updateSelected() {
        if let selected = selectedAnnotation, let updated = annotations.first(where: { $0.placeId == selected.placeId }) {
            self.selectedAnnotation = updated
        }
    }
}

//MARK: - MapUpdateProtocol implementation
extension MapViewModel: MapUpdateProtocol {
    func moveToPlace(coordinate: CLLocationCoordinate2D) {
        targetPlace = coordinate
        trackUserLocation = true
    }
    
    func tryUpdateCurrentMapPlace(_ newPosition: CLLocationCoordinate2D) {
        let sourceLocation = CLLocation(latitude: newPosition.latitude, longitude: newPosition.longitude)
        Task {
            do {
                DispatchQueue.main.async {
                    self.errorText = nil
                }
                try await placesCacheService.checkPosition(sourceLocation)
            } catch {
                DispatchQueue.main.async {
                    self.errorText = error.localizedDescription
                }
            }
        }
    }
}
