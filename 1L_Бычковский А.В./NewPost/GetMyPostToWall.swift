//
//  GetMyPostToWall.swift
//  1L_Бычковский А.В.
//
//  Created by Александр Б. on 19.11.2017.
//  Copyright © 2017 Александр Б. All rights reserved.
//

import SwiftyJSON
import RealmSwift

class GetMyPostToWall: Object {
    
    @objc dynamic var photo = ""
    @objc dynamic var server = ""
    @objc dynamic var hashValue1 = "" // hashValue, типа, занят
    @objc dynamic var serverUpload_url = ""
    
    
    convenience init(json: JSON) {
        self.init()
        photo = json["photo"].stringValue
        server = json["server"].stringValue
        hashValue1 = json["hash"].stringValue
    }
    
    convenience init(getServerUrl json: JSON) {
        self.init()
        serverUpload_url = json["upload_url"].stringValue
    }
}
