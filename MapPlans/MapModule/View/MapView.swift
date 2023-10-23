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
    @State var showSelectedAnnotation: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            MapKitView(showSelectedAnnotation: $showSelectedAnnotation)
                .ignoresSafeArea()
            
            MapStylePickerView(style: $viewModel.mapStyle)
        
            if showSelectedAnnotation {
                SelectedAnnotationView(showSelectedAnnotation: $showSelectedAnnotation)
                    .transition(.moveFromFadeBottom)
            }
               
            
            if let error = viewModel.errorText {
                Text(error)
                    .font(.body)
                    .foregroundColor(.red)
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
