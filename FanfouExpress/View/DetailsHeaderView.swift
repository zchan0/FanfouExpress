//
//  DetailsHeaderView.swift
//  FanfouExpress
//
//  Created by Cencen Zheng on 3/30/17.
//  Copyright © 2017 Cencen Zheng. All rights reserved.
//

import UIKit

class DetailsHeaderView: UIView {
    
    var avatar: UIImage? {
        didSet {
            guard let avatar = avatar else {
                return
            }
            avatarImageView.image = avatar
            setNeedsLayout()
        }
    }
    
    private let quotationLabel: UILabel
    private let avatarImageView: UIImageView
    
    override init(frame: CGRect) {
        quotationLabel = UILabel()
        avatarImageView = UIImageView()
        super.init(frame: frame)
        
        // avatar image view
        avatarImageView.clipsToBounds = true
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.backgroundColor = UIColor.lightGray
        avatarImageView.layer.borderWidth = 2
        avatarImageView.layer.borderColor = FFEColor.AccentColor.cgColor
        avatarImageView.layer.cornerRadius = HeaderStyle.AvatarHeight / 2
        
        // quotation label
        quotationLabel.text = "“"
        quotationLabel.textColor = FFEColor.AccentColor
        quotationLabel.font = HeaderStyle.QuotationFont
        
        addSubview(avatarImageView)
        addSubview(quotationLabel)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let labelSize = quotationLabel.sizeThatFits(size)
        let h = HeaderStyle.AvatarVerticalMargin + HeaderStyle.AvatarHeight + HeaderStyle.QuotationVerticalMargin + labelSize.height
        
        return CGSize(width: size.width, height: h)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let contentSize = bounds.size
        
        avatarImageView.frame = {
            return CGRect(x: (contentSize.width - HeaderStyle.AvatarHeight) / 2, y: HeaderStyle.AvatarVerticalMargin,
                          width: HeaderStyle.AvatarHeight, height: HeaderStyle.AvatarHeight)
        }()
        
        quotationLabel.frame = {
            let labelSize = quotationLabel.sizeThatFits(contentSize)
            return CGRect(origin: CGPoint(x: HeaderStyle.HorizontalPadding, y: avatarImageView.frame.maxY + HeaderStyle.AvatarVerticalMargin),
                          size: CGSize(width: contentSize.width - HeaderStyle.HorizontalPadding * 2, height: labelSize.height))
        }()
    }
}

private extension DetailsHeaderView {
    struct HeaderStyle {
        
        // Font
        static let QuotationFont: UIFont = UIFont(name: "Arial Rounded MT Bold", size: 60)!
        
        // Spacing
        static let HorizontalPadding: CGFloat = 20
        static let AvatarVerticalMargin: CGFloat = 30   // margin between avatarImageView and buttons above it
        static let QuotationVerticalMargin: CGFloat = 10    // margin beween quotationLabel and avatarImageView
        
        // Avatar
        static let AvatarHeight: CGFloat = 100
    }
}

