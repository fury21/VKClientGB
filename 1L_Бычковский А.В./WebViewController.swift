//
//  WebViewController.swift
//  1L_Бычковский А.В.
//
//  Created by Александр Б. on 02.10.2017.
//  Copyright © 2017 Александр Б. All rights reserved.
//

import Foundation
import WebKit
import SwiftKeychainWrapper

let userDefaults = UserDefaults.standard




class WebViewController: UIViewController {
    
    var service = VKService()
    
    @IBOutlet weak var webview: WKWebView! {
        didSet {
            webview.navigationDelegate = self
        }
    }
    
    func logoutVK() {
        let dataStore = WKWebsiteDataStore.default()
        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { (records) in
            for record in records {
                if record.displayName == "vk.com" {
                    dataStore.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), for: [record], completionHandler: {
                        //print("Deleted: " + record.displayName);
                    })
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webview.load(service.getrequest())
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
     
        
        guard let url = navigationResponse.response.url,
            url.path == "/blank.html",
            let fragment = url.fragment  else {
                decisionHandler(.allow)
                return
        }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        
        
        KeychainWrapper.standard.set(params["access_token"]!, forKey: "vkApiToken")
        userDefaults.set(params["user_id"]!, forKey: "vkApiUser_id")
        print(params["access_token"]!)
        decisionHandler(.cancel)
        
        performSegue(withIdentifier: "toLoginPage", sender: nil)
    }
}
