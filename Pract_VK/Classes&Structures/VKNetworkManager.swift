//
//  NetworkManager.swift
//  Pract_VK
//
//  Created by Сергей Бадасян on 26.04.2021.
//

import Foundation
import Alamofire

class VKNetworkManager {
    
    var friends : [Friend]?
    var photos : [Photo]?
    var groups: [Group]?
    var searchGroups : [Group]?
    
    private init() {}
    private let baseURL = "api.vk.com"
    private var urlConstructor = URLComponents()
    private var request : URLRequest!
    
    static let instance = VKNetworkManager()
    
    private enum qType {
        case friends
        case groups
        case photos
        case searchGroups
        case newsfeed
    }
    
    // Объект сессии для работы c URLSession
    private let urlSession: URLSession = {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        return session
    }()
    
    // Объект сессии для работы с Alamofire
    private let AFSession: Session = {
        let config = URLSessionConfiguration.default
        let sessionManager = Session(configuration: config)
        return sessionManager
    }()
    
    func getFriends(completion: @escaping () -> Void) {
        
        urlConstructor.scheme = "https"
        urlConstructor.host = baseURL
        urlConstructor.path = "/method/friends.get"
        
        urlConstructor.queryItems = [
            URLQueryItem(name: "user_id", value: CurrentSession.instance.userID),
            URLQueryItem(name: "access_token", value: CurrentSession.instance.token),
            URLQueryItem(name: "order", value: "random"),
            URLQueryItem(name: "fields", value: "nickname,sex,bdate,city,photo_200_orig"),
            URLQueryItem(name: "v", value: "5.130")
        ]
        
        //runGetRequest()
        runGetRequestAF(q: .friends, completion)
        print(self.urlConstructor.url!)
        
    }
    
    func getAllPhotos(userId: Int, _ completion: @escaping () -> Void) {
        
        urlConstructor.scheme = "https"
        urlConstructor.host = baseURL
        urlConstructor.path = "/method/photos.getAll"
        
        urlConstructor.queryItems = [
            URLQueryItem(name: "owner_id", value: "\(userId)"),
            URLQueryItem(name: "access_token", value: CurrentSession.instance.token),
            URLQueryItem(name: "v", value: "5.130"),
            URLQueryItem(name: "photo_sizes", value: "1"),
            URLQueryItem(name: "extended", value: "1")
            //URLQueryItem(name: "count", value: "200")
        ]
        
//        var request = URLRequest(url: urlConstructor.url!)
//        request.httpMethod = "GET"
        
        //runGetRequest()
        runGetRequestAF(q: .photos, completion)
    }

    func getGroups(_ completion: @escaping () -> Void) {
        
        urlConstructor.scheme = "https"
        urlConstructor.host = baseURL
        urlConstructor.path = "/method/groups.get"
        
        urlConstructor.queryItems = [
            URLQueryItem(name: "user_id", value: CurrentSession.instance.userID),
            URLQueryItem(name: "access_token", value: CurrentSession.instance.token),
            URLQueryItem(name: "fields", value: "description,members_count"),
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "v", value: "5.130")
        ]
        
        //runGetRequest()
        runGetRequestAF(q: .groups, completion)
        print(self.urlConstructor.url!)
    }
    
    func getSearchGroups(_ qFilter: String, _ completion: @escaping () -> Void) {
        
        urlConstructor.scheme = "https"
        urlConstructor.host = baseURL
        urlConstructor.path = "/method/groups.search"
        
        urlConstructor.queryItems = [
            URLQueryItem(name: "q", value: qFilter),
            URLQueryItem(name: "access_token", value: CurrentSession.instance.token),
            URLQueryItem(name: "sort", value: "0"),
            URLQueryItem(name: "v", value: "5.130")
        ]
        
        //runGetRequest()
        runGetRequestAF(q: .searchGroups, completion)
        print(self.urlConstructor.url!)
    }
    
    // NOT WORKING
    func getNewsfeed() {
        
        urlConstructor.scheme = "https"
        urlConstructor.host = baseURL
        urlConstructor.path = "/method/newsfeed.get"
        
        urlConstructor.queryItems = [
            URLQueryItem(name: "access_token", value: CurrentSession.instance.token),
            URLQueryItem(name: "filters", value: "post,photo, note"),
            URLQueryItem(name: "max_photos", value: "100"),
            URLQueryItem(name: "v", value: "5.130")
        ]
        
        runGetRequestAF(q: .newsfeed, nil)
        print(self.urlConstructor.url!)
    }
    
    private func runGetRequest() {
        request = URLRequest(url: urlConstructor.url!)
        request.httpMethod = "GET"
        
        // задача для запуска
        let task = urlSession.dataTask(with: request) { (data, response, error) in
        // в замыкании данные, полученные от сервера, мы преобразуем в json
            
            if let err = error { print(err.localizedDescription) }
            if let d = data {
                let json = try? JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.allowFragments)
                // выводим в консоль
                print(json ?? "(empty)")
            }
        }
        // запускаем задачу
        task.resume()
    }
    
    private func runGetRequestAF(q : qType, _ completion : ( () -> Void)?) {
        AFSession.request(urlConstructor.url! as URLConvertible, method: .get).responseJSON(completionHandler: { response in
            
            guard let data = response.data else { return }
            
            do {
                switch q {
                case .friends:
                    
                    self.friends = try JSONDecoder().decode(FriendsResponse.self, from: data).response.items
                    
                case .photos:
                    
                    self.photos = try JSONDecoder().decode(PhotoResponse.self, from: data).response.items
                    
                case .groups:
                    
                    self.groups = try JSONDecoder().decode(GroupsResponse.self, from: data).response.items
                    
                case .searchGroups:
                    
                    self.searchGroups = try JSONDecoder().decode(GroupsResponse.self, from: data).response.items
                
                case .newsfeed:
                    
                    let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                    print(json)
                    
                }
                (completion ?? {})()
            }
            catch { print(error) }
        })
    }
}
