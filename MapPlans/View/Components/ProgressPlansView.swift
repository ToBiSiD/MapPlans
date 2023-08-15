//
//  ProgressPlansView.swift
//  MapPlans
//
//  Created by Tobias on 15.08.2023.
//

import SwiftUI

struct ProgressPlansView: View {
    var currentValue: Double = 1.0
    var maxValue: Double = 1.0
    var progressText: String = "2/3"
    let maxWidth: CGFloat = UIScreen.main.bounds.width
    
    var body: some View {
        VStack {
            RoundedBackgroundView(mainColor: ColorConstants.backgroundColor)
                .frame(maxWidth: maxWidth)
                .overlay(alignment: .leading) {
                    Rectangle()
                        .fill(ColorConstants.sliderColor)
                        .cornerRadius(ValueConstants.defaultCornerRadius, corners: getCorners())
                        .frame(width: currentWidth)
                }
                .overlay {
                    Text(progressText)
                        .font(.system(size: 14))
                        .fontWeight(.heavy)
                        .padding(.vertical)
                }
                .frame(maxHeight: 14)
            
            HStack {
                Text("Completed plans:")
                Text(progressText)
                    .fontWeight(.heavy)
                Spacer()
            }
            .font(.caption)
            .foregroundColor(ColorConstants.textColor)
            .padding()
        }
    }
    
    var currentWidth: CGFloat {
        let currentResult = maxValue == 0 ? 0 : currentValue/maxValue
        let result = (maxWidth) * CGFloat(currentResult)
        return result
    }
    
    func getCorners() -> UIRectCorner {
        return currentValue == maxValue ? [.allCorners] : [.bottomLeft, .topLeft]
    }
}

struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressPlansView()
    }
}
