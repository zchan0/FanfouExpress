//
//  DetailAnimator.swift
//  FanfouExpress
//
//  Created by Cencen Zheng on 4/5/17.
//  Copyright © 2017 Cencen Zheng. All rights reserved.
//

import UIKit

/// background view
private let horizontalMargin: CGFloat = 25
/// between detail view and background view
private let verticalMargin: CGFloat = 8

class TimelineAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var presenting: Bool = true
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC   = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)   else { return }
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else { return }
        
        // Set up some variables for the animation
        let containerView = transitionContext.containerView
        
        var toViewStartFrame = transitionContext.initialFrame(for: toVC)
        var toViewFinalFrame = transitionContext.finalFrame(for: toVC)
        var fromViewFinalFrame = transitionContext.finalFrame(for: fromVC)
        
        // Set up the animation parameters
        if presenting {
            toViewFinalFrame.origin.y = 20 + verticalMargin
            toViewStartFrame   = CGRect(x: 0, y: containerView.bounds.height,
                                        width: toViewFinalFrame.width, height: toViewFinalFrame.height)
            fromViewFinalFrame = CGRect(x: horizontalMargin, y: 20,
                                        width: toViewFinalFrame.width - horizontalMargin * 2, height: toViewFinalFrame.height - 20)
            
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
            fromVC.view.isHidden = false
            fromVC.view.frame = fromViewFinalFrame
            transitionContext.completeTransition(success)
        }
    }
}

