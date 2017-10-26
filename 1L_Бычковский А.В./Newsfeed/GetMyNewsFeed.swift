//
//  GetMyNewsFeed.swift
//  1L_Бычковский А.В.
//
//  Created by Александр Б. on 19.10.2017.
//  Copyright © 2017 Александр Б. All rights reserved.
//


import Foundation
import SwiftyJSON
import RealmSwift

class GetMyNewsFeed: Object {
    // фото и название группы или пользователя
    @objc dynamic var titlePostId = 0
    @objc dynamic var titlePostPhoto = ""
    @objc dynamic var titlePostLabel = ""
    @objc dynamic var titlePostTime: Double = 0.0
    
    // сам пост
    @objc dynamic var postSource_id = 0 // с минусом группа, иначе пользователь
    @objc dynamic var postText = "" // текст к посту
    @objc dynamic var attachments_typePhoto = "" // фото поста (вложение)
    
    
    convenience init(jsonTitlePostPhotoAndLabelUser json: JSON) {
        self.init()
        titlePostId = json["id"].intValue
        titlePostPhoto = json["photo_50"].stringValue
        titlePostLabel = json["first_name"].stringValue + " " + json["last_name"].stringValue
    }
    
    convenience init(jsonTitlePostPhotoAndLabelGroup json: JSON) {
        self.init()
        titlePostId = json["id"].intValue
        titlePostLabel = json["name"].stringValue
        titlePostPhoto = json["photo_50"].stringValue
    }
    
    convenience init(json: JSON) {
        self.init()
        titlePostTime = json["date"].doubleValue
        
        postSource_id = json["source_id"].intValue
        postText = json["text"].stringValue
        attachments_typePhoto = json["attachments"][0]["photo"]["photo_604"].stringValue
    }
    
//    override static func primaryKey() -> String {
//        return "id"
//    }
}

