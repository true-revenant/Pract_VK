//
//  LoginGradientView.swift
//  Pract_VK
//
//  Created by Сергей Бадасян on 17.03.2021.
//

import UIKit

class LoginGradientView: UIView {
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    var gradientLayer: CAGradientLayer {
        return layer as! CAGradientLayer
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //gradientInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //gradientInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientInit()
    }
    
//    @IBInspectable var color1: UIColor = .blue {
//        didSet {
//            gradientLayer.colors?[0] = color1.cgColor
//        }
//    }
//
//    @IBInspectable var color2: UIColor = .blue {
//        didSet {
//            gradientLayer.colors?[0] = color2.cgColor
//        }
//    }
//
//    var point1: (Int, Int) = (0, 0) {
//        didSet {
//            gradientLayer.startPoint = CGPoint(x: point1.0, y: point1.1)
//        }
//    }
//
//    var point2: (Int, Int) = (0, 0) {
//        didSet {
//            gradientLayer.startPoint = CGPoint(x: point2.0, y: point2.1)
//        }
//    }

    func gradientInit() {
        gradientLayer.colors = [UIColor.blue.cgColor, UIColor.white.cgColor]
        gradientLayer.locations = [0 as NSNumber , 1 as NSNumber]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
    }
    
    
}
