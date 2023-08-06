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
    @State private var initialRegion: MKCoordinateRegion?
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = context.coordinator.mapView
        mapView.mapType = viewModel.mapStyle.mapType
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        context.coordinator.mapView.mapType = viewModel.mapStyle.mapType
        context.coordinator.addAnnotaions(annotations: viewModel.annotations)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

//MARK: - Coordinator

extension MapKitView {
    
    class Coordinator: NSObject, MKMapViewDelegate, AnnotationCalloutDelegate {
        
        private var parent: MapKitView
        private var selectedAnnotation : MKAnnotationView?
        private var directions: MKDirections?
        
        lazy var mapView: MKMapView = {
            let mv = MKMapView()
            mv.delegate = self
            mv.isRotateEnabled = true
            mv.userTrackingMode = .follow
            mv.showsUserLocation = true
            return mv
        }()
        
        
        //MARK: - lifecycle
        init(_ parent: MapKitView) {
            self.parent = parent
            super.init()
        }
        
        //MARK: - map delegates
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            let region = MKCoordinateRegion(center: userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.005 , longitudeDelta: 0.005))
            mapView.setRegion(region, animated: true)
        }
        
        func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
            // Handle region change here
            parent.viewModel.updatePlaces(center: mapView.region.center)
        }
        
        func addAnnotaions(annotations: [PlaceAnnotation]) {
            mapView.removeAnnotations(mapView.annotations)
            mapView.addAnnotations(annotations)
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            if annotation.isEqual(mapView.userLocation)
            {
                return nil
            }
            
            guard let annotation = annotation as? PlaceAnnotation else {return nil}
            
            var annotationView: MKAnnotationView
            
            if let view = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationView") {
                annotationView = view
            } else {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView")
                annotationView.canShowCallout = true
                annotationView.calloutOffset = CGPoint(x: 0, y: 5)
                
                let calloutView = AnnotationCalloutView(annotation: annotation)
                calloutView.widthAnchor.constraint(greaterThanOrEqualToConstant: 170).isActive = true
                calloutView.heightAnchor.constraint(lessThanOrEqualToConstant: 100).isActive = true
                calloutView.delegate = self
                calloutView.translatesAutoresizingMaskIntoConstraints = false
                
                annotationView.detailCalloutAccessoryView = calloutView
            }
            
            let image = UIImage(systemName: "star.fill")
            //annotationView.tintColor
            annotationView.image = image
            //annotationView.tintColor = .red
            
            
            return annotationView
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            selectedAnnotation = view
        }
        
        func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
            selectedAnnotation = nil
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if overlay is MKPolyline {
                let renderer = MKPolylineRenderer(overlay: overlay)
                renderer.strokeColor = UIColor.blue
                renderer.lineWidth = 3
                return renderer
            }
            
            return MKOverlayRenderer(overlay: overlay)
        }
        
        //MARK: - annotation callout
        func openPlacePlans() {
            if let placeAnnotation = selectedAnnotation?.annotation as? PlaceAnnotation, let placeId = placeAnnotation.placeId, let title = placeAnnotation.title {
                let data = PlaceData(placeId: placeId, name: title, lat: 0.0, lng: 0.0)
                parent.viewModel.makePlaceAction(placeAction: .openPlacePlans(data))
            }
        }
        
        func addPlan() {
            if let placeAnnotation = selectedAnnotation?.annotation as? PlaceAnnotation, let placeId = placeAnnotation.placeId {
                parent.viewModel.makePlaceAction(placeAction: .createPlan(placeId))
            }
        }
        
        func moveToPlace() {
            guard let destinationAnnotation = selectedAnnotation?.annotation as? PlaceAnnotation,let userLocation = mapView.userLocation.location  else {
                return }
            
            let sourcePlacemark = MKPlacemark(coordinate: userLocation.coordinate)
            let destinationPlacemark = MKPlacemark(coordinate: destinationAnnotation.coordinate)
            
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
                
                // Remove any existing overlays before adding the new route
                mapView.removeOverlays(mapView.overlays)
                mapView.addOverlay(route.polyline, level: .aboveRoads)
                
                // Optionally, you can also adjust the visible region to show the route
                mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0), animated: true)
            }
        }
    }
}

