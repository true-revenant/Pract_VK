//
//  NewsfeedPhoto.swift
//  Pract_VK
//
//  Created by Сергей Бадасян on 24.08.2021.
//

import Foundation

class NewsfeedAttach {
    
    @objc dynamic var photoUrl = ""
    
    init(photoUrl : String) {
        self.photoUrl = photoUrl
    }
    
//    enum CodingKeys: CodingKey {
//        case type
//        case photo
//    }
//
//    enum PhotoKeys: String, CodingKey {
//        case sizes
//    }
//
//    enum SizesKeys: String, CodingKey {
//        case photoAdress = "url"
//    }
//
//    convenience required init(from decoder: Decoder) throws {
//        self.init()
//
//        let root = try decoder.container(keyedBy: CodingKeys.self)
//
//        let type = try root.decode(String.self, forKey: CodingKeys.type)
//
//        if type == "photo" {
//            let photos = try root.nestedContainer(keyedBy: PhotoKeys.self, forKey: CodingKeys.photo)
//
//            var sizes = try photos.nestedUnkeyedContainer(forKey: PhotoKeys.sizes)
//
//            let photoItem = try sizes.nestedContainer(keyedBy: SizesKeys.self)
//
//            photoAdress = try photoItem.decode(String.self, forKey: SizesKeys.photoAdress)
//        }
//    }
    
}
