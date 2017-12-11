//
//  firebaseVKStruct.swift
//  1L_Бычковский А.В.
//
//  Created by Александр Б. on 28.11.2017.
//  Copyright © 2017 Александр Б. All rights reserved.
//

import Foundation

struct firebaseVKStruct {
    let name: String
    let date: String
    let id: Int
    
    var toAnyObject: Any {
        return [
            "name": name,
            "date": date,
            "id": id
        ]
    }
}
