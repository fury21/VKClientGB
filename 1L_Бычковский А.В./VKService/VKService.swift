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
    let appId = 6195650 // id приложения в ВК
    
    
    // список друзей по id
    func loadVKAnyFriends(vKId: Int, completion: @escaping () -> Void) {
        let path = "/method/friends.get"
        
        let parameters: Parameters = [
            "user_id": vKId,
            "fields": "photo_50,online",
            "access_token": KeychainWrapper.standard.string(forKey: "vkApiToken")!,
            "v": "5.68"
        ]
        
        let url = baseUrl + path
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { [weak self] response in
            guard let data = response.value else { return }
            
            let json = JSON(data)
            
            let friends = json["response"]["items"].flatMap { GetMyFriends(json: $0.1) }
            
            self?.saveMyFriendsToRealm(friends)
            
            completion()
        }
    }
    
    
    // список групп по id
    func loadVKAnyGroups(vKId: Int, completion: @escaping () -> Void) {
        let path = "/method/groups.get"
        
        let parameters: Parameters = [
            "user_id": vKId,
            "extended": 1,
            "access_token": KeychainWrapper.standard.string(forKey: "vkApiToken")!,
            "v": "5.68"
        ]
        
        let url = baseUrl + path
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { [weak self] response in
            guard let data = response.value else { return }
            
            let json = JSON(data)
            
            let groups = json["response"]["items"].flatMap { GetMyGroups(json: $0.1) }
            
            self?.saveMyGroupsToRealm(groups)
            
            completion()
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
    func searchVKAnyGroups(q: String, completion: @escaping ([SearchGroups]) -> Void) {
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
            
            let q = json["response"]["items"].flatMap { SearchGroups(json: $0.1) }
            
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
    
    
    func saveMyFriendsToRealm(_ newFriends: [GetMyFriends]) {
        do {
            let realm = try Realm()
            print(realm.configuration.fileURL)
            let oldFriends = realm.objects(GetMyFriends.self)
            
            try realm.write {
                realm.delete(oldFriends)
                realm.add(newFriends)
            }
        } catch {
            print(error)
        }
    }
    
    func saveMyGroupsToRealm(_ newGroups: [GetMyGroups]) {
        do {
            let realm = try Realm()
            
            let oldGroups = realm.objects(GetMyGroups.self)
            
            try realm.write {
                realm.delete(oldGroups)
                realm.add(newGroups)
            }
        } catch {
            print(error)
        }
    }
    
    
    // подготовка URL для WebViewController
    func getrequest() -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "6196632"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "offline,friends,photos,groups"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.68")
        ]
        
        let request = URLRequest(url: urlComponents.url!)
    //    print(request)
        return request
    }
    
}

extension UIImageView {
    // метод для загрузки фото из интенета по URL
    func setImageFromURL(stringImageUrl url: String) {
        if let url = NSURL(string: url) {
            if let data = NSData(contentsOf: url as URL) {
                self.image = UIImage(data: data as Data)
            }
        }
    }
}
