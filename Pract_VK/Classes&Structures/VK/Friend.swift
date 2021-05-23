//
//  Friend.swift
//  Pract_VK
//
//  Created by Сергей Бадасян on 29.04.2021.
//

import Foundation
import RealmSwift

class FriendsResponse : Decodable {
    let response : FriendsList
}

class FriendsList : Decodable {
    let items : [Friend]
}

class Friend : Object, Decodable {
    
    override var description: String {
        return "\(id)   \(firstName)    \(lastName)     \(sex ?? Sex.Unknown)"
    }
    
    @objc dynamic var id  = 0
    @objc dynamic var firstName  = ""
    @objc dynamic var lastName = ""
    @objc dynamic var sexStr = ""
    var sex : Sex? = Sex.Unknown
    @objc dynamic var nickName : String? = ""
    @objc dynamic var photoAddress = ""
    @objc dynamic var city : String? = ""
    
    let photos = List<Photo>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case sex
        case city
        case firstName = "first_name"
        case lastName = "last_name"
        case nickName = "nickname"
        case photoAddress = "photo_200_orig"
    }
    
    enum CityKeys: String, CodingKey {
        case id
        case title
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        
        // Определяем корневой контейнер
        let items = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try items.decode(Int.self, forKey: .id)
        firstName = try items.decode(String.self, forKey: .firstName)
        lastName = try items.decode(String.self, forKey: .lastName)
        nickName = try? items.decode(String.self, forKey: .nickName)
        photoAddress = try items.decode(String.self, forKey: .photoAddress)
        
        let cityCont = try? items.nestedContainer(keyedBy: CityKeys.self, forKey: .city)
        city = try? cityCont?.decode(String.self, forKey: .title)
        
        sex = try items.decode(Sex.self, forKey: .sex)
        
        switch sex {
            case .Female:
                sexStr = "Female"
            case .Male:
                sexStr = "Male"
            default:
                sexStr = ""
        }
    }
}

/////

enum Sex : Int, Decodable {
    
    case Male = 2
    case Female = 1
    case Unknown = 0
}
