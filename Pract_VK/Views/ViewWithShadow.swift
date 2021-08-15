//
//  ViewWithShadoe.swift
//  Pract_VK
//
//  Created by Сергей Бадасян on 19.03.2021.
//

import UIKit

@IBDesignable class ViewWithShadow : UIView {

    @IBInspectable var shadowColor : UIColor = .black {
        didSet {
            layer.shadowColor = shadowColor.cgColor
        }
    }

    @IBInspectable var shadowOpacity : Float = 0.5 {
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }

    @IBInspectable var shadowRadius : CGFloat = 8 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }

    @IBInspectable var shadowOffset : CGSize = .zero {
        didSet {
            layer.shadowOffset = shadowOffset
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //print("Нажали на аватарку!")
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: { success in print("Нажали на аватарку!")})
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //print("Отпустили аватарку!")
        //self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
            self.transform = .identity
        }, completion: { success in print("Отпустили аватарку!") })
    }
}
