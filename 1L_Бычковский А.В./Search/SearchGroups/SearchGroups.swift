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
        var q = ""
        
        init(json: JSON) {
            q = json["name"].stringValue
        }
    }
