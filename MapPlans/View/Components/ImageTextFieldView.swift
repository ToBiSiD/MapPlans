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
    var cornerRadius: CGFloat = 15
    var horizontalPadding: CGFloat = 30
    var imagePadding: CGFloat = 5
    var buttonSubmitLable: SubmitLabel = .continue
    var submitAction: (() -> Void)?
    
    var body: some View {
        HStack {
            
            if(!imageName.isEmpty){
                HStack {
                    Image(systemName: imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        //.foregroundColor(Color("TextTintColor"))
                }
                .padding(.horizontal, imagePadding)
            }
            
            if isSecurityField {
                SecureField("", text: $textValue)
                    .foregroundColor(.white)//Color("TextColor"))
                    .placeholder(when: textValue.isEmpty, placeholder: {
                        Text(placeholderText)//.foregroundColor(Color("TextTintColor"))
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
                    .foregroundColor(.white)//Color("TextColor"))
                    .placeholder(when: textValue.isEmpty, placeholder: {
                        Text(placeholderText)//.foregroundColor(Color("TextTintColor"))
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
        .frame(maxHeight: 35)
        .padding(padding)
        //.background(Color("SelfColor"))
        .cornerRadius(cornerRadius)
        .padding(.horizontal, horizontalPadding)
        .shadow(color: .gray, radius: 10)
        
    }
}
