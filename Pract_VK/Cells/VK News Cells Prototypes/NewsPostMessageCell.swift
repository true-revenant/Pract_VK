//
//  NewsPostMessageCell.swift
//  Pract_VK
//
//  Created by Сергей Бадасян on 14.08.2021.
//

import UIKit

class NewsPostMessageCell: UICollectionViewCell {

    @IBOutlet weak var message: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(_messageText: String) {
        message.text = _messageText
    }
}
