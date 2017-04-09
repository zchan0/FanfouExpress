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
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC   = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)   else { return }
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else { return }
        
        let containerView = transitionContext.containerView

        var translationTransform = CGAffineTransform()
        var toViewStartFrame = transitionContext.initialFrame(for: toVC)
        var toViewFinalFrame = transitionContext.finalFrame(for: toVC)
        
        if presenting {
            toViewStartFrame = CGRect(x: 0, y: containerView.bounds.height, width: toViewFinalFrame.width, height: toViewFinalFrame.height)
            toViewFinalFrame.origin.y = TransitionStyle.BackgroundOrigin.y + TransitionStyle.BackgroundVerticalMargin
            translationTransform = CGAffineTransform(translationX: 0, y: toViewFinalFrame.origin.y - toViewStartFrame.origin.y)

            fromVC.view.isHidden = true
            toVC.view.frame = toViewStartFrame
            containerView.addSubview(toVC.view)
        } else {
            translationTransform = CGAffineTransform.identity
        }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            if self.presenting {
                toVC.view.transform = translationTransform
            } else {
                fromVC.view.transform = translationTransform
            }
        }) { _ in
            let success = !transitionContext.transitionWasCancelled
            // failed to present, need to clean up
            if !success && self.presenting {
                fromVC.view.isHidden = false
                toVC.view.removeFromSuperview()
            }
            // successful dismissal
            if success && !self.presenting {
                toVC.view.isHidden = false
            }
            transitionContext.completeTransition(success)
        }
    }
}
