//
//  ImageScrollView.swift
//  FanfouExpress
//
//  Created by Cencen Zheng on 4/20/17.
//  Copyright © 2017 Cencen Zheng. All rights reserved.
//

import UIKit

class ImageScrollView: UIScrollView {
    
    var zoomView: UIImageView?
    var imageSize: CGSize = CGSize.zero
    var pointToCenterAfterResize: CGPoint = CGPoint.zero
    var scaleToRestoreAfterResize: CGFloat = 0
    
    var maximumContentOffset: CGPoint {
        return CGPoint(x: contentSize.width - bounds.width, y: contentSize.height - bounds.height)
    }
    
    var minimumContentOffset: CGPoint {
        return CGPoint.zero
    }
    
    override var frame: CGRect {
        didSet {
            prepareToResize()
            super.frame = frame
            recoverFromResizing()
        }
    }
    
    override init(frame: CGRect) {
        zoomView = UIImageView()
        super.init(frame: frame)
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.bouncesZoom = true
        self.decelerationRate = UIScrollViewDecelerationRateFast
        self.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // avoid setting zoomView's frame if it hasn't been initilized
        guard let zoomView = zoomView else { return }
        
        // center the zoom view as it becomes smaller than the size of the screen
        let boundsSize = bounds.size
        var frameToCenter = zoomView.frame
        
        // center horizontally
        if frameToCenter.width < boundsSize.width {
            frameToCenter.origin.x = (boundsSize.width - frameToCenter.width) / 2.0
        } else {
            frameToCenter.origin.x = 0
        }
        
        // center vertically
        if frameToCenter.height < boundsSize.height {
            frameToCenter.origin.y = (boundsSize.height - frameToCenter.height) / 2.0
        } else {
            frameToCenter.origin.y = 0
        }
        
        zoomView.frame = frameToCenter
    }

    func displayImage(_ image: UIImage) {
        // clear the previous iamge
        if let _ = zoomView {
            zoomView!.removeFromSuperview()
            zoomView = nil
        }
        
        // reset our zoomScale to 1.0 before doing any further calculations
        zoomScale = 1.0
        minimumZoomScale = 1.0
        maximumZoomScale = 1.0
        
        // make a new UIImageView for the new image
        zoomView = UIImageView(image: image)
        addSubview(zoomView!)
        
        configureForImageSize(image.size)
    }
}

extension ImageScrollView: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return zoomView
    }
}

private extension ImageScrollView {
    
    func configureForImageSize(_ size: CGSize) {
        imageSize = size
        contentSize = size
        setMaxMinZoomScalesForCurrentBounds()
        zoomScale = minimumZoomScale
    }
    
    func setMaxMinZoomScalesForCurrentBounds() {
        // calculate min/max zoomscale
        let xScale: CGFloat = bounds.width / imageSize.width // the scale needed to perfectly fit the image width-wise
        let yScale: CGFloat = bounds.height / imageSize.height  // the scale needed to perfectly fit the image height-wise
        
        // fill width if the image and phone are both portrait or both landscape; otherwise take smaller scale
        let imagePortrait = imageSize.height > imageSize.width
        let phonePortrait = bounds.height > bounds.width
        var minScale: CGFloat = imagePortrait == phonePortrait ? xScale : fmin(xScale, yScale)
        
        let maxScale: CGFloat = 1.0
        
        // don't let minScale exceed maxScale. (If the image is smaller than the screen, we don't want to force it to be zoomed.)
        if minScale > maxScale {
            minScale = maxScale
        }
        
        minimumZoomScale = minScale
        maximumZoomScale = maxScale
    }
    
    func prepareToResize() {
        let boundsCenter: CGPoint = CGPoint(x: bounds.midX, y: bounds.midY)
        pointToCenterAfterResize  = convert(boundsCenter, to: zoomView)
        scaleToRestoreAfterResize = zoomScale
        
        // If we're at the minimum zoom scale, preserve that by returning 0, which will be converted to the minimum
        // allowable scale when the scale is restored.
        if scaleToRestoreAfterResize <= minimumZoomScale + CGFloat(Float.ulpOfOne) {
            scaleToRestoreAfterResize = 0
        }
    }
    
    func recoverFromResizing() {
        setMaxMinZoomScalesForCurrentBounds()
        
        // Step 1: restore zoom scale, first making sure it is within the allowable range.
        let maxZoomScale: CGFloat = fmax(minimumZoomScale, scaleToRestoreAfterResize)
        zoomScale = fmax(maximumZoomScale, maxZoomScale)
        
        // Step 2: restore center point, first making sure it is within the allowable range.
        
        // 2a: convert our desired center point back to our own coordinate space
        let boundsCenter = convert(pointToCenterAfterResize, to: zoomView)
        
        // 2b: calculate the content offset that would yield that center point
        var offset: CGPoint = CGPoint(x: boundsCenter.x - bounds.width / 2.0, y: boundsCenter.y - bounds.height / 2.0)
        
        // 2c: restore offset, adjusted to be within the allowable range
        let maxOffset: CGPoint = maximumContentOffset
        let minOffset: CGPoint = minimumContentOffset
        
        var realMaxOffset: CGFloat = fmin(maxOffset.x, offset.x)
        offset.x = fmax(minOffset.x, realMaxOffset)
        
        realMaxOffset = fmin(maxOffset.y, offset.y)
        offset.y = fmax(minOffset.y, realMaxOffset)
        
        contentOffset = offset
    }
}
