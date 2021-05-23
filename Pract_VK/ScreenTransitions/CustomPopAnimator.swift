//
//  CustomPopAnimator.swift
//  Pract_VK
//
//  Created by Сергей Бадасян on 19.04.2021.
//

import UIKit

class CustomPopAnimator : NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let source = transitionContext.viewController(forKey: .from) else { return }
        guard let dest = transitionContext.viewController(forKey: .to) else { return }
        
        dest.view.frame = transitionContext.containerView.frame
        transitionContext.containerView.addSubview(dest.view)
        transitionContext.containerView.sendSubviewToBack(dest.view)
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            let rotation = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)

            source.view.transform = rotation
        }, completion: { finished in
            if finished && !transitionContext.transitionWasCancelled {
                source.view.transform = .identity
                source.view.removeFromSuperview()
            }
            transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        })
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        print("Pop animation ended!")
    }
}
