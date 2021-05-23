//
//  CustomAnimatedTransition.swift
//  Pract_VK
//
//  Created by Сергей Бадасян on 19.04.2021.
//

import UIKit

class CustomPushAnimator : NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let source = transitionContext.viewController(forKey: .from) else { return }
        guard let dest = transitionContext.viewController(forKey: .to) else { return }
        
        // Начальное положение конечного вью - поворот на 90 градусов и cправа за пределами экрана

        dest.view.layer.anchorPoint = CGPoint(x: 1, y: 0)
        dest.view.frame = transitionContext.containerView.frame
        let rotation = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        dest.view.transform = rotation
        transitionContext.containerView.addSubview(dest.view)
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0, options: [.curveEaseOut], animations: {
            dest.view.transform = .identity
        }, completion: {finished in
            if finished && !transitionContext.transitionWasCancelled {
                source.view.transform = .identity
                source.view.removeFromSuperview()
            }
            transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        })
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        print("Push animation ended!")
    }
}
