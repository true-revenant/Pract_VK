//
//  PhotoCollectionViewCell.swift
//  Pract_VK
//
//  Created by Сергей Бадасян on 13.03.2021.
//

import UIKit
import Kingfisher

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImage: UIImageView!
    
    @IBOutlet weak var likeButton: LikeButtonControl!
    
    override func prepareForReuse() {
        photoImage.image = nil
    }
    
    func configure(_ p: Photo) {
        photoImage.kf.setImage(with: URL(string: p.photoAddress))
        likeButton.setCounter(p.likes)
        appearAnimationLayer()
    }
    
    private func appearAnimation() {
        self.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        self.alpha = 0
        UIView.animate(withDuration: 0.7, delay: 0, options: [.curveEaseOut], animations: {
            self.transform = .identity
            self.alpha = 1
        }, completion: { success in print("photo appeared!") })
    }
    
    private func appearAnimationLayer()
    {
        let opacityAnim = CABasicAnimation(keyPath: "opacity")
        opacityAnim.fromValue = 0
        opacityAnim.toValue = 1
        
        let transformXAnim = CABasicAnimation(keyPath: "transform.scale.x")
        transformXAnim.fromValue = 0.7
        transformXAnim.toValue = 1

        let transformYAnim = CABasicAnimation(keyPath: "transform.scale.y")
        transformYAnim.fromValue = 0.7
        transformYAnim.toValue = 1
        
        let groupAnim = CAAnimationGroup()
        groupAnim.duration = 0.7
        //groupAnim.timingFunction = CAMediaTimingFunction(name: .easeOut)
        groupAnim.timingFunction = CAMediaTimingFunction(controlPoints: 0.6, 0.91, 0.32, 0.96)
        groupAnim.fillMode = .forwards
        groupAnim.animations = [opacityAnim, transformXAnim, transformYAnim]
        self.contentView.layer.add(groupAnim, forKey: nil)
    }
    
    func dissapearAnimation() {
        
    }
}
