//
//  NewsPostCollectionViewCell.swift
//  Pract_VK
//
//  Created by Сергей Бадасян on 27.03.2021.
//

import UIKit

class NewsPostCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var avatarImage: RoundedView!
    
    func configure(name: String, date: String, postText: String, postImg: UIImage, avatarImg: UIImage) {
        nameLabel.text = name
        dateLabel.text = date
        postTextLabel.text = postText
        postImage.image = postImg
        avatarImage.image = avatarImg
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        dateLabel.text = nil
        postTextLabel.text = nil
        postImage.image = nil
        avatarImage.image = nil
    }

}
