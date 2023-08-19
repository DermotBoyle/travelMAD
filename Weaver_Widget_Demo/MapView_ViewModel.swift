//
//  MapView_ViewModel.swift
//  Weaver_Widget_Demo
//
//  Created by Dermot Boyle on 9/5/23.
//

import Foundation
import MapKit


class MapViewModel: ObservableObject {
    
    @Published var region: MKCoordinateRegion
    var location: [Double]?
    
    init(location: [Double]? = nil){
        //Pass in specific location to center
        if let location = location {
            let adjustedCenter = CLLocationCoordinate2D(latitude: location[1] - 0.005, longitude: location[0])
            self.region = MKCoordinateRegion(center: adjustedCenter, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        } else {
            // Default to SOL
            self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40.416729, longitude: -3.703339), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
            
            // Get current location
            let locationManager = LocationManager()
            var lonLat = locationManager.getLonLat()
            
            if let latitude = lonLat["latitude"], let longitude = lonLat["longitude"] {
                // use the latitude and longitude values here
                self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            } else {
                // handle the case where the latitude or longitude value is nil
                print("Unable to get location data.")
            }
        }
    }
}


struct Location: Identifiable {
    let id = UUID()
    let name: String
    let coordinates: CLLocationCoordinate2D
}
