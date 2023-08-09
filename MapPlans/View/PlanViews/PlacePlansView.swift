//
//  PlacePlansView.swift
//  MapPlans
//
//  Created by Tobias on 02.08.2023.
//

import SwiftUI

struct PlacePlansView: View {
    @ObservedObject var viewModel: PlacePlansViewModel
    
    private let placeTitle: String
    
    init(placeId: String, placeTitle: String) {
        self.viewModel = PlacePlansViewModel(placeId: placeId)
        self.placeTitle = placeTitle
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Text("Plans for")
                    .font(.title3)
                    .bold()
                Text(placeTitle)
                    .font(.title2)
                    .bold()
                    .lineLimit(2)
                Spacer()
            }
            .frame(maxHeight: 100)
            .padding(.horizontal)
            
            List {
                if let plans = viewModel.plans {
                    ForEach(plans) { plan in
                        PlanRowView(plan: plan, placeId: viewModel.placeId)
                    }
                }
            }
            .listStyle(.plain)
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Spacer()
            }
            
            ToolbarItem(placement: .bottomBar) {
                NavigationLink {
                    PlanSetupView(placeId: viewModel.placeId)
                } label: {
                    Image(systemName: "square.and.pencil.circle.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50,height: 50)
                        .foregroundColor(.blue)
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
