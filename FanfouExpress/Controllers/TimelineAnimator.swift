//
//  DetailAnimator.swift
//  FanfouExpress
//
//  Created by Cencen Zheng on 4/5/17.
//  Copyright © 2017 Cencen Zheng. All rights reserved.
//

import UIKit

class TimelineAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var presenting: Bool = true

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC   = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)   else { return }
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else { return }
        
        // Set up some variables for the animation
        let containerView = transitionContext.containerView
        
        let containerFrame = containerView.frame
        var toViewStartFrame = transitionContext.initialFrame(for: toVC)
        var toViewFinalFrame = transitionContext.finalFrame(for: toVC)
        var fromViewFinalFrame = transitionContext.finalFrame(for: fromVC)
        
        // Set up the animation parameters
        if presenting {
            let toViewFinalY = UIDevice.statusBarHeight + TransitionStyle.BackgroundVerticalMargin
            let fromViewFinalX = TransitionStyle.BackgroundOriginX
            
            toViewFinalFrame.origin.y = toViewFinalY
            toViewStartFrame   = CGRect(x: 0, y: containerFrame.height,
                                        width: toViewFinalFrame.width, height: toViewFinalFrame.height)
            fromViewFinalFrame = CGRect(x: fromViewFinalX, y: UIDevice.statusBarHeight,
                                        width: containerFrame.width - fromViewFinalX * 2, height: containerFrame.height - UIDevice.statusBarHeight)
            
            fromVC.view.isHidden = true
            toVC.view.frame = toViewStartFrame
            containerView.addSubview(toVC.view)
        } else {
            fromViewFinalFrame.origin.y = containerView.bounds.height
        }
        
        // Animate
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            toVC.view.frame = toViewFinalFrame
            
            // for dismiss
            if self.presenting == false {
                fromVC.view.frame = fromViewFinalFrame
            }
        }) { _ in
            let success = !transitionContext.transitionWasCancelled
            if success == false {
                toVC.view.removeFromSuperview()
            }
            
            // for present
            if self.presenting {
                fromVC.view.isHidden = false
                fromVC.view.frame = fromViewFinalFrame
            }

            transitionContext.completeTransition(success)
        }
    }
}

