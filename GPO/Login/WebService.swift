//
//  WebService.swift
//  GPO
//
//  Created by Руслан Ахриев on 16.01.2018.
//  Copyright © 2018 Руслан Ахриев. All rights reserved.
//

import Foundation

class WebService {
  static func logIn(_ login : String, _ password : String) {
      
        
        var request = URLRequest(url:URL(string: "http://codesurvey.r-mobile.pro/api/token")!)
        request.httpMethod = "POST"
        
        let params =  [
            "grant_type" : "password",
            "username" : login,
            "password" : password
        ]
    
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Basic ZGV2OnRlc3Q=", forHTTPHeaderField: "Authorization")
    
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        
        URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            if let response = response {
                print(response)
            }
            guard let data = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options:[])
                print(json)
            } catch {
                print(error)
            }
        }.resume()
        
   
    }
}
