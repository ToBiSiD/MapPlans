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
    
    @State var planTitle: String = ""
    @State var description: String = ""
    @State var planState: PlanState = .toDo
    @State var finishDate: Date = Date()
    
    @State var showNotifySettigns: Bool = false
    @State var notifyDate: Date = Date().dayBefore
    @State var locationRadius: Int = 0
    
    private var placeId: String = ""
    private var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    init(placeId: String, plan: Plan? = nil) {
        self.placeId = placeId
        self.viewModel = PlanSetupViewModel(plan: plan)
        
        if let plan = viewModel.plan {
            self.planTitle = plan.title
            self.planState = plan.planState
            if let description = plan.planDescription {
                self.description = description
            }
            
            if let finish = plan.finishDate {
                self.finishDate = finish
            }
            
            /*if let notifyDate = plan.notifyDate {
                self.notifyDate = notifyDate
            }
            
            if let notifyRadius = plan.notifyRadius {
                self.locationRadius = notifyRadius
            }*/
        }
    }
    
    var body: some View {
        ZStack {
            ColorConstants.backgroundColor
                .ignoresSafeArea()
            
            VStack {
                ImageTextFieldView(textValue: $planTitle, isSecurityField: false, placeholderText: planTitle.isEmpty ? "Title" : planTitle ,imageName: "pencil")
                
                ImageTextFieldView(textValue: $description, isSecurityField: false, placeholderText: description.isEmpty ? "Description" : description ,imageName: "pencil")
                
                DatePicker("Finish date", selection: $finishDate)
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
                            planState = option
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
                    NotificationSettingsView(notifyDate: $notifyDate, locationRadius: $locationRadius)
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
            viewModel.updatePlan(title: planTitle, finishDate: finishDate, planDescription: description, planState: planState, notifications: viewModel.createNotificationData(notifyAt: notifyDate, notifyRadius: locationRadius, placeId: placeId))
        } else {
            viewModel.addPlan(title: planTitle, finishDate: finishDate, placeId: placeId, planDescription: description, planState: planState, placeCoordinate: coordinate, notifyAt: notifyDate, notifyRadius: locationRadius)
        }
    }
}
