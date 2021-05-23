//
//  CustomInteractiveTransition.swift
//  Pract_VK
//
//  Created by Сергей Бадасян on 21.04.2021.
//

import UIKit

class CustomInteractiveTransition : UIPercentDrivenInteractiveTransition {
    
    var hasStarted: Bool = false
    var shouldFinish: Bool = false
    
    var viewController: UIViewController? {
        didSet {
            let recognizer = UIScreenEdgePanGestureRecognizer(target: self,         action: #selector(handleScreenEdgeGesture(_:)))
            recognizer.edges = [.left]
            viewController?.view.addGestureRecognizer(recognizer)
        }
    }
    
    @objc func handleScreenEdgeGesture(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        //print("handleScreenEdgeGesture()")
        switch recognizer.state {
        case .began:
            self.hasStarted = true
            self.viewController?.navigationController?.popViewController(animated: true)
        case .changed:
            let translation = recognizer.translation(in: recognizer.view)
            print("Translation = \(translation))")
            let relativeTranslation = translation.y / (recognizer.view?.bounds.width ?? 1)
            print("relativeTranslation =  = \(relativeTranslation))")
            let progress = max(0, min(1, relativeTranslation))
            print("Progress = \(progress))")
            self.shouldFinish = progress > 0.33

            self.update(progress)
        case .ended:
            self.hasStarted = false
            self.shouldFinish ? self.finish() : self.cancel()
        case .cancelled:
            self.hasStarted = false
            self.cancel()
        default: return
        }
    }
}
