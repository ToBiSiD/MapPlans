//
//  ContentView.swift
//  MapPlans
//
//  Created by Tobias on 01.08.2023.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @ObservedObject var mapViewModel = MapViewModel()
    @ObservedObject var appState = AppState.shared
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorConstants.backgroundColor
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Image(systemName: "map")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .fontWeight(.heavy)
                        
                        Text("MapPlans")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                    }
                    .foregroundColor(ColorConstants.textColor)
                    .padding(.top, 50)
                    
                    Spacer()
                    
                    VStack {
                        HStack(spacing: 25) {
                            Spacer()
                            NavigationLink {
                                AllPlansView()
                            } label: {
                                BaseButtonLabel(text: "Plans", imageName: "list.bullet.clipboard")
                            }
                            
                            NavigationLink {
                                MapView()
                                    .environmentObject(mapViewModel)
                            } label: {
                                BaseButtonLabel(text: "Map", imageName: "map")
                            }
                            
                            Spacer()
                        }
                        .frame(maxHeight: 50)
                    }
                    .padding(.vertical)
                }
            }
        }
        .navigationViewStyle(.stack)
        .onAppear() {
           LocationManager.shared.location
        }
        .overlay {
            if appState.placeId != nil {
                NavigationLink {
                    PlacePlansView(placeId: appState.placeId ?? AppConstants.unknownPlaceId, placeTitle: "")
                } label: {
                    
                }
            } else {
                EmptyView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
