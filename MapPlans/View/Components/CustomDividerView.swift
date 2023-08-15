//
//  CustomDividerView.swift
//  MapPlans
//
//  Created by Tobias on 15.08.2023.
//

import SwiftUI

struct CustomDividerView: View {
    var width: CGFloat = .infinity
    var height: CGFloat = 1
    var color: Color = ColorConstants.shadowColor
    
    var body: some View {
        Rectangle()
            .frame(maxWidth: width, maxHeight: height)
            .background(color)
    }
}

struct CustomDividerView_Previews: PreviewProvider {
    static var previews: some View {
        CustomDividerView()
    }
}
