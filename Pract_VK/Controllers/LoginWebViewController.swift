//
//  LoginWebViewController.swift
//  Pract_VK
//
//  Created by Сергей Бадасян on 25.04.2021.
//

import UIKit
import WebKit

class LoginWebViewController: UIViewController {

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
    
    private func initLoginForm() {
        var urlComponents = URLComponents()
                urlComponents.scheme = "https"
                urlComponents.host = "oauth.vk.com"
                urlComponents.path = "/authorize"
                urlComponents.queryItems = [
                    URLQueryItem(name: "client_id", value: "7837658"),
                    URLQueryItem(name: "display", value: "mobile"),
                    URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
                    URLQueryItem(name: "scope", value: "270342"),
                    URLQueryItem(name: "response_type", value: "token"),
                    URLQueryItem(name: "v", value: "5.130")
                ]
                
                let request = URLRequest(url: urlComponents.url!)
                
                webView.load(request)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
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
        
        print("Session access token: \(CurrentSession.instance.token)")
        print("Session user ID: \(CurrentSession.instance.userID)")
        
        // Тестирование хранилища UserDefaults
        print("LoginName: \(UserDefaults.standard.string(forKey: "loginName") ?? "(no data)")")
        UserDefaults.standard.set("admin", forKey: "loginName")
        
        decisionHandler(.cancel)
        
        VKNetworkManager.instance.getFriends() {
            self.performSegue(withIdentifier: "SegueFromLoginToMainBar", sender: self)
        }
        
    }
}
