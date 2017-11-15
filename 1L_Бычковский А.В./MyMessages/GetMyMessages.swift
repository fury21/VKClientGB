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
    
    // allDialogs
    @objc dynamic var dialogId = 0
    @objc dynamic var userId = 0
    @objc dynamic var date = 0
    @objc dynamic var body = "" // входящие сообщения
    @objc dynamic var read_state = 0 // статус сообщения (0 — не прочитано собеседником)
    @objc dynamic var unread = 0 //  сколько мной не прочитано сообщений
    
    // friendsData
    @objc dynamic var friendId = 0
    @objc dynamic var friendPhoto = ""
    @objc dynamic var friendfullName = ""
    
    // groupsData
    @objc dynamic var groupId = 0
    @objc dynamic var groupName = ""
    @objc dynamic var groupPhoto = ""
    
    // currentUserData
    @objc dynamic var currentUserMiniPhoto = ""
    
    convenience init(json: JSON) {
        self.init()
        dialogId = json["message"]["id"].intValue
        userId = json["message"]["user_id"].intValue
        date = json["message"]["date"].intValue
        body = json["message"]["body"].stringValue
        read_state = json["message"]["read_state"].intValue
        unread = json["unread"].intValue
    }
    
    convenience init(jsonFriendsData json: JSON) {
        self.init()
        friendId = json["id"].intValue
        friendPhoto = json["photo_50"].stringValue
        friendfullName = json["first_name"].stringValue + " " + json["last_name"].stringValue
    }
    
    convenience init(jsonGroupsData json: JSON) {
        self.init()
        groupId = json["id"].intValue
        groupPhoto = json["photo_50"].stringValue
        groupName = json["name"].stringValue
    }
    
    convenience init(jsonCurrentUserData json: JSON) {
        self.init()
        currentUserMiniPhoto = json["photo_50"].stringValue
    }
}
