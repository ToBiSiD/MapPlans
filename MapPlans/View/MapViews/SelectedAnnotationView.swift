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
    
    var body: some View {
        if let annotation = viewModel.selectedAnnotation {
            VStack {
                Spacer()
                
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            viewModel.selectedAnnotation = nil
                        } label: {
                            ZStack {
                                Circle()
                                    .frame(width: 30)
                                    .foregroundColor(.white)
                                
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
                    
                    CustomDividerView()
                        .padding(.bottom,10)
                    
                    if let imageUrl = annotation.image, imageUrl.isEmpty {
                        AsyncImage(url: URL(string: imageUrl)) { image in
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
                    
                    ProgressPlansView(currentValue: annotation.plans == 0 ? 0 : annotation.plansProgressValue, maxValue: Double(annotation.plans), progressText: annotation.plansProgress)
                        .padding(.horizontal)
                        .padding(.bottom, 15)
                    
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
                                viewModel.selectedAnnotation = nil
                            } label: {
                                BaseButtonLabel(text: "Move", imageName: "figure.walk")
                            }
                            
                        }
                    }
                    .padding(.horizontal)
                    .frame(maxHeight: 45)
                    .padding(.bottom, 50)
                }
                .frame(maxHeight: 350)
                .background(ColorConstants.backgroundColor)
                .cornerRadius(ValueConstants.defaultCornerRadius)
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
    
}

