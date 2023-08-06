//
//  ForEachView.swift
//  MapPlans
//
//  Created by Tobias on 01.08.2023.
//

import Foundation
import SwiftUI

struct ForEachCustomOptionView<T: CustomOption, Content: View>: View {
    let data: [T]
    let content: (T) -> Content

    init(data: [T], @ViewBuilder content: @escaping (T) -> Content) {
        self.data = data
        self.content = content
    }

    var body: some View {
        ForEach(data, id: \.self) { item in
            content(item)
        }
    }
}
