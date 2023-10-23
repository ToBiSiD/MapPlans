//
//  PlacePlansView.swift
//  MapPlans
//
//  Created by Tobias on 02.08.2023.
//

import SwiftUI
import CoreLocation

struct PlacePlansView: View {
    @ObservedObject var viewModel: PlacePlansViewModel
    
    private let placeTitle: String
    
    init(placeId: String, placeTitle: String) {
        self.viewModel = PlacePlansViewModel(placeId: placeId)
        self.placeTitle = placeTitle
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top) {
                Text("Plans for ")
                    .font(.title3)
                    .bold()
                Text(placeTitle)
                    .font(.title2)
                    .bold()
                    .lineLimit(2)
                Spacer()
            }
            .foregroundColor(ColorConstants.textColor)
            .frame(maxHeight: 100)
            .padding(.horizontal)
            
            HStack {
                Text("Completed plans: \(viewModel.progressText ?? "0")")
                    .foregroundColor(ColorConstants.textColor)
                    .font(.headline)
                    .fontWeight(.heavy)
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom,10)
            
            CustomDividerView(height: 2)
            
            List {
                if let plans = viewModel.plans{
                    ForEach(plans) { plan in
                        PlanRowView(plan: plan)
                            .listRowBackground(ColorConstants.backgroundColor)
                    }
                }
            }
            .listStyle(.plain)
            .background(ColorConstants.backgroundColor)
        }
        .background(ColorConstants.backgroundBrightColor)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                ToolbarBackButtonView()
            }
            
            ToolbarItem(placement: .bottomBar) {
                Spacer()
            }
            
            ToolbarItem(placement: .bottomBar) {
                NavigationLink {
                    PlanSetupView(placeId: viewModel.placeId)
                } label: {
                    ZStack {
                        Circle()
                            .frame(width: 52, height: 52)
                            .foregroundColor(ColorConstants.shadowColor)
                        
                        Circle()
                            .frame(width: 50, height: 50)
                            .foregroundColor(ColorConstants.textColor)
                        
                        Image(systemName: "square.and.pencil.circle.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50,height: 50)
                            .foregroundColor(ColorConstants.buttonColor)
                    }
                }
            }
        }
    }
}
