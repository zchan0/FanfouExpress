//
//  DetailsTableViewCell.swift
//  FanfouExpress
//
//  Created by Cencen Zheng on 3/31/17.
//  Copyright © 2017 Cencen Zheng. All rights reserved.
//

import UIKit

// MARK: - Header

class DetailHeaderCell: UITableViewCell {
        
    private let quotationLabel: UILabel
    private let avatarImageView: UIImageView
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        quotationLabel = UILabel()
        avatarImageView = UIImageView()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // avatar image view
        avatarImageView.clipsToBounds = true
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.backgroundColor = UIColor.lightGray
        avatarImageView.layer.borderWidth = 2
        avatarImageView.layer.borderColor = FFEColor.AccentColor.cgColor
        avatarImageView.layer.cornerRadius = DetailCellStyle.AvatarHeight / 2
        
        // quotation label
        quotationLabel.text = "“"
        quotationLabel.textColor = FFEColor.AccentColor
        quotationLabel.font = DetailCellStyle.QuotationFont
        
        contentView.addSubview(quotationLabel)
        contentView.addSubview(avatarImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let contentRect = UIEdgeInsetsInsetRect(CGRect(x: 0, y: 0, width: contentView.bounds.width, height: contentView.bounds.height),
                                                DetailCellStyle.ContentInsets)
        let contentSize = contentRect.size
        
        avatarImageView.frame = {
            return CGRect(x: (contentView.bounds.width - DetailCellStyle.AvatarHeight) / 2, y: DetailCellStyle.AvatarVerticalMargin,
                          width: DetailCellStyle.AvatarHeight, height: DetailCellStyle.AvatarHeight)
        }()
        
        quotationLabel.frame = {
            let labelSize = quotationLabel.sizeThatFits(contentSize)
            return CGRect(origin: CGPoint(x: DetailCellStyle.QuotationHorizontalPadding, y: avatarImageView.frame.maxY + DetailCellStyle.AvatarVerticalMargin),
                          size: CGSize(width: contentSize.width, height: labelSize.height))
        }()
    }
    
    func updateCell(withAvatar avatarURL: URL) {
        avatarImageView.setImage(withURL: avatarURL)
    }
}

// MARK: - Content

class DetailContentCell: UITableViewCell {
    
    private var contentFont: UIFont {
        get {
            return previewImageView.isHidden ? DetailCellStyle.ContentFontWithoutImage : DetailCellStyle.ContentFontWithImage
        }
    }
    
    private let textView: UITextView
    private let previewImageView: UIImageView
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        textView = UITextView()
        previewImageView = UIImageView()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        previewImageView.isHidden = true
        previewImageView.clipsToBounds = true
        previewImageView.contentMode = .scaleAspectFill
        previewImageView.backgroundColor = UIColor.lightGray
        
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.textContainerInset = UIEdgeInsets.zero

        contentView.addSubview(previewImageView)
        contentView.addSubview(textView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let contentRect = UIEdgeInsetsInsetRect(CGRect(x: 0, y: 0, width: contentView.bounds.width, height: contentView.bounds.height),
                                                DetailCellStyle.ContentInsets)
        let contentSize = contentRect.size
        
        textView.frame = {
            let textHeight = textView.text.height(forFont: contentFont, forWidth: contentSize.width)
            return CGRect(origin: contentRect.origin,
                          size: CGSize(width: contentSize.width, height: textHeight))
        }()
        
        if previewImageView.isHidden == false {
            previewImageView.frame = {
                return CGRect(origin: CGPoint(x: DetailCellStyle.ContentInsets.left, y: textView.frame.maxY + DetailCellStyle.ContentVerticalMargin),
                              size: CGSize(width: contentSize.width, height: DetailCellStyle.ImageHeight))
            }()
        }
    }
    
    func updateCell(withContent content: String, withImage imageURL: URL?) {
        if let imageURL = imageURL {
            previewImageView.isHidden = false
            previewImageView.setImage(withURL: imageURL)
        }
        
        textView.text = content
        textView.font = contentFont
    }
    
}

// MARK: - Footer

class DetailFooterCell: UITableViewCell {
    
    private let screenNameLabel: UILabel
    
    init(realName: String) {
        screenNameLabel = UILabel()
        super.init(style: .default, reuseIdentifier: nil)
        
        screenNameLabel.text = "——\(realName)"
        screenNameLabel.textAlignment = .right
        screenNameLabel.font = DetailCellStyle.ScreenNameFont
        
        contentView.addSubview(screenNameLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let contentRect = UIEdgeInsetsInsetRect(CGRect(x: 0, y: 0, width: contentView.bounds.width, height: contentView.bounds.height),
                                                DetailCellStyle.ContentInsets)
        let contentSize = contentRect.size
        
        screenNameLabel.frame = {
           let labelSize = screenNameLabel.sizeThatFits(contentSize)
            return CGRect(origin: CGPoint(x: DetailCellStyle.ContentInsets.left, y: 0),
                          size: CGSize(width: contentSize.width, height: labelSize.height))
        }()
    }
}


