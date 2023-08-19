//
//  FetchNearestStop.swift
//  Weaver_Widget_Demo
//
//  Created by Dermot Boyle on 2/4/23.
//

import Foundation
import CoreLocation



class FetchNearestStop: ObservableObject {
    
    @Published var nearestStopsData: [StopInformationWithId] = []
    
    func getNearestStopData(){
        
        let locationManager = LocationManager()
        let lonLat = locationManager.getLonLat()
        var EMT_URL: String?
        
        if let latitude = lonLat["latitude"], let longitude = lonLat["longitude"] {
            // use the latitude and longitude values here
            EMT_URL = "https://openapi.emtmadrid.es/v2/transport/busemtmad/stops/arroundxy/\(longitude)/\(latitude)/800/"
        } else {
            // handle the case where the latitude or longitude value is nil
            print("Unable to get location data.")
        }
        
        var accessToken = ""
        
        if let unwrappedToken = UserDefaults.standard.object(forKey: "token") as? String {
           accessToken = unwrappedToken
        } else {
            getNearestStopData()
        }
        
        let encodedURL = NSURL(string: EMT_URL!)
        let apiRequest = NSMutableURLRequest(url: encodedURL! as URL)
        apiRequest.setValue(accessToken, forHTTPHeaderField: "accessToken")
        apiRequest.httpMethod = "GET"
        apiRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        
        let task = session.dataTask(with: apiRequest as URLRequest){(data, response, error) -> Void in
            if let res = response as? HTTPURLResponse {
                print("res: \(String(describing: res))")
                print("Response: \(String(describing: response))")
            } else {
                print("Error: \(String(describing: error))")
            }
            
            guard let data = data else { return }
            do {
                let nearestStopData = try JSONDecoder().decode(NearestStopDataModel.self, from: data)
                
                let nearestStopDataWithId = nearestStopData.data.map{ item in
                    StopInformationWithId(stopId: item.stopId, stopName: item.stopName, metersToPoint: item.metersToPoint, geometry: item.geometry, lines: item.lines)
                }
                
                print(nearestStopDataWithId)
                
                DispatchQueue.main.async {
                    self.nearestStopsData = nearestStopDataWithId
                }
                
            } catch let error {
                print("Error decoding items: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}

struct NearestStopDataModel: Decodable {
    let data: [StopInformationWithId]
}

struct StopInformationWithId: Codable, Identifiable {
    let id = UUID ()
    let stopId: Int
    let stopName: String
    let metersToPoint: Int
    let geometry: Geometry
    let lines: [Line]

    enum CodingKeys: String, CodingKey {
        case stopId
        case stopName
        case metersToPoint
        case geometry
        case lines
    }
}

struct Line: Codable, Identifiable {
    let id = UUID()
    let line: String
}

struct Geometry: Codable {
let coordinates: [Double]
}

func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.last else { return }
    let latitude = location.coordinate.latitude
    let longitude = location.coordinate.longitude
    print("Latitude: \(latitude), Longitude: \(longitude)")
}
