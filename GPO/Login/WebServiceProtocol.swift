//
//  WebServiceProtocol.swift
//  GPO
//
//  Created by Руслан Ахриев on 04.02.2018.
//  Copyright © 2018 Руслан Ахриев. All rights reserved.
//

import Foundation
protocol WebServiceProtocol {
    func postMethod(_ url : String,_ parameters : [String : String],_ headers : [String : String], completionBlock: @escaping (_ response :Data?) -> Void)
    func getMethod(_ url : String,_ parameters : [String : String], completionBlock: @escaping (_ response : Data?) -> Void)
}
