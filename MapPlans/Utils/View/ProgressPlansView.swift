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
    var horizontalPadding: CGFloat = 15
    
    var body: some View {
        VStack {
            RoundedBackgroundView(mainColor: ColorConstants.backgroundColor)
                .frame(maxWidth: maxWidth)
                .overlay(alignment: .leading) {
                    RoundedBackgroundView(mainColor: ColorConstants.sliderColor, showLine: false)
                        .frame(width: currentWidth)
                }
                .overlay {
                    Text(progressText)
                        .font(.system(size: 18))
                        .fontWeight(.heavy)
                        .padding(.vertical)
                }
                .frame(maxHeight: 24)
            
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
        .padding(.horizontal,horizontalPadding)
    }
    
    var currentWidth: CGFloat {
        let currentResult = maxValue == 0 ? 0 : currentValue/maxValue
        let result = (maxWidth - horizontalPadding*2) * CGFloat(currentResult)
        return result
    }
    
    func getCorners() -> UIRectCorner {
        return currentValue == maxValue ? [.allCorners] : [.bottomLeft, .topLeft]
    }
}

struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressPlansView(currentValue: 5, maxValue: 10)
    }
}
