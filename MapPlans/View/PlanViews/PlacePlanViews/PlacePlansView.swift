//
//  PlacePlansView.swift
//  MapPlans
//
//  Created by Tobias on 02.08.2023.
//

import SwiftUI

struct PlacePlansView: View {
    @ObservedObject var viewModel: PlansViewModel
    
    private let placeTitle: String
    
    init(placeId: String, placeTitle: String) {
        self.viewModel = PlansViewModel(placeId: placeId)
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
                Text("Completed plans: \(viewModel.getInfo())")
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
                    if let placeId = viewModel.placeId{
                        PlanSetupView(placeId: placeId)
                    }
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

struct PlacePlansView_Previews: PreviewProvider {
    static var previews: some View {
        PlacePlansView(placeId: "unknown", placeTitle: "Nova Poshta #73")
    }
}
