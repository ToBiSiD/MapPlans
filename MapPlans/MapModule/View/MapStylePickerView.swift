//
//  MapStylePickerView.swift
//  MapPlans
//
//  Created by Tobias on 01.08.2023.
//

import SwiftUI

struct MapStylePickerView: View {
    @Binding var style: MapStyleOption
    
    var body: some View {
        HStack (spacing: 5) {
            Picker("" ,selection: $style) {
                ForEachCustomOptionView(data: MapStyleOption.allCases) { option in
                    Image(systemName: option.optionImage)
                }
            }
            .pickerStyle(.segmented)
            .padding()
        }
        .frame(width: 140)
    }
}

struct MapStylePickerView_Previews: PreviewProvider {
    static var previews: some View {
        MapStylePickerView(style: .constant(.satellite))
    }
}
