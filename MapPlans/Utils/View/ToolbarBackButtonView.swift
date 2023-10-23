//
//  ToolbarBackButtonView.swift
//  MapPlans
//
//  Created by Tobias on 15.08.2023.
//

import SwiftUI

struct ToolbarBackButtonView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Button {
            dismiss()
        } label: {
            HStack {
                ZStack {
                    Circle()
                        .frame(width: 30)
                        .foregroundColor(ColorConstants.textColor)
                    
                    Image(systemName: "chevron.backward.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .scaledToFill()
                        .foregroundColor(ColorConstants.buttonColor)
                }
                
                Text("Back")
                    .font(.title3)
                    .fontWeight(.heavy)
                    .foregroundColor(ColorConstants.textColor)
            }
        }
    }
}

struct ToolbarBackButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ToolbarBackButtonView()
    }
}
