//
//  SelectedAnnotationView.swift
//  MapPlans
//
//  Created by Tobias on 08.08.2023.
//

import SwiftUI
import CoreLocation

struct SelectedAnnotationView: View {
    @EnvironmentObject var viewModel: MapViewModel
    @Binding var showSelectedAnnotation: Bool
    
    var body: some View {
            VStack {
                Spacer()
                
                if let annotation = viewModel.selectedAnnotation {
                    VStack {
                        annotationHeader
                        annotationInformationView(annotation)
                        
                        if let imageUrl = annotation.image, imageUrl.isEmpty {
                            loadedImage(from: imageUrl)
                        }
                        
                        ProgressPlansView(currentValue: annotation.plans == 0 ? 0 : Double(annotation.completedPlans), maxValue: Double(annotation.plans), progressText: annotation.plansProgress, horizontalPadding: 15)
                            .padding(.bottom, 15)
                        
                        annotationFooter(annotation)
                    }
                    .frame(maxHeight: 350)
                    .background(ColorConstants.backgroundColor)
                    .cornerRadius(ValueConstants.defaultCornerRadius)
                }
            }
            .ignoresSafeArea(edges: .bottom)
    }
    
    private var annotationHeader: some View {
        HStack {
            Spacer()
            Button {
                withAnimation() {
                    showSelectedAnnotation.toggle()
                }
            } label: {
                ZStack {
                    Circle()
                        .frame(width: 30)
                        .foregroundColor(ColorConstants.textColor)
                    
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .scaledToFill()
                        .foregroundColor(ColorConstants.buttonColor)
                }
            }
        }
        .frame(maxHeight: 30)
        .padding(.horizontal)
        .padding(.top, 10)
    }
    
    private func annotationFooter(_ annotation: PlaceAnnotation) -> some View {
        HStack(spacing: 15) {
            if let placeId = annotation.placeId {
                NavigationLink {
                    PlanSetupView(placeId: placeId)
                } label: {
                    BaseButtonLabel(text: "Add plan", imageName: "plus")
                }
                
                NavigationLink {
                    PlacePlansView(placeId: placeId, placeTitle: annotation.name ?? "")
                } label: {
                    BaseButtonLabel(text: "Plans", imageName: "list.bullet.clipboard")
                }
                
                Button {
                    viewModel.moveToPlace(coordinate: annotation.coordinate)
                    withAnimation {
                        showSelectedAnnotation.toggle()
                    }
                } label: {
                    BaseButtonLabel(text: "Move", imageName: "figure.walk")
                }
                
            }
        }
        .padding(.horizontal)
        .frame(maxHeight: 45)
        .padding(.bottom, 50)
    }
    
    private func loadedImage(from urlString: String) -> some View {
        AsyncImage(url: URL(string: urlString)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
        } placeholder: {
            ZStack {
                Color.gray
            }
        }
        .frame(width: 100, height: 100)
        .padding(30)
    }
    
    private func annotationInformationView(_ annotation: PlaceAnnotation) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                if let name = annotation.name {
                    Text(name)
                        .lineLimit(1)
                        .font(.title)
                        .fontWeight(.heavy)
                        .padding(.horizontal)
                }
                
                if let description = annotation.placeDescription
                {
                    Text(description)
                        .lineLimit(3)
                }
            }
            .foregroundColor(ColorConstants.textColor)
            .padding(.horizontal)
            Spacer()
        }
        
    }
    
}

