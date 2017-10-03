//
//  GetMyGroups.swift
//  1L_Бычковский А.В.
//
//  Created by Александр Б. on 30.09.2017.
//  Copyright © 2017 Александр Б. All rights reserved.
//

import Foundation
import SwiftyJSON

class GetMyGroups {
    
    var groupName = ""
    var groupIsClosed = [Int]()
    var groupPhoto50 = ""
    
    init(json: JSON) {
        groupName = json["name"].stringValue
        groupPhoto50 = json["photo_50"].stringValue
    }
}
