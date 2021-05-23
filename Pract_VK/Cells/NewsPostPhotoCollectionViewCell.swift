//
//  NewsPostPhotoCollectionViewCell.swift
//  Pract_VK
//
//  Created by Сергей Бадасян on 29.03.2021.
//

import UIKit

class NewsPostPhotoCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var counterLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        counterLabel.alpha = 0
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        counterLabel.text = ""
    }
    
}
