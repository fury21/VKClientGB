//
//  VKService.swift
//  1L_Бычковский А.В.
//
//  Created by Александр Б. on 23.09.17.
//  Copyright © 2017 Александр Б. All rights reserved.

import Foundation
import Alamofire
import SwiftyJSON
import SwiftKeychainWrapper
import RealmSwift

class VKService {
    // параметры API ВКонтакте	
    let baseUrl = "https://api.vk.com"
    let userVkId = userDefaults.integer(forKey: "vkApiUser_id") // id страницы авторизованного пользователя
    let appId = 6232209 // id приложения в ВК
    
    
    // список друзей по id
    func loadVKAnyFriends(vKId: Int) {
        let path = "/method/friends.get"
        
        let parameters: Parameters = [
            "user_id": vKId,
            "fields": "photo_50,online",
            "access_token": KeychainWrapper.standard.string(forKey: "vkApiToken")!,
            "v": "5.68"
        ]
        
        let url = baseUrl + path
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            guard let data = response.value else { return }
            
            let json = JSON(data)
            
            let friends = json["response"]["items"].flatMap { GetMyFriends(json: $0.1) }
            print("ccc", friends)
            if !checkNewDataInRealm(jsonForGroups: nil, jsonForFriends: friends) { Realm.replaceDataInRealm(toNewObjects: friends) }
        }
    }
    
    // удаляет из друзей по id
    func deleteVKFromFriends(idFriendToDel: Int) {
        let path = "/method/friends.delete"
        
        let parameters: Parameters = [
            "user_id": idFriendToDel,
            "access_token": KeychainWrapper.standard.string(forKey: "vkApiToken")!,
            "v": "5.68"
        ]
        
        let url = baseUrl + path
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
//            guard let data = response.value else { return }

//            Пока входящий json не обрабатывается
//            let json = JSON(data)
//            let friends = json["response"]["items"].flatMap { GetMyFriends(json: $0.1) }
        }
    }
    
    
    // список групп по id
    func loadVKAnyGroups(vKId: Int) {
        let path = "/method/groups.get"
        
        let parameters: Parameters = [
            "user_id": vKId,
            "extended": 1,
            "access_token": KeychainWrapper.standard.string(forKey: "vkApiToken")!,
            "v": "5.68"
        ]
        
        let url = baseUrl + path
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            guard let data = response.value else { return }
            
            let json = JSON(data)
            
            let groups = json["response"]["items"].map { GetMyGroups(json: $0.1) }
            
            if !checkNewDataInRealm(jsonForGroups: groups, jsonForFriends: nil) { Realm.replaceDataInRealm(toNewObjects: groups) }
        }
    }
    
    
    // список фото по id
    func loadVKAnyPhotos(vKId: Int) {
        let path = "/method/photos.getAll"
        
        let parameters: Parameters = [
            "user_id": vKId,
            "count": 200,
            "access_token": KeychainWrapper.standard.string(forKey: "vkApiToken")!,
            "v": "5.68",
            "no_service_albums": "1"
        ]
        
        let url = baseUrl + path
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            
        }
    }
    
    // поиск новых групп по имени
    func searchVKAnyGroups(q: String, completion: @escaping ([GetMyGroups]) -> Void) {
        let path = "/method/groups.search"
        
        let parameters: Parameters = [
            "q": q,
            "count": 20,
            "access_token": KeychainWrapper.standard.string(forKey: "vkApiToken")!,
            "v": "5.68",
            "type": "group"
        ]
        
        let url = baseUrl + path
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            
            guard let data = response.value else { return }
            
            let json = JSON(data)
            
            let q = json["response"]["items"].flatMap { GetMyGroups(json: $0.1) }
            
            completion(q)
        }
    }
    
    enum joinAndLeaveGroup: String {
        case joinGroup = "/method/groups.join"
        case leaveGroup = "/method/groups.leave"
    }
    
    func joinAndLeaveAnyGroup(groupId: Int, action: joinAndLeaveGroup) {
        var path = ""
        
        if action == .joinGroup {
            path = joinAndLeaveGroup.joinGroup.rawValue
        } else {
            path = joinAndLeaveGroup.leaveGroup.rawValue
        }
        
        
        let parameters: Parameters = [
            "group_id": groupId,
            "access_token": KeychainWrapper.standard.string(forKey: "vkApiToken")!,
            "v": "5.68"
        ]
        
        let url = baseUrl + path
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            
        }
    }
    
    func loadVKFeedNews() {
        let path = "/method/newsfeed.get"
        
        let parameters: Parameters = [
            "filters": "post",
            "access_token": KeychainWrapper.standard.string(forKey: "vkApiToken")!,
            "v": "5.68"
        ]
        
        let url = baseUrl + path
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            guard let data = response.value else { return }
            
            let json = JSON(data)
            
            var newsFeed = json["response"]["items"].flatMap { GetMyNewsFeed(json: $0.1) }
            let newsFeed1 = json["response"]["profiles"].flatMap { GetMyNewsFeed(jsonTitlePostPhotoAndLabelUser: $0.1) }
            let newsFeed2 = json["response"]["groups"].flatMap { GetMyNewsFeed(jsonTitlePostPhotoAndLabelGroup: $0.1) }
            
            print("1+", newsFeed)
            print("1++", newsFeed1)
            print("1+++", newsFeed2)
            
            for i in 0..<newsFeed.count {
                if newsFeed[i].postSource_id < 0 {
                    for ii in 0..<newsFeed2.count {
                        if newsFeed[i].postSource_id * -1 == newsFeed2[ii].titlePostId {
                            newsFeed[i].titlePostId = newsFeed2[ii].titlePostId
                            newsFeed[i].titlePostLabel = newsFeed2[ii].titlePostLabel
                            newsFeed[i].titlePostPhoto = newsFeed2[ii].titlePostPhoto
                        }
                    }
                } else {
                    for iii in 0..<newsFeed1.count {
                        if newsFeed[i].postSource_id == newsFeed1[iii].titlePostId {
                            newsFeed[i].titlePostId = newsFeed1[iii].titlePostId
                            newsFeed[i].titlePostLabel = newsFeed1[iii].titlePostLabel
                            newsFeed[i].titlePostPhoto = newsFeed1[iii].titlePostPhoto
                        }
                    }
                }
            }
            print("++++", newsFeed)
            
//            if !checkNewDataInRealm(jsonForGroups: nil, jsonForFriends: newsFeed) { Realm.replaceDataInRealm(toNewObjects: newsFeed) }
            Realm.replaceDataInRealm(toNewObjects: newsFeed)
        }
    }
    
    
    // подготовка URL для WebViewController
    func getrequest() -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: String(appId)),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "offline,friends,photos,groups,messages,wall"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.68")
        ]
        
        let request = URLRequest(url: urlComponents.url!)
        //    print(request)
        return request
    }
    
    func timeAgo(time: Double) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(time))
     
        
        let unitFlags = Set<Calendar.Component>([.year, .month, .day, .hour, .minute, .second])
        let components = Calendar.current.dateComponents(unitFlags, from: date, to: Date())
        
        
        if components.year! % 100 > 10 && components.year! % 100 < 20 && components.year! > 0 {
            return "\(String(components.year!)) лет назад"
        }
        if components.year! % 10 == 1  && components.year! > 0 {
            return "\(String(components.year!)) год назад"
        } else if components.year! % 10 > 1 && components.year! % 10 < 5 && components.year! > 0  {
            return "\(String(components.year!)) год назад"
        } else if  components.year! > 0  {
            return "\(String(components.year!)) лет назад"
        }
        
        
        if components.month! % 100 > 10 && components.month! % 100 < 20 && components.month! > 0 {
            return "\(String(components.month!)) месяцев назад"
        }
        if components.month! % 10 == 1 && components.month! > 0 {
            return "\(String(components.month!)) месяц назад"
        } else if components.month! % 10 > 1 && components.month! % 10 < 5 && components.month! > 0 {
            return "\(String(components.month!)) месяца назад"
        } else if components.day! > 0 {
            return "\(String(components.month!)) месяцев назад"
        }
        
        
        if components.day! % 100 > 10 && components.day! % 100 < 20 && components.day! > 0 {
            return "\(String(components.day!)) дней назад"
        }
        if components.day! % 10 == 1 && components.day! > 0 && components.day! > 0 {
            return "\(String(components.day!)) день назад"
        } else if components.day! % 10 > 1 && components.day! % 10 < 5 && components.day! > 0 {
            return "\(String(components.day!)) дня назад"
        } else if components.day! > 0 {
            return "\(String(components.day!)) дней назад"
        }
        
        
        if components.hour! % 100 > 10 && components.hour! % 100 < 20 && components.hour! > 0 {
            return "\(String(components.hour!)) часов назад"
        }
        if components.hour! % 10 == 1 && components.hour! > 0 {
            return "\(String(components.hour!)) час назад"
        } else if components.hour! % 10 > 1 && components.hour! % 10 < 5 && components.hour! > 0 {
            return "\(String(components.hour!)) часа назад"
        } else if components.hour! > 0 {
            return "\(String(components.hour!)) часов назад"
        }
        
        
        if components.minute! % 100 > 10 && components.minute! % 100 < 20 && components.minute! > 0 {
            return "\(String(components.minute!)) минут назад"
        }
        if components.minute! % 10 == 1 && components.minute! > 0  {
            return "\(String(components.minute!)) минуту назад"
        } else if components.minute! % 10 > 1 && components.minute! % 10 < 5 && components.minute! > 0  {
            return "\(String(components.minute!)) минуты назад"
        } else if components.minute! > 0 {
            return "\(String(components.minute!)) минут назад"
        }
        
        
        if components.second! % 100 > 10 && components.second! % 100 < 20 && components.second! > 0 {
            return "\(String(components.second!)) секунд назад"
        }
        if components.second! % 10 == 1 && components.second! > 0 {
            return "\(String(components.second!)) секунду что"
        } else if components.second! % 10 > 1 && components.second! % 10 < 5 && components.second! > 0  {
            return "\(String(components.second!)) секунды назад"
        } else {
            return "\(String(components.second!)) секунд назад"
        }
    }
}

// метод для загрузки фото из интенета по URL
extension UIImageView {
    func setImageFromURL(stringImageUrl url: String) {
        if let url = NSURL(string: url) {
            if let data = NSData(contentsOf: url as URL) {
                self.image = UIImage(data: data as Data)
            }
        }
    }
}

func checkNewDataInRealm(jsonForGroups: [GetMyGroups]?, jsonForFriends: [GetMyFriends]?) -> Bool {
    var setTrue = 0
    do {
        if jsonForFriends == nil || jsonForGroups != nil {
            let realm = try Realm()
            let objects = realm.objects(GetMyGroups.self)
            
            let set1 = Set(objects)
            let set2 = Set(jsonForGroups!)
            
            if objects.count == jsonForGroups!.count || Set(set1.map{$0.id}).symmetricDifference(Set(set2.map{$0.id})) == [] {
                setTrue = 1
            } else {
                setTrue = 0
            }
        } else if jsonForFriends != nil || jsonForGroups == nil {
            let realm = try Realm()
            let objects = realm.objects(GetMyFriends.self)
            
            let set1 = Set(objects)
            let set2 = Set(jsonForFriends!)
            
            if objects.count == jsonForFriends!.count || Set(set1.map{$0.id}).symmetricDifference(Set(set2.map{$0.id})) == [] {
                setTrue = 1
            } else {
                setTrue = 0
            }
        }
    } catch {
        print(error)
    }
    if setTrue == 1 { return true } else { return false }
}

extension Realm {
    static func replaceDataInRealm<T: Object>(toNewObjects objects: [T]) {
        do {
            let realm = try Realm()
            print(realm.configuration.fileURL!)

            let oldObjects = realm.objects(T.self)
            
            try realm.write {
                realm.delete(oldObjects)
                realm.add(objects)
            }
        } catch {
            print(error)
        }
    }
    
    static func addDataToRealm<T: Object>(objects: [T]) {
        do {
            let realm = try Realm()
            print(realm.configuration.fileURL!)
            try realm.write {
                realm.add(objects)
            }
        } catch {
            print(error)
        }
    }
    
    static func deleteDataFromRealm<T: Object>(objects: [T]) {
        do {
            let realm = try Realm()
            
            print(realm.configuration.fileURL!)
            
            try realm.write {
                realm.delete(objects)
            }
        } catch {
            print(error)
        }
    }
}
