//
//  GetMyFriends.swift
//  1L_Бычковский А.В.
//
//  Created by Александр Б. on 01.10.2017.
//  Copyright © 2017 Александр Б. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class GetMyFriends: Object {
    @objc dynamic var id = 0
    @objc dynamic var friendFullName = ""
    @objc dynamic var friendPhoto50 = ""
    @objc dynamic var frindsOnlineStatus = "offline"
    //@objc dynamic var friendsDevice = ""
    

    convenience init(json: JSON) {
        self.init()
        id = json["id"].intValue
        friendFullName = json["first_name"].stringValue + " " + json["last_name"].stringValue
        friendPhoto50 = json["photo_50"].stringValue
        if json["online"].intValue == 1 {
          if json["last_seen"]["platform"].intValue != 7 { frindsOnlineStatus = "online_mobile" } else { frindsOnlineStatus = "online_pc" }
        } else {
            frindsOnlineStatus = "offline"
        }
    }
    
    override static func primaryKey() -> String {
        return "id"
    }
}
