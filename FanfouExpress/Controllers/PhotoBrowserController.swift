//
//  PhotoBrowserController.swift
//  FanfouExpress
//
//  Created by Cencen Zheng on 4/20/17.
//  Copyright © 2017 Cencen Zheng. All rights reserved.
//

import UIKit
import Alamofire

class PhotoBrowserController: UIViewController {
    
    private let url: URL
    private let placeholderImage: UIImage
    private let imageScrollView: ImageScrollView
    
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
        
        view.addSubview(imageScrollView)
        view.backgroundColor = UIColor.black
        
        startLoading()
        Alamofire.request(url).validate().responseData { [weak self] (response) in
            guard let `self` = self else { return }
            
            guard let data = response.value else {
                self.showErrorMsg(withStatus: "Failed to download image")
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
}
