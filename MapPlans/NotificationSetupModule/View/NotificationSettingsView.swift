//
//  NotificationSettingsView.swift
//  MapPlans
//
//  Created by Tobias on 18.08.2023.
//

import SwiftUI

struct NotificationSettingsView: View {
    @State var notificationOption: NotificationOption = .schedule
    @Binding var notifyDate: Date
    @Binding var locationRadius: Int
    
    var body: some View {
        VStack {
            HStack {
                Text("Notification Option:")
                    .font(.subheadline)
                    .foregroundColor(ColorConstants.textColor)
                
                HStack (spacing: 5) {
                    Picker("" ,selection: $notificationOption) {
                        ForEachCustomOptionView(data: NotificationOption.allCases) { option in
                            Image(systemName: option.optionImage)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding()
                }
                .frame(width: 140)
                
                Spacer()
            }
            .padding(.horizontal)
            
            VStack(spacing: 20) {
                if notificationOption == .schedule || notificationOption == .all
                {
                    VStack{
                        HStack {
                            CustomDividerView()
                            
                            Text(NotificationOption.schedule.optionTitle)
                                .foregroundColor(ColorConstants.textColor)
                                .font(.caption2)
                                .fontWeight(.heavy)
                            
                            CustomDividerView()
                        }
                        
                        DatePicker("Notify at:", selection: $notifyDate)
                            .datePickerStyle(.compact)
                            .padding()
                            .font(.subheadline)
                            .foregroundColor(ColorConstants.textColor)
                    }
                }
            
                
                if notificationOption == .location ||
                    notificationOption == .all
                {
                    VStack {
                        HStack{
                            CustomDividerView()
                            
                            Text(NotificationOption.location.optionTitle)
                                .foregroundColor(ColorConstants.textColor)
                                .font(.caption2)
                                .fontWeight(.heavy)
                            
                            CustomDividerView()
                        }
                        
                        HStack {
                            Text("Notify in radius:")
                                .padding(.horizontal)
                                .font(.subheadline)
                                .foregroundColor(ColorConstants.textColor)

                            
                            radiusTextField
                        }
                    }
                    
                }
            }
        }
    }
    
    
    var radiusTextField: some View {
        ZStack {
            RoundedBackgroundView()
            .frame(maxHeight: 40)
            
            HStack {
                HStack {
                    Image(systemName: "pencil")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(ColorConstants.textTintColor)
                }
                .padding(.horizontal, 10)
                
                TextField("", value: $locationRadius, formatter: NumberFormatter())
                    .placeholder(when: locationRadius == 0, placeholder: {
                        Text("0")
                            .foregroundColor(ColorConstants.textTintColor)
                    })
                    .foregroundColor(ColorConstants.textColor)
                    .submitLabel(SubmitLabel.continue)
                    .font(.subheadline)
            }
        }
        .padding(10)
        .padding(.horizontal, 30)
    }
}

struct NotificationSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationSettingsView(notifyDate: .constant(Date()), locationRadius: .constant(0))
    }
}
