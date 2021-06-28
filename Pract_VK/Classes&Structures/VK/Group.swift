//
//  Group.swift
//  Pract_VK
//
//  Created by Сергей Бадасян on 13.03.2021.
//

import UIKit

class GroupsResponse : Decodable {
    var response : GroupsList
}

class GroupsList : Decodable {
    var items : [Group]
}

class Group : Decodable {
    
    var description: String {
        return "\(id)     \(name)     \(groupDescr)"
    }
    
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var isClosed = false
    var type : GroupType?
    @objc dynamic var typeStr = ""
    @objc dynamic var groupDescr = ""
    @objc dynamic var membersСount = 0
    @objc dynamic var photoAddress = ""
    
//    override static func primaryKey() -> String? {
//        return "id"
//    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case type
        case groupDescr = "description"
        case isClosed = "is_closed"
        case membersСount = "members_count"
        case photoAddress = "photo_100"
    }
    
    func toFiresrore(userId: String) -> [String: Any] {
        return [
            "VKUserID" : userId,
            "Title" : name,
            "Description" : groupDescr,
            "IsClosed" : isClosed,
            "MembersCount" : membersСount
        ]
    }
    
    private func saveToFirestore() {
        
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        
        //print("convenience required init() CALLED")
        
        let root = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try root.decode(Int.self, forKey: .id)
        self.isClosed = try root.decode(Int.self, forKey: .isClosed) == 1 ? true : false
        self.name = try root.decode(String.self, forKey: .name)
        self.type = try root.decode(GroupType.self, forKey: .type)
        
        switch type {
            case .event:
                typeStr = "event"
            case .group:
                typeStr = "group"
            case .page:
                typeStr = "page"
             case .none:
                typeStr = ""
        }
        
        self.photoAddress = try root.decode(String.self, forKey: .photoAddress)
        
        //self.membersСount = try root.decode(Int.self, forKey: .membersСount)
        //self.groupDescr = try root.decode(String.self, forKey: .groupDescr)
    }
}

enum GroupType : String, Decodable {
    case group
    case page
    case event
}
