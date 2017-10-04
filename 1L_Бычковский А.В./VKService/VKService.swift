//
//  VKService.swift
//  1L_Бычковский А.В.
//
//  Created by Александр Б. on 23.09.17.
//  Copyright © 2017 Александр Б. All rights reserved.

// https://oauth.vk.com/authorize?client_id=6195650&display=page&redirect_uri=&scope=friends,offline,photos&response_type=token&v=5.68&state=123456



import Foundation
import Alamofire
import SwiftyJSON
import SwiftKeychainWrapper

class VKService {
    // параметры API ВКонтакте	
    let baseUrl = "https://api.vk.com"
    let myVkId = 124505735 // id моей страницы
    let appId = 6195650 // id приложения в ВК
    let vkToken: String? = KeychainWrapper.standard.string(forKey: "vkApiToken")
    
    
    // список друзей по id
    func loadVKAnyFriends(vKId: Int, completion: @escaping ([GetMyFriends]) -> Void) {
        let path = "/method/friends.get"
        
        let parameters: Parameters = [
            "user_id": vKId,
            "fields": "photo_50,online",
            "access_token": vkToken!,
            "v": "5.68"
        ]

        let url = baseUrl + path
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            guard let data = response.value else { return }
            
            let json = JSON(data)
            
            let friends = json["response"]["items"].flatMap { GetMyFriends(json: $0.1) }
            
            completion(friends)
        }
    }
    
    
    // список групп по id
    func loadVKAnyGroups(vKId: Int, completion: @escaping ([GetMyGroups]) -> Void) {
        let path = "/method/groups.get"
        
        let parameters: Parameters = [
            "user_id": vKId,
            "extended": 1,
            "access_token": vkToken!,
            "v": "5.68"
        ]
        
        let url = baseUrl + path
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            guard let data = response.value else { return }
            
            let json = JSON(data)
            
            let groups = json["response"]["items"].flatMap { GetMyGroups(json: $0.1) }
            
            completion(groups)
        }
    }
    
    
    // список фото по id
    func loadVKAnyPhotos(vKId: Int) {
        let path = "/method/photos.getAll"
        
        let parameters: Parameters = [
            "user_id": vKId,
            "count": 200,
            "access_token": vkToken!,
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
            "access_token": vkToken!,
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
    
    enum joinAndLeaveGroup {
        case joinGroup
        case leaveGroup
    }
    
    func joinAndLeaveAnyGroup(groupId: Int, action: joinAndLeaveGroup) {
        var path = ""
        
        if action == .joinGroup {
            path = "/method/groups.join"
        } else {
             path = "/method/groups.leave"
        }
        
        
        let parameters: Parameters = [
            "group_id": groupId,
            "access_token": vkToken!,
            "v": "5.68"
        ]
        
        let url = baseUrl + path
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            print("+++", response.value!)
        }
    }
    
    
    func getrequest() -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "6196632"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "262150"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.68")
        ]
        
        let request = URLRequest(url: urlComponents.url!)
        
        return request
    }
}
    
    extension UIImageView {
        func setImageFromURL(stringImageUrl url: String) {
            if let url = NSURL(string: url) {
                if let data = NSData(contentsOf: url as URL) {
                    self.image = UIImage(data: data as Data)
                }
            }
        }
}
