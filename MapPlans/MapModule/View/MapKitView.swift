//
//  MapKitView.swift
//  MapPlans
//
//  Created by Tobias on 01.08.2023.
//

import SwiftUI
import MapKit
import Combine

struct MapKitView: UIViewRepresentable {
    @EnvironmentObject var viewModel: MapViewModel
    @Binding var showSelectedAnnotation: Bool
   
    func makeUIView(context: Context) -> MKMapView {
        let mapView = context.coordinator.mapView
        mapView.mapType = viewModel.mapStyle.mapType
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        context.coordinator.mapView.mapType = viewModel.mapStyle.mapType
        context.coordinator.addAnnotaions(annotations: viewModel.annotations)
        if let targetPlace = viewModel.targetPlace {
            context.coordinator.moveToPlace(coordinate: targetPlace)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

//MARK: - Coordinator

extension MapKitView {
    
    class Coordinator: NSObject, MKMapViewDelegate {
        
        private var parent: MapKitView
        private var directions: MKDirections?
        private var prevMoveCoordinate: CLLocationCoordinate2D?
        
        lazy var mapView: MKMapView = {
            let mv = MKMapView()
            
            mv.delegate = self
            mv.isRotateEnabled = true
            mv.userTrackingMode = .follow
            mv.showsUserLocation = true
            
            if let coordinate = LocationManager.shared.location?.coordinate {
                let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.005 , longitudeDelta: 0.005))
                mv.setRegion(region, animated: true)
            }
            
            return mv
        }()
        
        //MARK: - lifecycle
        init(_ parent: MapKitView) {
            self.parent = parent
            super.init()
        }
        
        //MARK: - map delegates
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            if parent.viewModel.trackUserLocation {
                let region = MKCoordinateRegion(center: userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.005 , longitudeDelta: 0.005))
                mapView.setRegion(region, animated: true)
            }
        }
        
        func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
            setCurrentMapPlace(place: mapView.region.center)
        }
        
        private func setCurrentMapPlace(place: CLLocationCoordinate2D) {
            DispatchQueue.main.async {
                self.parent.viewModel.tryUpdateCurrentMapPlace(place)
            }
        }
        
        func addAnnotaions(annotations: [PlaceAnnotation]) {
            mapView.removeAnnotations(mapView.annotations)
            mapView.addAnnotations(annotations)
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            if let annotation = view.annotation as? PlaceAnnotation {
                parent.viewModel.selectedAnnotation = annotation
                withAnimation {
                    parent.showSelectedAnnotation.toggle()
                }
            }
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if overlay is MKPolyline {
                let renderer = MKPolylineRenderer(overlay: overlay)
                renderer.strokeColor = UIColor(ColorConstants.backgroundColor)
                renderer.lineWidth = 5
                return renderer
            }
            
            return MKOverlayRenderer(overlay: overlay)
        }
        
        func moveToPlace(coordinate: CLLocationCoordinate2D) {
            if coordinate.latitude == prevMoveCoordinate?.latitude && coordinate.longitude == prevMoveCoordinate?.longitude {
                return
            } else {
                prevMoveCoordinate = coordinate
            }
            
            guard let userLocation = mapView.userLocation.location, let placeLocation = prevMoveCoordinate else { return }
            
            let sourcePlacemark = MKPlacemark(coordinate: userLocation.coordinate)
            let destinationPlacemark = MKPlacemark(coordinate: placeLocation)
            
            let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
            let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
            
            let request = MKDirections.Request()
            request.source = sourceMapItem
            request.destination = destinationMapItem
            request.transportType = .automobile
            
            directions = MKDirections(request: request)
            directions?.calculate { [weak self] (response, error) in
                guard let self = self, let route = response?.routes.first else {
                    return
                }
                
                mapView.removeOverlays(mapView.overlays)
                mapView.addOverlay(route.polyline, level: .aboveRoads)
                
                mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0), animated: true)
            }
        }
    }
}

