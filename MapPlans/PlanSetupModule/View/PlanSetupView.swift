//
//  PlanSetupView.swift
//  MapPlans
//
//  Created by Tobias on 02.08.2023.
//

import SwiftUI
import CoreLocation

struct PlanSetupView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject private var viewModel: PlanSetupViewModel
    @State private var showNotifySettigns: Bool = false

    private var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    init(placeId: String, plan: Plan? = nil) {
        self.viewModel = PlanSetupViewModel(plan: plan, placeId: placeId)
    }
    
    var body: some View {
        ZStack {
            ColorConstants.backgroundColor
                .ignoresSafeArea()
            
            VStack {
                ImageTextFieldView(textValue: $viewModel.planTitle, isSecurityField: false, placeholderText: viewModel.planTitle.isEmpty ? viewModel.planTitle : "Title", imageName: "pencil")
                
                ImageTextFieldView(textValue: $viewModel.planDescription, isSecurityField: false, placeholderText: viewModel.planDescription.isEmpty ? viewModel.planDescription : "Description", imageName: "pencil")
                
                DatePicker("Finish date", selection: $viewModel.finishDate)
                    .datePickerStyle(.compact)
                    .padding()
                    .foregroundColor(ColorConstants.textColor)
                
                HStack(alignment: .top) {
                    Text("State")
                        .font(.subheadline)
                        .foregroundColor(ColorConstants.textColor)
                        .frame(height: 45)
                    
                    Spacer()
                    
                    if let options = PlanState.allCases as? [PlanState] {
                        DropdownSelectorView(defaultOption: viewModel.plan?.planState ?? .toDo, options: options, buttonHeight: 40) { option in
                            viewModel.planState = option
                        }
                    }
                }
                .padding(.horizontal)

                Spacer()
                HStack {
                    Toggle(isOn: $showNotifySettigns) {
                        Text("With notification")
                            .font(.caption)
                            .fontWeight(.heavy)
                            .foregroundColor(ColorConstants.textColor)
                    }
                    .toggleStyle(.button)
                    
                    Spacer()
                }
                if showNotifySettigns {
                    NotificationSettingsView(notifyDate: $viewModel.notifyDate, locationRadius: $viewModel.locationRadius)
                }
                
                Button {
                    finishSetup()
                    dismiss()
                } label: {
                    BaseButtonLabel(text: viewModel.plan == nil ? "Create" : "Update")
                        .frame(width: 340, height: 44)
                }
                
            }
            .padding(.vertical, 20)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                ToolbarBackButtonView()
            }
        }
    }
    
    private func finishSetup() {
        if viewModel.plan != nil {
            viewModel.updatePlan()
        } else {
            viewModel.addPlan()
        }
    }
}
