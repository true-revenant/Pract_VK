//
//  NewsPost.swift
//  Pract_VK
//
//  Created by Сергей Бадасян on 29.03.2021.
//

import UIKit

struct NewsPost {
    var avatarImage : UIImage
    var lastName : String
    var firstName : String
    var date : String
    var postText: String
    var postImage: UIImage = UIImage.init()
    var photos: [UIImage] = []
}
