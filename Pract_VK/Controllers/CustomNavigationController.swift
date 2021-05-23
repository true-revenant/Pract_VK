//
//  CustomNavigationController.swift
//  Pract_VK
//
//  Created by Сергей Бадасян on 21.04.2021.
//

import UIKit

class CustomNavigationController: UINavigationController, UINavigationControllerDelegate {

    let interactiveTransition = CustomInteractiveTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            self.interactiveTransition.viewController = toVC
            return CustomPushAnimator()
        case .pop:
            if navigationController.viewControllers.first != toVC {
                self.interactiveTransition.viewController = toVC
            }
            return CustomPopAnimator()
        default:
            return nil
        }
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              interactionControllerFor animationController: UIViewControllerAnimatedTransitioning)
                              -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition.hasStarted ? interactiveTransition : nil
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
