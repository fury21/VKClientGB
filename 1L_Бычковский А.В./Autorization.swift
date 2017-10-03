////
////  Autorization.swift
////  1L_Бычковский А.В.
////
////  Created by Александр Б. on 28.09.2017.
////  Copyright © 2017 Александр Б. All rights reserved.
////
//
//import UIKit
//
//class Autorization: UIViewController {
//
//    @IBOutlet weak var webview: WKWebView! {
//        didSet{
//            webview.navigationDelegate = self
//        }
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        var urlComponents = URLComponents()
//        urlComponents.scheme = "https"
//        urlComponents.host = "oauth.vk.com"
//        urlComponents.path = "/authorize"
//        urlComponents.queryItems = [
//            URLQueryItem(name: "client_id", value: "6195650"),
//            URLQueryItem(name: "display", value: "mobile"),
//            URLQueryItem(name: "redirect_uri", value: "https://vk.com/"),
//            URLQueryItem(name: "scope", value: "offline,photos,friends"),
//            URLQueryItem(name: "response_type", value: "token"),
//            URLQueryItem(name: "v", value: "5.68"),
//            //  URLQueryItem(name: "revoke", value: "1")
//        ]
//
//        let request = URLRequest(url: urlComponents.url!)
//
//        webview.load(request)
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//
//}
//
//extension Autorization: WKNavigationDelegate {
//    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
//
//        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment  else {
//            decisionHandler(.allow)
//            return
//        }
//
//        let params = fragment
//            .components(separatedBy: "&")
//            .map { $0.components(separatedBy: "=") }
//            .reduce([String: String]()) { result, param in
//                var dict = result
//                let key = param[0]
//                let value = param[1]
//                dict[key] = value
//                return dict
//        }
//
//        let token = params["access_token"]
//
//        print(token)
//
//
//        decisionHandler(.cancel)
//    }
//}
//
