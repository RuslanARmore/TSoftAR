//
//  Survey.swift
//  GPO
//
//  Created by Руслан Ахриев on 15.11.2017.
//  Copyright © 2017 Руслан Ахриев. All rights reserved.
//

import Foundation
import RealmSwift

class Survey: Object {
    @objc dynamic var title = ""
    @objc dynamic var instruction = ""
    
    @objc dynamic var id = 0
    override static func primaryKey() -> String? {
        return "id"
    }
}
