//
//  LoginWebViewController.swift
//  Pract_VK
//
//  Created by Сергей Бадасян on 25.04.2021.
//

import UIKit
import WebKit
import FirebaseDatabase
import FirebaseAuth

class LoginWebViewController: UIViewController {

    private var vkUsers = [FirebaseVKUser]()
    private let ref = Database.database().reference(withPath: "vkUsers")
    
    @IBOutlet weak var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initLoginForm()
    }
    
    private func saveUserIDtoFirebase(_id: String) {
        
        let user = FirebaseVKUser(id: _id)
        let userRef = self.ref.child(_id)
        
        userRef.setValue(user.toAnyObject())
    }
    
    private func initLoginForm() {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "7837658"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "262150"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.130")
        ]
        
        let request = URLRequest(url: urlComponents.url!)
        
        webView.load(request)
    }
}

extension LoginWebViewController : WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment  else {
            decisionHandler(.allow)
            return
        }
        
        print("LOGIN SUCCESS!")
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
        
        CurrentSession.instance.token = params["access_token"] ?? ""
        CurrentSession.instance.userID = params["user_id"] ?? ""
        
        // Сохраняем ID в Firebase
        saveUserIDtoFirebase(_id: CurrentSession.instance.userID)
        
        print("Session access token: \(CurrentSession.instance.token)")
        print("Session user ID: \(CurrentSession.instance.userID)")
        
        // Тестирование хранилища UserDefaults
        print("LoginName: \(UserDefaults.standard.string(forKey: "loginName") ?? "(no data)")")
        UserDefaults.standard.set("admin", forKey: "loginName")
        
        decisionHandler(.cancel)
        
        VKNetworkManager.instance.getFriends() {
            self.performSegue(withIdentifier: "SegueFromWebLoginToMainBar", sender: self)
        }
    }
}
