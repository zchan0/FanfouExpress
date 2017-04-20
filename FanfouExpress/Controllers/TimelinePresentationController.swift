//
//  DetailPresentationController.swift
//  FanfouExpress
//
//  Created by Cencen Zheng on 4/6/17.
//  Copyright © 2017 Cencen Zheng. All rights reserved.
//

import UIKit

class TimelinePresentationController: UIPresentationController {
    
    private let dimmingView: UIView
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        self.dimmingView = UIView()
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        self.dimmingView.alpha = 0.0
        self.dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.4)
    }
    
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }
        
        // Set corner radius
        presentingViewController.view.layer.cornerRadius  = 8
        presentingViewController.view.layer.masksToBounds = true
        presentedViewController.view.layer.cornerRadius   = 8
        presentedViewController.view.layer.masksToBounds  = true
        
        // Set up dimmingView
        dimmingView.alpha = 0.0
        dimmingView.frame = containerView.bounds
        
        guard let snapshot = presentingViewController.view.snapshotView(afterScreenUpdates: true) else { return }
        let presentingStartFrame = snapshot.frame
        let presentingFinalFrame = CGRect(origin: TransitionStyle.BackgroundOrigin,
                                          size: CGSize(width: presentingStartFrame.width - TransitionStyle.BackgroundOrigin.x * 2,
                                                       height: presentingStartFrame.height - TransitionStyle.BackgroundOrigin.y * 2))
        let xScaleFactor = presentingFinalFrame.width / presentingStartFrame.width
        let yScaleFactor = presentingFinalFrame.height / presentingStartFrame.height
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        
        // Add views to the view hierarchy and
        // set up animations related to those views
        containerView.addSubview(dimmingView)
        // Insert snapshot below everything else.
        containerView.insertSubview(snapshot, at: 0)
        
        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { _ in
                snapshot.transform = scaleTransform
                self.dimmingView.alpha = 1.0
            }, completion: nil)
        } else {
            dimmingView.alpha = 1.0
            snapshot.removeFromSuperview()
        }
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        if completed == false {
            dimmingView.removeFromSuperview()
        } else {
            // Tweak contentInset
            guard let navigation = presentedViewController as? UINavigationController else { return }
            guard let detail = navigation.visibleViewController as? DetailsViewController else { return }
            detail.tableView.contentInset.bottom = TransitionStyle.BackgroundVerticalMargin + CellStyle.ContentInsets.bottom
        }
    }
    
    override func dismissalTransitionWillBegin() {
        guard let containerView = containerView else { return }
        guard let snapshot = containerView.subviews.first else { return }
        
        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { _ in
                snapshot.transform = CGAffineTransform.identity
                self.dimmingView.alpha = 0.0
            }, completion: { [weak self] _ in
                guard let `self` = self else { return }
                snapshot.removeFromSuperview()
                
                // Reset corner radius
                self.presentingViewController.view.layer.cornerRadius  = 0
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
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        
        guard let containerView = containerView else { return }
        dimmingView.frame = containerView.bounds
    }
    
}
