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

        let params =  [
            "grant_type" : "password",
            "username" : login,
            "password" : password
        ]
        let bodyData = "grant_type=password&username=\(login)&password=\(password)"
        var request = URLRequest(url: URL(string: "http://codesurvey.r-mobile.pro/api/token")!)
    
        request.httpMethod = "POST"
        request.addValue("Basic ZGV2OnRlc3Q=", forHTTPHeaderField: "Authorization")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    
    
  
        request.httpBody = bodyData.data(using: String.Encoding.utf8)
        
        URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            if let response = response {
                print(response)
            }
            guard let data = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options:[])
                print("lol")
                print(json)
            } catch {
                print(error)
            }
        }.resume()
        
   
    }
}
