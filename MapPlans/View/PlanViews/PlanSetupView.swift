//
//  PlanSetupView.swift
//  MapPlans
//
//  Created by Tobias on 02.08.2023.
//

import SwiftUI

struct PlanSetupView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject private var viewModel: PlanSetupViewModel
    @State var planTitle: String = ""
    @State var description: String = ""
    @State var planState: PlanState = .toDo
    @State var finishDate: Date = Date()
    
    private var placeId: String = ""
    
    init(placeId: String, plan: Plan? = nil) {
        self.placeId = placeId
        self.viewModel = PlanSetupViewModel(plan: plan)
        if let plan = plan {
            self.planTitle = plan.title
            self.planState = plan.planState
            if let description = plan.planDescription {
                self.description = description
            }
            
            if let finish = plan.finishDate {
                self.finishDate = finish
            }
        }
    }
    
    var body: some View {
        VStack {
            ImageTextFieldView(textValue: $planTitle, isSecurityField: false, placeholderText: "Title",imageName: "pencil")
            
            ImageTextFieldView(textValue: $description, isSecurityField: false, placeholderText: "Description",imageName: "pencil")
            
            DatePicker("Finish date", selection: $finishDate)
                .datePickerStyle(.compact)
                .padding()
            
            HStack {
                Text("State")
                    .font(.subheadline)
                
                Spacer()
                
                if let options = PlanState.allCases as? [PlanState] {
                    
                    DropdownSelectorView(defaultOption: viewModel.plan?.planState ?? .toDo, options: options) { option in
                        planState = option
                    }
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            Button {
                finishSetup()
                dismiss()
            } label: {
                Text(viewModel.plan == nil ? "Create" : "Update")
                    .frame(width: 340, height: 44)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .shadow(color: .gray, radius: 8)
            }

        }
        .padding(.vertical, 20)
    }
    
    private func finishSetup() {
        if viewModel.plan != nil {
            viewModel.updatePlan(title: planTitle, finishDate: finishDate, planDescription: description, planState: planState)
        } else {
            viewModel.addPlan(title: planTitle, finishDate: finishDate, placeId: placeId, planDescription: description, planState: planState)
        }
    }
}

struct PlanSetupView_Previews: PreviewProvider {
    static var previews: some View {
        PlanSetupView(placeId: "unknown", plan: Plan.MockPlan)
    }
}
