//
//  FriendsTableViewHeader.swift
//  Pract_VK
//
//  Created by Сергей Бадасян on 26.03.2021.
//

import UIKit

class FriendsTableViewHeader: UITableViewHeaderFooterView {

    @IBOutlet weak var letterLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        letterLabel.text = nil
    }
    
    func configure(text: String) {
        letterLabel.text = text
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let backView = UIView()
        backView.alpha = 0.5
        backView.backgroundColor = .systemBackground
        backgroundView = backView
    }
}
