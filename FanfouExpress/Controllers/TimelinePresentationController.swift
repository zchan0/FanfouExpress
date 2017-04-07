//
//  DetailPresentationController.swift
//  FanfouExpress
//
//  Created by Cencen Zheng on 4/6/17.
//  Copyright © 2017 Cencen Zheng. All rights reserved.
//

import UIKit

/// background view
private let horizontalMargin: CGFloat = 25
/// between detail view and background view
private let verticalMargin: CGFloat = 8

class TimelinePresentationController: UIPresentationController {
    
    private let dimmingView: UIView
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        self.dimmingView = UIView()
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        self.dimmingView.alpha = 0.0
        self.dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.4)
    }
    
    override func presentationTransitionWillBegin() {
        
        // Set corner radius
        presentingViewController.view.layer.cornerRadius  = 5
        presentingViewController.view.layer.masksToBounds = true
        presentedViewController.view.layer.cornerRadius   = 8
        presentedViewController.view.layer.masksToBounds  = true
        
        guard let containerView = containerView else { return }
        dimmingView.alpha = 0.0
        dimmingView.frame = containerView.bounds
        
        guard let snapshot = presentingViewController.view.snapshotView(afterScreenUpdates: true) else { return }
        snapshot.frame = containerView.bounds
        
        // Add views to the view hierarchy and 
        // set up animations related to those views
        containerView.addSubview(snapshot)
        containerView.addSubview(dimmingView)
        
        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { _ in
                self.dimmingView.alpha = 1.0
                snapshot.frame = CGRect(x: horizontalMargin, y: 20,
                                        width: containerView.bounds.width - horizontalMargin * 2, height: containerView.bounds.height - 20)
            }, completion: { _ in
                snapshot.removeFromSuperview()
            })
        } else {
            dimmingView.alpha = 1.0
            snapshot.removeFromSuperview()
        }
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        if completed == false {
            dimmingView.removeFromSuperview()
        }
    }
    
    override func dismissalTransitionWillBegin() {
        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { _ in
                self.dimmingView.alpha = 0.0
            }, completion: { [weak self] _ in
                guard let `self` = self else { return }
                // Reset corner radius
                self.presentingViewController.view.layer.cornerRadius = 0
                self.presentingViewController.view.layer.masksToBounds = false
                
                // Call presenting view controller to change status bar style
                self.presentingViewController.setNeedsStatusBarAppearanceUpdate()
            })
        } else {
            dimmingView.alpha = 0.0
        }
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            dimmingView.removeFromSuperview()
        }
    }
}
