//
//  TimelineNavigationBar.swift
//  FanfouExpress
//
//  Created by Cencen Zheng on 3/26/17.
//  Copyright © 2017 Cencen Zheng. All rights reserved.
//

import UIKit

class TimelineNavigationbar: UINavigationBar {
    
    var title: String {
        didSet {
            titleLabel.attributedText = NSAttributedString(string: title,
                                                           attributes: [NSUnderlineStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue])
            setNeedsLayout()
        }
    }
    
    private let titleLabel: UILabel
    
    override init(frame: CGRect) {
        self.title = ""
        self.titleLabel = UILabel()
        super.init(frame: frame)
        
        self.titleLabel.font = NavigationBarAppearance.TitleFont
        self.titleLabel.textAlignment = .center
        self.addSubview(titleLabel)
        
        self.isTranslucent = false
        self.backgroundColor = UIColor.white
        // remove border
        self.shadowImage = UIImage()
        self.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let contentSize = self.bounds.size
        let titleSize = titleLabel.sizeThatFits(contentSize)
        titleLabel.frame.size = CGSize(width: contentSize.width, height: titleSize.height)
        titleLabel.frame.origin = CGPoint(x: 0, y: (contentSize.height - titleSize.height - UIDevice.statusBarHeight()) / 2 + UIDevice.statusBarHeight())
    }
}
