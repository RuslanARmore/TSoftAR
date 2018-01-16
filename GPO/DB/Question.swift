//
//  Question.swift
//  GPO
//
//  Created by Руслан Ахриев on 05.01.2018.
//  Copyright © 2018 Руслан Ахриев. All rights reserved.
//

import Foundation
import RealmSwift

class Question: Object {
    
    @objc dynamic var ID_QUESTION = 0
    @objc dynamic var ID_SURVEY = 0
    @objc dynamic var TITLE = ""
    @objc dynamic var TYPE = ""
    
    @objc dynamic var id = 0
    override static func primaryKey() -> String? {
        return "id"
    }
}
