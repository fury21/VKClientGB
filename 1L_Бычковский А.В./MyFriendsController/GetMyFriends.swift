//
//  GetMyFriends.swift
//  1L_Бычковский А.В.
//
//  Created by Александр Б. on 01.10.2017.
//  Copyright © 2017 Александр Б. All rights reserved.
//

import Foundation
import SwiftyJSON

class GetMyFriends {
    var friendId = 0
    var friendFullName = ""
    var friendPhoto50 = ""
    var frindsOnlineStatus = "offline"
    
    
    init(json: JSON) {
        friendId = json["id"].intValue
        friendFullName = json["first_name"].stringValue + " " + json["last_name"].stringValue
        friendPhoto50 = json["photo_50"].stringValue
        if json["online"].intValue == 1 { frindsOnlineStatus = "online" } else { frindsOnlineStatus = "offline" }
    }
}
