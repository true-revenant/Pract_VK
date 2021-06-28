//
//  FriendTableViewCell.swift
//  Pract_VK
//
//  Created by Сергей Бадасян on 13.03.2021.
//

import UIKit
import Kingfisher

class FriendTableViewCell: UITableViewCell {

    @IBOutlet weak var AvatarPhoto: RoundedView!
    @IBOutlet weak var friendName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        friendName.text = ""
        AvatarPhoto.image = nil
        AvatarPhoto.kf.cancelDownloadTask()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(_ f : Friend) {
        
        self.friendName.text = "\(f.firstName) \(f.lastName)"
        //self.AvatarPhoto.image = UIImage(named: "friend_1")
        
//        self.AvatarPhoto.kf.setImage(with: URL(string: f.photoAddress), placeholder: nil, options: [.cacheOriginalImage], completionHandler: nil)
        self.AvatarPhoto.kf.setImage(with: URL(string: f.photoAddress))
    }
}
