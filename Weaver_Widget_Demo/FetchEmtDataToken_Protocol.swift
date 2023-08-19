//
//  FetchEmtData_Protocol.swift
//  Weaver_Widget_Demo
//
//  Created by Dermot Boyle on 2/4/23.
//

import Foundation

class NetworkManager: ObservableObject{
    
    func hasTokenBeenFetched() -> Bool{
        let str = UserDefaults.standard.object(forKey: "token") as! String
        return str.count > 0 ? true : false
    }
    
    func getEmtData(){
        let EMT_URL = "https://openapi.emtmadrid.es/v2/mobilitylabs/user/login/"
        let EMAIL = ""
        let PASSWORD = ""
        
        let encodedURL = NSURL(string: EMT_URL)
        let apiRequest = NSMutableURLRequest(url: encodedURL! as URL)
        apiRequest.setValue(EMAIL, forHTTPHeaderField: "email")
        apiRequest.setValue(PASSWORD, forHTTPHeaderField: "password")
        apiRequest.httpMethod = "GET"
        apiRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        
        let task = session.dataTask(with: apiRequest as URLRequest){(data, response, error) -> Void in
            if let res = response as? HTTPURLResponse {
                print("Successfully retrieved TOKEN")
            } else {
                print("Error: \(String(describing: error))")
            }
            
            guard let data = data else { return }
            let tokenData = try! JSONDecoder().decode(EMTdata.self, from: data)
            UserDefaults.standard.set(tokenData.data[0].accessToken, forKey: "token")
        }
        task.resume()
    }
    
    init(){
        self.getEmtData()
    }
}

struct EMTdata: Decodable {
    let data: [TokenInfo]
}

struct TokenInfo: Decodable {
    let username: String
    let accessToken: String
    let tokenSecExpiration: Int
}
