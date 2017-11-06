//
//  GetMyMessages.swift
//  1L_Бычковский А.В.
//
//  Created by Александр Б. on 02.11.2017.
//  Copyright © 2017 Александр Б. All rights reserved.
//


import SwiftyJSON
import RealmSwift

class GetMyMessages: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var user_id  = 0
    @objc dynamic var from_id = 0
    @objc dynamic var date = 0
    @objc dynamic var title = ""
    @objc dynamic var  body = ""
    
    convenience init(json: JSON) {
        self.init()
        
        id = json["id"].intValue
        user_id = json["user_id"].intValue
        from_id = json["from_id"].intValue
        date = json["date"].intValue
        title  = json["title"].stringValue
        body = json["body"].stringValue
        
    }
}
