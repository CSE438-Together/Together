//
//  TabViewController.swift
//  Together
//
//  Created by 李都 on 2021/11/15.
//

import UIKit

class TabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeGesture))
        swipeLeft.numberOfTouchesRequired = 1
        swipeLeft.direction = .left
        self.view?.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeGesture))
        swipeRight.numberOfTouchesRequired = 1
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
    }
    
    @objc private func swipeGesture(swipe : UISwipeGestureRecognizer){
        switch swipe.direction {
        case .left:
            if selectedIndex > 0 {
                self.selectedIndex = self.selectedIndex - 1
            }
            break
        case .right:
            if selectedIndex < 3 {
                self.selectedIndex = self.selectedIndex + 1
            }
            break
        default:
            break
        }
    }
    
}

extension TabViewController : UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TabViewAnimation();
    }
}

class TabViewAnimation : NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let destination = transitionContext.view(forKey: .to) else {return}
        
        destination.transform = CGAffineTransform(translationX: 0, y: destination.frame.height)
        transitionContext.containerView.addSubview(destination)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {destination.transform = .identity}, completion: {transitionContext.completeTransition(($0))})
    }
    
   
}
