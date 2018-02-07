//
//  JSONParser.swift
//  GPO
//
//  Created by Руслан Ахриев on 05.02.2018.
//  Copyright © 2018 Руслан Ахриев. All rights reserved.
//

import Foundation

class JSONParser {
    struct ErrorPassword : Decodable {
        let error : String
        let error_description : String
    }
    
    func parseJSON<T : Decodable>(_ data : Data,_ strct : T.Type ) {
        
        do {
            let decoder = JSONDecoder()
            let access = try decoder.decode(strct.self, from: data)
            print(access)
        } catch {
            do {
            let decoder = JSONDecoder()
            let errorPassword = try decoder.decode(ErrorPassword.self, from: data)
                print(errorPassword)
            } catch {
                print(error)
            }
        }
        
    }
}
