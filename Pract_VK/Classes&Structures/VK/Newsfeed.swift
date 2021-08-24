//
//  Newsfeed.swift
//  Pract_VK
//
//  Created by Сергей Бадасян on 15.08.2021.
//

import Foundation
import RealmSwift

class NewsfeedResponse : Decodable {
    let response : FriendsList
}

class NewsfeedList : Decodable {
    let items : [Newsfeed]
}

class Newsfeed : Object, Decodable {
    
    @objc dynamic var id  = 0
    @objc dynamic var date = ""
    @objc dynamic var text = ""
    
    
    let photos = List<Photo>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
