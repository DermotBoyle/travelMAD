//
//  NetworkUtils.swift
//  Weaver_Widget_Demo
//
//  Created by Dermot Boyle on 13/5/23.
//

import Foundation


func getSavedToken () -> String {
    var accessToken:String = ""
    
    if let unwrappedToken = UserDefaults.standard.object(forKey: "token") as? String {
       accessToken = unwrappedToken
    } else {
       NetworkManager()
    }
    
    return accessToken
}

