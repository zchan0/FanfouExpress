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
        let containerView = transitionContext.containerView

        guard let toVC   = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)   else { return }
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else { return }
        guard let snapshot = presenting ? fromVC.view.snapshotView(afterScreenUpdates: true) : containerView.subviews.first else { return }
        
        let containerFrame = containerView.frame
        let fromViewStartFrame = transitionContext.initialFrame(for: fromVC)
        var fromViewFinalFrame = transitionContext.finalFrame(for: fromVC)
        var toViewStartFrame   = transitionContext.initialFrame(for: toVC)
        var toViewFinalFrame   = transitionContext.finalFrame(for: toVC)
        
        var scaleTransform = CGAffineTransform()
        var translationTransform = CGAffineTransform()
        
        if presenting {
            fromViewFinalFrame = CGRect(x: TransitionStyle.BackgroundOriginX,
                                        y: UIDevice.statusBarHeight,
                                        width: fromViewStartFrame.width - TransitionStyle.BackgroundOriginX * 2,
                                        height: fromViewStartFrame.height - UIDevice.statusBarHeight * 2)
            
            let xScaleFactor = fromViewFinalFrame.width / fromViewStartFrame.width
            let yScaleFactor = fromViewFinalFrame.height / fromViewStartFrame.height
            scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
            
            toViewStartFrame = CGRect(x: 0, y: containerFrame.height, width: toViewFinalFrame.width, height: toViewFinalFrame.height)
            toViewFinalFrame.origin.y = UIDevice.statusBarHeight + TransitionStyle.BackgroundVerticalMargin
            translationTransform = CGAffineTransform(translationX: 0, y: toViewFinalFrame.origin.y - toViewStartFrame.origin.y)
            

            fromVC.view.isHidden = true
            snapshot.frame  = fromViewStartFrame
            toVC.view.frame = toViewStartFrame
            containerView.addSubview(toVC.view)
            containerView.insertSubview(snapshot, at: 0)    // Insert snapshot below everything else.
            
            // tweak contentInset
            // swiftlint:disable:next force_cast
            if toVC is UINavigationController, let detail = (toVC as! UINavigationController).visibleViewController as? DetailsViewController {
                var inset = UIEdgeInsets.zero
                inset.bottom = TransitionStyle.BackgroundVerticalMargin + CellStyle.ContentInsets.bottom
                detail.tableView.contentInset = inset
            }
            
        } else {
            translationTransform = CGAffineTransform.identity
            scaleTransform = CGAffineTransform.identity
        }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            snapshot.transform = scaleTransform
            if self.presenting {
                toVC.view.transform = translationTransform
            } else {
                fromVC.view.transform = translationTransform
            }
        }) { _ in
            let success = !transitionContext.transitionWasCancelled
            if self.presenting {
                // failed to present, need clean up
                if success == false {
                    fromVC.view.isHidden = false
                    snapshot.removeFromSuperview()
                    toVC.view.removeFromSuperview()
                }
            }
            // succeed to dismiss, show Timeline view controller
            else if success {
                toVC.view.isHidden = false
            }
            
            transitionContext.completeTransition(success)
        }
    }
}
