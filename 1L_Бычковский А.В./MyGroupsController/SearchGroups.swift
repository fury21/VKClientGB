//
//  SearchGroups.swift
//  1L_Бычковский А.В.
//
//  Created by Александр Б. on 01.10.2017.
//  Copyright © 2017 Александр Б. All rights reserved.
//

import Foundation
import SwiftyJSON

class SearchGroups {
    var groupName = ""
    var groupImg50 = ""
    
    init(json: JSON) {
        groupName = json["name"].stringValue
        groupImg50 = json["photo_50"].stringValue
    }
}
