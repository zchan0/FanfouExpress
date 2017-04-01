//
//  DetailsTableViewCell.swift
//  FanfouExpress
//
//  Created by Cencen Zheng on 3/31/17.
//  Copyright © 2017 Cencen Zheng. All rights reserved.
//

import UIKit

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

