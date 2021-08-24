//
//  Newsfeed.swift
//  Pract_VK
//
//  Created by Сергей Бадасян on 15.08.2021.
//

import Foundation
import RealmSwift

class NewsfeedResponse : Decodable {
    let response : NewsfeedList
}

class NewsfeedList : Decodable {
    let items : [Newsfeed]
}

class Newsfeed : Object, Decodable {
    
    @objc dynamic var id  = 0
    @objc dynamic var date = 0.0
    @objc dynamic var text = ""
    @objc dynamic var likesCount = 0
    @objc dynamic var userLikes = false
    
    var attachmentPhotos = [NewsfeedAttach]()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    enum MainKeys: String, CodingKey {
        case id = "source_id"
        case date
        case text
        case attachments
    }
    
    enum AttachmentsKeys: CodingKey {
        case type
        case photo
    }
    
    enum PhotoKeys: String, CodingKey {
        case sizes
    }
    
    enum SizesKeys: String, CodingKey {
        case url
    }
    
    //let photos = List<NewsfeedAttach>()
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        
        let root = try decoder.container(keyedBy: MainKeys.self)
        
        id = try root.decode(Int.self, forKey: MainKeys.id)
        
        date = try root.decode(Double.self, forKey: MainKeys.date)
        
        text = try root.decode(String.self, forKey: MainKeys.text)
        
        do {
            
            var attachments = try root.nestedUnkeyedContainer(forKey: MainKeys.attachments)
            
            if let aCount = attachments.count {
                
                for _ in 1...aCount {
                    
                    let attach = try attachments.nestedContainer(keyedBy: AttachmentsKeys.self)
                    
                    let type = try attach.decode(String.self, forKey: AttachmentsKeys.type)

                    if type == "photo" {
                        
                        let photos = try attach.nestedContainer(keyedBy: PhotoKeys.self, forKey: AttachmentsKeys.photo)
                        
                        var sizes = try photos.nestedUnkeyedContainer(forKey: PhotoKeys.sizes)
                        
                        let sizesItem = try sizes.nestedContainer(keyedBy: SizesKeys.self)
                        
                        let photoUrl = try sizesItem.decode(String.self, forKey: SizesKeys.url)
                        
                        attachmentPhotos.append(NewsfeedAttach(photoUrl: photoUrl))
                    }
                }
            }
            
        } catch { print(error.localizedDescription) }
    }
}
