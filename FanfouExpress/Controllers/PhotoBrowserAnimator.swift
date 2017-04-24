//
//  PhotoBrowserAnimator.swift
//  FanfouExpress
//
//  Created by Cencen Zheng on 4/22/17.
//  Copyright © 2017 Cencen Zheng. All rights reserved.
//

import UIKit

protocol PhotoBrowserTransitionSupport {
    
    var transitionImage: UIImage { get set }
    var transitionImageView: UIImageView { get set }
}

class PhotoBrowserAnimator: UIPercentDrivenInteractiveTransition {
        
    fileprivate var contextData: UIViewControllerContextTransitioning?
    private var panGesture: UIPanGestureRecognizer?
    private var shouldCompleteTransition: Bool = false
    
    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        super.startInteractiveTransition(transitionContext)
        
        // Save the transition context for future reference.
        contextData = transitionContext
        
        // Create a pan gesture recognizer to monitor events.
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipeUpdate(gestureRecognizer:)))
        guard let pan = panGesture else { return }
        pan.maximumNumberOfTouches = 1
    
        // Add the gesture recognizer to the container view.
        let container = transitionContext.containerView
        container.addGestureRecognizer(pan)
    }
    
    func handleSwipeUpdate(gestureRecognizer: UIGestureRecognizer) {
        guard let container = contextData?.containerView else { return }
        guard let pan = panGesture else { return }
        
        switch gestureRecognizer.state {
        case .began:
            // Reset the translation value at the beginning of the gesture.
            pan.setTranslation(CGPoint.zero, in: container)
        case .changed:
            // Get the current translation value.
            let translation: CGPoint = pan.translation(in: container)
            
            // Compute how far the gesture has travelled vertically,
            //  relative to the height of the container view.
            let percentage = fabs(translation.y / container.bounds.height)
            
            shouldCompleteTransition = percentage > 0.5
            // Use the translation value to update the interactive animator.
            update(percentage)
        case .ended, .cancelled:
            // Finish the transition and remove the gesture recognizer.
            if !shouldCompleteTransition {
                cancel()
            } else {
                finish()
                container.removeGestureRecognizer(pan)
            }
        default:
            print("Unsupported gesture \(pan) state")
        }
    }
}

extension PhotoBrowserAnimator: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else { return }
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else { return }
        
        if fromVC is PhotoBrowserController {
            dismissTransition(fromViewController: fromVC, toViewController: toVC, transitionContext)
        } else if toVC is PhotoBrowserController {
            presentTransition(fromViewController: fromVC, toViewController: toVC, transitionContext)
        } else {
            print("Either from or to View Controller should be instance of PhotoBrowserController")
            return
        }
    }
}

private extension PhotoBrowserAnimator {
    
    func presentTransition(fromViewController fromVC: UIViewController, toViewController toVC: UIViewController, _ transitionContext: UIViewControllerContextTransitioning) {
        let transitionVC = fromVC.unwrapNavigationControllerIfNeeded()
        
        guard let transitionDelegate = transitionVC as? PhotoBrowserTransitionSupport else { return }
        guard let photoBrowser = toVC as? PhotoBrowserController else { return }
        
        let containerView = transitionContext.containerView
        let animateImageView = UIImageView(image: transitionDelegate.transitionImage)
        animateImageView.clipsToBounds = true
        animateImageView.contentMode = .scaleAspectFill
        
        let initialFrame = containerView.convert(transitionDelegate.transitionImageView.bounds, from: transitionDelegate.transitionImageView)
        let finalFrame = endFrame(forImageView: animateImageView, toVC.view.frame)
        
        
        toVC.view.alpha = 0.0
        animateImageView.frame = initialFrame
        containerView.addSubview(toVC.view)
        containerView.addSubview(animateImageView)
        photoBrowser.setImageScrollViewHidden(true)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { 
            animateImageView.frame = finalFrame
            toVC.view.alpha = 1.0
        }) { _ in
            let success = !transitionContext.transitionWasCancelled
            if !success {
                toVC.view.removeFromSuperview()
            }
            animateImageView.removeFromSuperview()
            photoBrowser.setImageScrollViewHidden(false)
            transitionContext.completeTransition(success)
        }
    }
    
    func dismissTransition(fromViewController fromVC: UIViewController, toViewController toVC: UIViewController, _ transitionContext: UIViewControllerContextTransitioning) {
        guard let photoBrowser = fromVC as? PhotoBrowserController else { return }
        guard let displayingImage = photoBrowser.displayingImageView.image else { return }
        
        let transitionVC = toVC.unwrapNavigationControllerIfNeeded()
        guard let transitionDelegate = transitionVC as? PhotoBrowserTransitionSupport else { return }

        let containerView = transitionContext.containerView
        let animateImgaeView = UIImageView(image: displayingImage)
        animateImgaeView.clipsToBounds = true
        animateImgaeView.contentMode = .scaleAspectFill
        
        let initialFrame = photoBrowser.displayingImageView.frame
        let finalFrame = containerView.convert(transitionDelegate.transitionImageView.bounds, from: transitionDelegate.transitionImageView)
        
        toVC.view.alpha = 0.0
        animateImgaeView.frame = initialFrame
        containerView.addSubview(animateImgaeView)
        photoBrowser.setImageScrollViewHidden(true)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            toVC.view.alpha = 1.0
            fromVC.view.alpha = 0.0
            animateImgaeView.frame = finalFrame
        }) { _ in
            let success = !transitionContext.transitionWasCancelled
            if !success {
                fromVC.view.alpha = 1.0
            }
            animateImgaeView.removeFromSuperview()
            transitionContext.completeTransition(success)
        }        
    }
    
    func endFrame(forImageView imageView: UIImageView, _ bounds: CGRect) -> CGRect {
        guard let image = imageView.image else { return CGRect.zero }
        
        let minScale = ImageScrollView.scale(forBounds: bounds, image.size).minScale
        let imageFrame = imageView.frame
        let frame: CGRect = {
            let w = imageFrame.width * minScale
            let h = imageFrame.height * minScale
            return CGRect(x: (bounds.width - w) / 2.0, y: (bounds.height - h) / 2.0,
                          width: w, height: h)
        }()
        
        return frame
    }
}
