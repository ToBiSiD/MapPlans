//
//  RoundedBackgroundView.swift
//  MapPlans
//
//  Created by Tobias on 15.08.2023.
//

import SwiftUI

struct RoundedBackgroundView: View {
    var mainColor: Color = ColorConstants.backgroundTintColor
    var showLine: Bool = true
    
    var body: some View {
        ZStack {
            if(showLine){
                RoundedRectangle(cornerRadius: ValueConstants.defaultCornerRadius)
                    .stroke(ColorConstants.shadowColor, lineWidth: 1)
            }
            
            
            RoundedRectangle(cornerRadius: ValueConstants.defaultCornerRadius)
                .fill(mainColor)
                .padding(1)
        }
        .shadow(color: ColorConstants.shadowColor, radius: ValueConstants.defaultShadowRadius)
    }
}

struct RoundedBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        RoundedBackgroundView()
    }
}
