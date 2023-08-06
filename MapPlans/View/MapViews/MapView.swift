//
//  MapView.swift
//  MapPlans
//
//  Created by Tobias on 01.08.2023.
//

import SwiftUI

struct MapView: View {
    @ObservedObject var mapViewModel: MapViewModel = MapViewModel()
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                MapKitView()
                    .environmentObject(mapViewModel)
                    .ignoresSafeArea()
                
                MapStylePickerView(style: $mapViewModel.mapStyle)
            }
            .navigationViewStyle(.stack)
            .background(
                NavigationLink(
                    destination: createPlanView,
                    isActive: $mapViewModel.openCreateView
                ) {
                    EmptyView()
                }
                    .hidden()
            )
            .background(
                NavigationLink(
                    destination: placePlansView,
                    isActive: $mapViewModel.openPlacePlansView
                ) {
                    EmptyView()
                }
                    .hidden()
            )
        }
    }
    
    var placePlansView: some View {
        PlacePlansView(placeId: mapViewModel.selectedPlaceId, placeTitle: mapViewModel.selectedPlaceTitle)
    }
    
    var createPlanView: some View {
        PlanSetupView(placeId: mapViewModel.selectedPlaceId)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
