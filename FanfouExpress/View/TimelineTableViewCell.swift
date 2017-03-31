//
//  TimelineTableViewCell.swift
//  FanfouExpress
//
//  Created by Cencen Zheng on 3/25/17.
//  Copyright © 2017 Cencen Zheng. All rights reserved.
//

import Foundation
import UIKit

class TimelineTableViewCell: UITableViewCell {

    private var contentLabel: UILabel
    private var screenNameLabel: UILabel
    private var previewImageView: UIImageView
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        self.contentLabel = UILabel()
        self.screenNameLabel = UILabel()
        self.previewImageView = UIImageView()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentLabel.numberOfLines = 0
        self.contentLabel.font = CellStyle.ContentFont
        
        self.screenNameLabel.textAlignment = .right
        self.screenNameLabel.font = CellStyle.ScreenNameFont
        
        self.previewImageView.isHidden = true
        self.previewImageView.clipsToBounds = true
        self.previewImageView.contentMode = .scaleAspectFill
        self.previewImageView.backgroundColor = UIColor.lightGray
        
        self.contentView.addSubview(contentLabel)
        self.contentView.addSubview(screenNameLabel)
        self.contentView.addSubview(previewImageView)
        
        self.selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let contentSize = CGSize(width: contentView.bounds.width - CellStyle.ContentInsets.left - CellStyle.ContentInsets.right,
                                 height: contentView.bounds.height - CellStyle.ContentInsets.top - CellStyle.ContentInsets.bottom)
        let contentWidth = contentSize.width
        
        contentLabel.frame = {
            let size = contentLabel.sizeThatFits(contentSize)
            let frame = CGRect(origin: CGPoint(x: CellStyle.ContentInsets.left, y: CellStyle.ContentInsets.top),
                               size: CGSize(width: contentWidth, height: size.height))
            return frame
        }()
        
        if previewImageView.isHidden == false {
            previewImageView.frame = {
                return CGRect(origin: CGPoint(x: CellStyle.ContentInsets.left, y: contentLabel.frame.maxY + CellStyle.ContentVerticalMargin),
                                   size: CGSize(width: contentWidth, height: CellStyle.ImageHeight))
            }()
        }
        
        screenNameLabel.frame = {
            let size = screenNameLabel.sizeThatFits(contentSize)
            let frame = CGRect(origin: CGPoint(x: CellStyle.ContentInsets.left,
                                               y: previewImageView.isHidden ? contentLabel.frame.maxY + CellStyle.ContentVerticalMargin : previewImageView.frame.maxY + CellStyle.PreviewVerticalMargin),
                               size: CGSize(width: contentWidth, height: size.height))
            return frame
        }()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentLabel.text = nil
        screenNameLabel.text = nil
        previewImageView.image = nil
        previewImageView.isHidden = true
    }
    
    func updateContentWith(_ msg: Message) {
        contentLabel.text = msg.content
        screenNameLabel.text = "—— \(msg.realName)"
        
        if let imageURL = msg.image?.previewURL {
            previewImageView.isHidden = false
            previewImageView.setImage(withURL: imageURL)
        }
    }
}

