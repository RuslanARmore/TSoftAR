//
//  WebService.swift
//  GPO
//
//  Created by Руслан Ахриев on 16.01.2018.
//  Copyright © 2018 Руслан Ахриев. All rights reserved.
//

import Foundation

class WebService  {
 
    
    func postMethod(_ url : String,
                    _ parameters : [String : String],
                    _ headers : [String : String]) -> Data {
        
   
        var result = Data()
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        
        let bodyData = connectElements(parameters: parameters)
       
        for (header , value) in headers {
            request.addValue(value, forHTTPHeaderField: header)
            print(value , header)
        }
        
        request.httpBody = bodyData.data(using: String.Encoding.utf8)
        URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            guard let data = data else { return }
            result = data
            print(result)
        }.resume()
        print(result)
        return result
    }
    
    struct ErrorPassword : Decodable {
        let error : String
        let error_description : String
    }
    
    func parseJSON<T : Decodable>(_ data : Data,_ strct : T.Type ) {
        
    }
    func connectElements(parameters : [String : String]) -> String {
        var bodyData = ""
        for (parameter , lol ) in parameters {
            let buf = "\(parameter)=\(lol)&"
            bodyData = bodyData + buf
        }
        return String(bodyData.dropLast())
    }
    
}
