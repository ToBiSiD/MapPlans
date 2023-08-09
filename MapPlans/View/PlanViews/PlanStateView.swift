//
//  PlanStateView.swift
//  MapPlans
//
//  Created by Tobias on 08.08.2023.
//

import SwiftUI

struct PlanStateView: View {
    let option: PlanState
    var fontSize: CGFloat = 14
    var iconSize: CGFloat = 20
    var circleSize: CGFloat = 16
    var isReverse: Bool = false
    
    var body: some View {
        if isReverse {
            stateTitle
        }
        
        ZStack {
            Circle()
                .foregroundColor(option.optionColor)
                .frame(width: circleSize)
            
            Image(systemName: option.optionImage)
                .frame(width: iconSize)
                .foregroundColor(.black)
        }
        
        if !isReverse {
            stateTitle
        }
    }
    
    var stateTitle: some View {
        Text(self.option.optionTitle)
            .font(.system(size: fontSize))
            .foregroundColor(Color.black)
    }
}

struct PlanStateView_Previews: PreviewProvider {
    static var previews: some View {
        PlanStateView(option: .toDo)
    }
}
