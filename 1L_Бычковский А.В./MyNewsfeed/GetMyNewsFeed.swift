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
    @objc dynamic var attachments_typePhoto: String = "" // фото поста (вложение)
    @objc dynamic var attachments_photoSize = ""
    @objc dynamic var post_id = 0 // id новости
    
    @objc dynamic var commentsCount = 0
    @objc dynamic var likesCount = 0
    @objc dynamic var commentCanPost = 0
    
    @objc dynamic var userLikes = 0
    
    @objc dynamic var repostsCount = 0
    
    @objc dynamic var viwesCount = 0
    
    
    convenience init(json: JSON) {
        self.init()
        postSource_id = json["source_id"].intValue
        postText = json["text"].stringValue
        titlePostTime = json["date"].doubleValue
        
        attachments_typePhoto = json["attachments"][0]["photo"]["photo_604"].stringValue
        if !json["attachments"][0]["photo"]["width"].stringValue.isEmpty {
            attachments_photoSize = json["attachments"][0]["photo"]["width"].stringValue + "x" + json["attachments"][0]["photo"]["height"].stringValue
        }
        
        post_id = json["post_id"].intValue
        
        commentsCount = json["comments"]["count"].intValue
        likesCount = json["likes"]["count"].intValue
        commentCanPost = json["comments"]["can_post"].intValue
        userLikes = json["likes"]["user_likes"].intValue
        repostsCount = json["reposts"]["count"].intValue
        viwesCount = json["views"]["count"].intValue
    }
    
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
    
//    override static func primaryKey() -> String {
//        return "id"
//    }
}

