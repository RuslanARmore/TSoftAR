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

    
        let bodyData = "grant_type=password&username=\(login)&password=\(password)"
        var request = URLRequest(url: URL(string: "http://codesurvey.r-mobile.pro/api/token")!)
    
        request.httpMethod = "POST"
        request.addValue("Basic ZGV2OnRlc3Q=", forHTTPHeaderField: "Authorization")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        request.httpBody = bodyData.data(using: String.Encoding.utf8)
    
        URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            
            guard let data = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options:[])
                print("lol")
                print(json)
                do {
                    let decoder = JSONDecoder()
                    let access = try decoder.decode(AccessToken.self, from: data)
                } catch {
                        let decoder = JSONDecoder()
                        let errorPassword = try decoder.decode(ErrorPassword.self, from: data)
                }
                
            } catch {
                print(error)
            }
        }.resume()
    }
    
    struct AccessToken : Decodable {
        let expires: String
        let issued: String
        let access_token: String
        let expires_in: Int
        let token_type: String
        let user_name: String
            enum CodingKeys : String, CodingKey {
                case expires = ".expires"
                case issued = ".issued"
                case access_token
                case expires_in
                case token_type
                case user_name
            }
    }
    
    struct ErrorPassword : Decodable {
        let error : String
        let error_description : String
    }
    
   
}
