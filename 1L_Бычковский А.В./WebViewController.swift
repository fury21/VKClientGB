//
//  WebViewController.swift
//  1L_Бычковский А.В.
//
//  Created by Александр Б. on 02.10.2017.
//  Copyright © 2017 Александр Б. All rights reserved.
//

import Foundation
import WebKit
import Alamofire

class WebViewController: UIViewController {
    
    
    @IBOutlet weak var webview: WKWebView! {
        didSet {
            webview.navigationDelegate = self
        }
    }
    
    var service = VKService()
    
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
        
        print(params)
        
        let token = params["access_token"]
        
        globalToken = token!
        decisionHandler(.cancel)
        
        performSegue(withIdentifier: "toLoginPage", sender: token)
    }
}

var globalToken: String = ""
