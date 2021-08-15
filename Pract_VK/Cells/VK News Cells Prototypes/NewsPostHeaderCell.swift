//
//  NewsPostHeaderCell.swift
//  Pract_VK
//
//  Created by Сергей Бадасян on 14.08.2021.
//

import UIKit

class NewsPostHeaderCell: UICollectionViewCell {

    @IBOutlet weak var nameText: UILabel!
    
    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBOutlet weak var dateText: UILabel!
    
    func configure(_authorNameText: String, _avatarImg: UIImage, _dateText: String) {
        
        nameText.text = _authorNameText
        avatarImage.image = _avatarImg
        dateText.text = _dateText
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
