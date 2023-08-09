//
//  ContentView.swift
//  MapPlans
//
//  Created by Tobias on 01.08.2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var mapViewModel = MapViewModel()
    
    var body: some View {
       MapView()
            .environmentObject(mapViewModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
