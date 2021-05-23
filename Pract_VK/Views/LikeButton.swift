//
//  LikeButton.swift
//  Pract_VK
//
//  Created by Сергей Бадасян on 17.03.2021.
//

import UIKit

class LikeButtonControl : UIControl {
    
    private var counter : Int = 0 {
        didSet {
            self.countLabel.text = "\(counter)"
        }
    }
    
    private var stackView: UIStackView!
    private var imageView: UIImageView!
    private var countLabel: UILabel!
    private var liked : Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }
    
    func setCounter(_ c: Int) {
        self.counter = c
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
    }
    
    private func initView()
    {
        backgroundColor = .clear
        
        imageView = UIImageView(image: UIImage(named: "like"))
        imageView.tintColor = .none
        
        countLabel = UILabel()
        countLabel.text = "\(counter)"
        countLabel.textColor = .blue
        
        stackView = UIStackView(arrangedSubviews: [imageView, countLabel])
        self.addSubview(stackView)
        
        stackView.spacing = 2
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
    }
        
    private func changeLikeState() {
        if liked {
            counter -= 1
            imageView.tintColor = .none
            countLabel.textColor = .blue
        }
        else {
            counter += 1
            imageView.tintColor = .red
            countLabel.textColor = .red
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.transition(with: self, duration: 0.3, options: [.transitionFlipFromTop], animations: {
            self.changeLikeState()
            self.liked = !self.liked
        }, completion: { success in print("Like transition!") })
    }
}
