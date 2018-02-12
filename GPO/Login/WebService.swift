//
//  WebService.swift
//  GPO
//
//  Created by Руслан Ахриев on 16.01.2018.
//  Copyright © 2018 Руслан Ахриев. All rights reserved.
//

import Foundation

class WebService : WebServiceProtocol  {
 

    
    func postMethod(_ url : String,
                    _ parameters : [String : String],
                    _ headers : [String : String],
                    completionBlock: @escaping (_ response : Data?) -> Void)   {
        
   
      
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
            let response = data
            completionBlock(response)
        }.resume()
    }
    
    func getMethod(_ url : String, _ headers : [String : String], completionBlock: @escaping (_ response : Data?) -> Void) {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        for (header , value) in headers {
            request.addValue(value, forHTTPHeaderField: header)
        }
        
        URLSession.shared.dataTask(with: request) { (data : Data?, response : URLResponse?, error : Error?) in
            guard let data = data else { return }
            let response = data
            completionBlock(response)
        }.resume()
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
