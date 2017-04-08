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
        self.quotationLabel = UILabel()
        self.avatarImageView = UIImageView()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // avatar image view
        self.avatarImageView.clipsToBounds = true
        self.avatarImageView.contentMode = .scaleAspectFill
        self.avatarImageView.backgroundColor = UIColor.lightGray
        self.avatarImageView.layer.borderWidth = 2
        self.avatarImageView.layer.borderColor = FFEColor.AccentColor.cgColor
        self.avatarImageView.layer.cornerRadius = DetailCellStyle.AvatarHeight / 2
        
        // quotation label
        self.quotationLabel.text = "“"
        self.quotationLabel.textColor = FFEColor.AccentColor
        self.quotationLabel.font = DetailCellStyle.QuotationFont

        self.contentView.addSubview(quotationLabel)
        self.contentView.addSubview(avatarImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let contentSize = contentView.bounds.size

        avatarImageView.frame = {
            let avatarX = (contentView.bounds.width - DetailCellStyle.AvatarHeight) / 2
            let avatarY = DetailCellStyle.AvatarVerticalMargin
            let avatarSize = DetailCellStyle.AvatarHeight
            return CGRect(x: avatarX, y: avatarY, width: avatarSize, height: avatarSize)
        }()
        
        quotationLabel.frame = {
            let labelX = DetailCellStyle.QuotationHorizontalPadding
            let labelY = avatarImageView.frame.maxY + DetailCellStyle.AvatarVerticalMargin
            let labelSize = quotationLabel.sizeThatFits(contentSize)
            return CGRect(x: labelX, y: labelY, width: contentSize.width, height: labelSize.height)
        }()
    }
    
    func updateCell(withAvatar avatarURL: URL) {
        avatarImageView.setImage(withURL: avatarURL)
    }
    
    class func height(forWidth width: CGFloat) -> CGFloat {
        let quotationHeight = "“".height(forFont: DetailCellStyle.QuotationFont, forWidth: width)
        return DetailCellStyle.AvatarVerticalMargin + DetailCellStyle.AvatarHeight
            + DetailCellStyle.QuotationVerticalMargin + quotationHeight
    }
}
