//
//  PhotoBrowserController.swift
//  FanfouExpress
//
//  Created by Cencen Zheng on 4/20/17.
//  Copyright © 2017 Cencen Zheng. All rights reserved.
//

import UIKit
import Alamofire
import Photos

class PhotoBrowserController: UIViewController {
    
    private let url: URL
    private let placeholderImage: UIImage
    private let imageScrollView: ImageScrollView
    
    var displayingImageView: UIImageView {
        return imageScrollView.imageView
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    init(withURL url: URL, _ placeholder: UIImage) {
        self.url = url
        self.placeholderImage = placeholder
        self.imageScrollView = ImageScrollView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageScrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageScrollView.displayImage(placeholderImage)
        // add gestures
        imageScrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(receiveSingleTap)))
        imageScrollView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(receiveLongPress)))
        
        view.addSubview(imageScrollView)
        view.backgroundColor = UIColor.black
        
        startLoading()
        Alamofire.request(url).validate().responseData { [weak self] (response) in
            guard let `self` = self else { return }
            
            guard let data = response.value else {
                self.showErrorMsg(withStatus: "加载图片失败")
                return
            }
            
            guard let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.stopLoading()
                self.imageScrollView.displayImage(image)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        imageScrollView.frame = view.bounds
    }
    
    func setImageScrollViewHidden(_ hidden: Bool) {
        imageScrollView.isHidden = hidden
    }
    
    /// in order to use custom transition animator, must set animated to be true
    @objc private func receiveSingleTap() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func receiveLongPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let cancellAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let savaImageAction = UIAlertAction(title: "保存图片", style: .default, handler: { [weak self] _ in
                guard let `self` = self else { return }
                self.startLoading(withStatus: "正在保存...")
                self.savaImage()
            })
            actionSheet.addAction(cancellAction)
            actionSheet.addAction(savaImageAction)
            present(actionSheet, animated: true, completion: nil)
        }
    }
    
    private func checkPhotoAuthorizationStatus() -> PHAuthorizationStatus {
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        if authorizationStatus == .notDetermined {
            PHPhotoLibrary.requestAuthorization({ _ in
                self.savaImage()
            })
        }
        return authorizationStatus
    }
    
    private func savaImage() {
        guard let image = imageScrollView.imageView.image else {
            stopLoading()
            showErrorMsg(withStatus: "保存失败")
            return
        }
        
        let status: PHAuthorizationStatus = checkPhotoAuthorizationStatus()
        switch status {
        case .denied, .restricted:
            stopLoading()
            showErrorMsg(withStatus: "没有权限")
        case .notDetermined:
            stopLoading()
        case .authorized:
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }) { (success, error) in
                self.stopLoading()
                if success {
                    self.showSuccessMsg(withStatus: "保存成功")
                } else {
                    self.showErrorMsg(withStatus: "保存失败")
                }
                if let error = error {
                    print("Save image failed due to \(error.localizedDescription)")
                }
            }
        }
        
    }
}
