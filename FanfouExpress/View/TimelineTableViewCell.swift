//
//  TimelineTableViewCell.swift
//  FanfouExpress
//
//  Created by Cencen Zheng on 3/25/17.
//  Copyright © 2017 Cencen Zheng. All rights reserved.
//

import Foundation
import UIKit
import DTCoreText

class TimelineTableViewCell: UITableViewCell {
    
    var textDelegate: DTAttributedTextContentViewDelegate? {
        didSet {
            contentLabel.delegate = textDelegate
        }
    }

    private var contentLabel: DTAttributedLabel
    private var screenNameLabel: UILabel
    private var previewImageView: UIImageView
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        self.contentLabel = DTAttributedLabel()
        self.screenNameLabel = UILabel()
        self.previewImageView = UIImageView()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentLabel.numberOfLines = 0
        
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
            let height = contentLabel.attributedString.height(forOrigin: CGPoint(x: CellStyle.ContentInsets.left, y: CellStyle.ContentInsets.top),
                                                              forWidth: contentWidth)
            let frame = CGRect(origin: CGPoint(x: CellStyle.ContentInsets.left, y: CellStyle.ContentInsets.top),
                               size: CGSize(width: contentWidth, height: height))
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
        contentLabel.attributedString = nil
        screenNameLabel.text = nil
        previewImageView.image = nil
        previewImageView.isHidden = true
    }
    
// - MARK: 
    
    func updateCell(_ msg: Message) {
        screenNameLabel.text = "—— \(msg.realName)"
        
        let attributedContent = NSAttributedString(htmlData: msg.content.data(using: .utf8), options: CellStyle.ContentAttributes, documentAttributes: nil)
        contentLabel.attributedString = attributedContent
        
        if let imageURL = msg.image?.previewURL {
            previewImageView.isHidden = false
            previewImageView.setImage(withURL: imageURL)
        }
    }
    
    class func height(forMessage msg: Message, forWidth width: CGFloat) -> CGFloat {
        guard let attributedContent = NSAttributedString(htmlData: msg.content.data(using: .utf8), options: CellStyle.ContentAttributes, documentAttributes: nil) else {
            print("Failed to convert \(msg.content) to attributed string with \(CellStyle.ContentAttributes)")
            return 0
        }
        
        let screenNameHeight = msg.realName.height(forFont: CellStyle.ScreenNameFont, forWidth: width)
        let imageHeight = (msg.image == nil) ? 0 : CellStyle.ImageHeight + CellStyle.PreviewVerticalMargin
        
        let contentHeight = attributedContent.height(forOrigin: CGPoint(x: CellStyle.ContentInsets.left, y: CellStyle.ContentInsets.top),
                                                     forWidth: width)
        
        return CellStyle.ContentInsets.top
            + contentHeight + CellStyle.ContentVerticalMargin
            + screenNameHeight
            + imageHeight
            + CellStyle.ContentInsets.bottom
    }
}

