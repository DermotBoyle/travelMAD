//
//  MapView.swift
//  Weaver_Widget_Demo
//
//  Created by Dermot Boyle on 9/5/23.
//

import SwiftUI
import MapKit
import UIKit

struct MapView: View {
    let location: [Double]?
    let locations: [Location]?
    let onClickOfStopIcon: () -> Void?
    @ObservedObject var mapViewModel: MapViewModel
    
    
    init(location: [Double]?, locations: [Location]?, onClickOfStopIcon: @escaping () -> Void?) {
        let locationManager = LocationManager()
        let myCoords = locationManager.getLonLat()
        
        self.location = location
        self.mapViewModel = MapViewModel(location: location ?? [])
        self.locations = locations ?? []
        self.onClickOfStopIcon = onClickOfStopIcon
    }
    
    var body: some View {
        Map(coordinateRegion: $mapViewModel.region, showsUserLocation: true, annotationItems: locations ?? []) { location in
            MapAnnotation(coordinate: location.coordinates) {
                BusIconGlow()
                    .onTapGesture {
                        onClickOfStopIcon()
                    }
            }
        }.accentColor(Color("Background"))
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(location: nil, locations: nil, onClickOfStopIcon: {})
    }
}


struct LandmarkAnnotation: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
}



