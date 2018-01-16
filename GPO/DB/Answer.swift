//
//  Answer.swift
//  GPO
//
//  Created by Руслан Ахриев on 15.11.2017.
//  Copyright © 2017 Руслан Ахриев. All rights reserved.
//

import Foundation
import RealmSwift

class Answer: Object {
    @objc dynamic var ID_ANSWER = 0
    @objc dynamic var ID_QUESTION = 0
    @objc dynamic var TITLE = ""
    
    @objc dynamic var id = 0
    override static func primaryKey() -> String? {
        return "id"
    }
}
