//
//  AllPlansView.swift
//  MapPlans
//
//  Created by Tobias on 11.08.2023.
//

import SwiftUI

struct AllPlansView: View {
    @ObservedObject var viewModel: PlansViewModel = PlansViewModel()
    
    var body: some View {
        VStack(spacing: 0)  {
            HStack(alignment: .top) {
                Text("All Plans")
                    .font(.title3)
                    .fontWeight(.heavy)
                Spacer()
                
                Text(viewModel.getInfo())
                    .font(.headline)
                    .fontWeight(.heavy)
            }
            .foregroundColor(ColorConstants.textColor)
            .frame(maxHeight: 100)
            .padding(.horizontal)
            
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
        }
    }
}

struct AllPlansView_Previews: PreviewProvider {
    static var previews: some View {
        AllPlansView()
    }
}
