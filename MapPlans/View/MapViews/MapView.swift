//
//  MapView.swift
//  MapPlans
//
//  Created by Tobias on 01.08.2023.
//

import SwiftUI
import MapKit

struct MapView: View {
    @EnvironmentObject var viewModel: MapViewModel
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            MapKitView()
                .ignoresSafeArea()
            
            MapStylePickerView(style: $viewModel.mapStyle)
            
            if viewModel.selectedAnnotation != nil {
                SelectedAnnotationView()
                    .ignoresSafeArea()
            }
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                ToolbarBackButtonView()
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
