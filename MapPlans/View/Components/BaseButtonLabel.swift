//
//  BaseButtonLabel.swift
//  MapPlans
//
//  Created by Tobias on 08.08.2023.
//

import SwiftUI

struct BaseButtonLabel: View {
    var text: String = ""
    var imageName: String = ""
    var bacgroundColor: Color = .blue
    var foregroundColor: Color = .white
    
    var body: some View {
        ZStack {
            bacgroundColor
                .cornerRadius(10)
            
            HStack {
                if !imageName.isEmpty {
                    Image(systemName: imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 15, height: 15)
                        
                }
                
                Text(text)
                    .font(.footnote)
            }
            .fontWeight(.heavy)
            .foregroundColor(foregroundColor)
        }
    }
}

struct BaseButtonLabel_Previews: PreviewProvider {
    static var previews: some View {
        BaseButtonLabel(text: "TEXT", imageName: "figure.walk" )
    }
}
