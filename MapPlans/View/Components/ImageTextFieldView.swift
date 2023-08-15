//
//  ImageTextFieldView.swift
//  MapPlans
//
//  Created by Tobias on 02.08.2023.
//

import SwiftUI

struct ImageTextFieldView: View {
    @Binding var textValue: String
    let isSecurityField: Bool
    let placeholderText: String
    var imageName: String = ""
    var padding: CGFloat = 10
    var cornerRadius: CGFloat = ValueConstants.defaultCornerRadius
    var horizontalPadding: CGFloat = 30
    var imagePadding: CGFloat = 5
    var buttonSubmitLable: SubmitLabel = .continue
    var submitAction: (() -> Void)?
    
    var body: some View {
        ZStack {
            RoundedBackgroundView()
            .frame(maxHeight: 40)
            
            mainView
                .frame(maxHeight: 40)
                .padding(.horizontal)
            
        }
        .padding(padding)
        .padding(.horizontal, horizontalPadding)
        
    }
    
    var mainView : some View {
        HStack {
            if(!imageName.isEmpty){
                HStack {
                    Image(systemName: imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(ColorConstants.textTintColor)
                }
                .padding(.horizontal, imagePadding)
            }
            
            if isSecurityField {
                SecureField("", text: $textValue)
                    .foregroundColor(ColorConstants.textColor)
                    .placeholder(when: textValue.isEmpty, placeholder: {
                        Text(placeholderText).foregroundColor(ColorConstants.textTintColor)
                    })
                    .submitLabel(buttonSubmitLable)
                    .onSubmit {
                        if let submitAction = submitAction{
                            submitAction()
                        }
                    }
                    .font(.subheadline)
            } else {
                TextField("", text: $textValue)
                    .foregroundColor(ColorConstants.textColor)
                    .placeholder(when: textValue.isEmpty, placeholder: {
                        Text(placeholderText).foregroundColor(ColorConstants.textTintColor)
                    })
                    .submitLabel(buttonSubmitLable)
                    .onSubmit {
                        if let submitAction = submitAction{
                            submitAction()
                        }
                    }
                    .font(.subheadline)
            }
        }
    }
}
