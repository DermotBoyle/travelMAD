//
//  BusStopDetailViewModel.swift
//  Weaver_Widget_Demo
//
//  Created by Dermot Boyle on 4/4/23.
//

import Foundation
import Combine

class BusArrivalViewModel: ObservableObject {
    let lineArrive = 132
    
    @Published var busArrivals: [StopArrivalWithId] = []
    private var cancellables = Set<AnyCancellable>()
    
    let body = [
        "cultureInfo":"EN",
        "Text_StopRequired_YN":"Y",
        "Text_EstimationsRequired_YN":"Y",
        "Text_IncidencesRequired_YN":"Y",
        "DateTime_Referenced_Incidencies_YYYYMMDD":"YYYYMMDD",
        
    ]
    
    func fetchBusArrivals(stopId: Int) {
        let EMT_URL = URL(string: "https://openapi.emtmadrid.es/v2/transport/busemtmad/stops/\(stopId)/arrives/")!
        let accessToken = UserDefaults.standard.object(forKey: "token") as! String
        
        var request = URLRequest(url: EMT_URL)
        request.setValue(accessToken, forHTTPHeaderField: "accessToken")
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted) // pass dictionary to data object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest){(data, response, error) -> Void in
            if let res = response as? HTTPURLResponse {
                print("Response: \(String(describing: response))")
            } else {
                print("Error: \(String(describing: error))")
            }
            
            guard let data = data else { return }
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    print(jsonResult)
                }
                
                let stopArrival = try JSONDecoder().decode(BusArrival.self, from: data)
                let stopArrivalInfo = stopArrival.data[0].Arrive.map { item in
                    StopArrivalWithId(
                        id: UUID(),
                        DistanceBus: item.DistanceBus,
                        estimateArrive: item.estimateArrive,
                        line: item.line,
                        destination: item.destination
                    )
                }
                DispatchQueue.main.async {
                    self.busArrivals = stopArrivalInfo
                }
            } catch let error {
                print(String(describing: error)) // <- ✅ Use this for debuging!
            }
        }
        task.resume()
    }
    
    func startTimer(stopId: Int){
        self.fetchBusArrivals(stopId: stopId)
        Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
            self.fetchBusArrivals(stopId: stopId)
        }
    }
}

struct BusArrival: Decodable {
    let data: [BusInformation]
}

struct BusInformation: Codable {
    let Arrive: [ArrivalData]
}

struct ArrivalData: Codable {
    let DistanceBus: Int
    let estimateArrive: Int
    let line: String
    let destination: String
}

struct StopArrivalWithId: Codable, Identifiable {
    let id: UUID
    let DistanceBus: Int
    let estimateArrive: Int
    let line: String
    let destination: String
}
