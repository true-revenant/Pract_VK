//
//  Photo.swift
//  Pract_VK
//
//  Created by Сергей Бадасян on 30.04.2021.
//

import Foundation
import RealmSwift

class PhotoResponse : Decodable {
    var response : PhotoList
}

class PhotoList : Decodable {
    var items : [Photo]
}

class Photo : Object, Decodable {
    
    override var description: String {
        return "id: \(id)     likes: \(likes)"
    }
    
    @objc dynamic var date : Double = 0.0
    @objc dynamic var id = 0
    @objc dynamic var photoAddress = ""
    @objc dynamic var likes = 0
    
    enum CodingKeys : String, CodingKey {
        case date
        case id
        case likes
        case sizes
        //case album_id
//        case owner_id
//        case has_tags
//        case post_id
//        case sizes
//        case text
    }
    
    enum SizesKeys : String, CodingKey {
        case url
        case type
    }
    
    enum LikesKeys : String, CodingKey {
        case count
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        
        let root = try decoder.container(keyedBy: CodingKeys.self)
        
        date = try root.decode(Double.self, forKey: .date)
        id = try root.decode(Int.self, forKey: .id)
        
        let likesCont = try root.nestedContainer(keyedBy: LikesKeys.self, forKey: .likes)
        
        likes = try likesCont.decode(Int.self, forKey: .count)
        
        var sizeArr = try root.nestedUnkeyedContainer(forKey: .sizes)
        for _ in 0...sizeArr.count! - 1 {
            let photoItem = try sizeArr.nestedContainer(keyedBy: SizesKeys.self)
            //let t = try photoItem.decode(String.self, forKey: .type)
            if try photoItem.decode(String.self, forKey: .type) == "x" {
                self.photoAddress = try photoItem.decode(String.self, forKey: .url)
            }
        }
    }
}
