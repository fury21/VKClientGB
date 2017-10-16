//
//  GetMyGroups.swift
//  1L_Бычковский А.В.
//
//  Created by Александр Б. on 30.09.2017.
//  Copyright © 2017 Александр Б. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class GetMyGroups: Object {
    @objc dynamic var id = 0
    @objc dynamic var groupName = ""
    var groupIsClosed = [Int]()
    @objc dynamic var groupPhoto50 = ""
    
    convenience init(json: JSON) {
        self.init()
        id = json["id"].intValue
        groupName = json["name"].stringValue
        groupPhoto50 = json["photo_50"].stringValue
    }
    
    override static func primaryKey() -> String {
        return "id"
    }
}
