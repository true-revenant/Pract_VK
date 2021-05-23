//
//  GroupTableViewCell.swift
//  Pract_VK
//
//  Created by Сергей Бадасян on 13.03.2021.
//

import UIKit

class GroupTableViewCell: UITableViewCell {

    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var avatarPhoto: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func prepareForReuse() {
        groupName.text = ""
        avatarPhoto.image = nil
    }
    
    func configure(_ g: Group?) {
        
        guard let _g = g else { return }
        
        groupName.text = _g.name
        avatarPhoto.kf.setImage(with: URL(string: _g.photoAddress))
    }
}
