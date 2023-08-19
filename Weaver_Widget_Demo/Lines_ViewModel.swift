import Foundation
import Combine
import CoreData

class LinesViewModel: ObservableObject {
    var cancellable: AnyCancellable?
    var accessToken = getSavedToken()
    
    func fetchData() {
        if accessToken.isEmpty {
            getSavedToken()
            fetchData()
        }
        
        let url = URL(string: "https://openapi.emtmadrid.es/v1/transport/busemtmad/stops/list/")
        
        if let url = url {
            var request = URLRequest(url: url)
            request.setValue(accessToken, forHTTPHeaderField: "accessToken")
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print(error)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    print("Error \(String(describing: response))")
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    let ListOfStopsData = try JSONDecoder().decode(ListStops.self, from: data)
                    let stopData = ListOfStopsData.data
                                        
                    stopData.forEach { stop in
                        
                    }
                    
                
                } catch {
                    print("Error decoding JSON")
                }
                
            }
            .resume()
        }
    }
}

struct ListStops: Codable {
    let code: String
    let data: [StopData]
    let description: String
    let datetime: String
}

struct StopData: Codable, Identifiable {
    let id = UUID()
    let node: String
    let geometry: GeometryData
    let wifi: String
    let lines: [String]
    let name: String
}

public struct GeometryData: Codable {
    let type: String
    let coordinates: [Double]
}




