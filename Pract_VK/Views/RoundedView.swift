//
//  AvatarView.swift
//  Pract_VK
//
//  Created by Сергей Бадасян on 16.03.2021.
//

import UIKit

class RoundedView: UIImageView {
    
    var cornerRadius: CGFloat = 0 {
        didSet {
            layer.masksToBounds = cornerRadius > 0
            layer.cornerRadius = cornerRadius
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //setShadow()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //setShadow()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cornerRadius = bounds.width / 2
        //setShadow()
    }
    
//    func setShadow() {
//        layer.shadowColor = UIColor.black.cgColor
//        layer.shadowOpacity = 0.8
//        layer.shadowRadius = 8
//        layer.shadowOffset = CGSize(width: 2, height: 2)
//    }
}
