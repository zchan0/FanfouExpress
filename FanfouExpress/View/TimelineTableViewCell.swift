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
    
    /// default value is CellStyle.ContentInsets
    var contentInsets: UIEdgeInsets {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// including content + screen name
    var parsedContent: String {
        return "\(contentLabel.attributedString.string)" + "\(screenNameLabel.text!)"
    }
    
    override var imageView: UIImageView? {
        return previewImageView
    }
    
    var tapPreviewImageBlock: ((UIImageView) -> Void)?

    private var contentLabel: DTAttributedLabel
    private var screenNameLabel: UILabel
    private var previewImageView: UIImageView
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        self.contentLabel = DTAttributedLabel()
        self.screenNameLabel = UILabel()
        self.previewImageView = UIImageView()
        self.contentInsets = CellStyle.ContentInsets
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.contentLabel.numberOfLines = 0
        
        self.screenNameLabel.textAlignment = .right
        self.screenNameLabel.font = CellStyle.ScreenNameFont
        
        self.previewImageView.isHidden = true
        self.previewImageView.clipsToBounds = true
        self.previewImageView.isUserInteractionEnabled = true
        self.previewImageView.contentMode = .scaleAspectFill
        self.previewImageView.backgroundColor = UIColor.lightGray
        self.previewImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapPreviewImage)))
        
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
        
        let contentSize = CGSize(width: contentView.bounds.width - contentInsets.left - contentInsets.right,
                                 height: contentView.bounds.height - contentInsets.top - contentInsets.bottom)
        let contentWidth = contentSize.width
        
        contentLabel.frame = {
            let height = contentLabel.attributedString.height(forOrigin: CGPoint(x: contentInsets.left, y: contentInsets.top),
                                                              forWidth: contentWidth)
            let frame = CGRect(origin: CGPoint(x: contentInsets.left, y: contentInsets.top),
                               size: CGSize(width: contentWidth, height: height))
            return frame
        }()
        
        if previewImageView.isHidden == false {
            previewImageView.frame = {
                return CGRect(origin: CGPoint(x: contentInsets.left, y: contentLabel.frame.maxY + CellStyle.ContentVerticalMargin),
                                   size: CGSize(width: contentWidth, height: CellStyle.ImageHeight))
            }()
        }
        
        screenNameLabel.frame = {
            let size = screenNameLabel.sizeThatFits(contentSize)
            let frame = CGRect(origin: CGPoint(x: contentInsets.left,
                                               y: previewImageView.isHidden ? contentLabel.frame.maxY + CellStyle.ContentVerticalMargin : previewImageView.frame.maxY + CellStyle.PreviewVerticalMargin),
                               size: CGSize(width: contentWidth, height: size.height))
            return frame
        }()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        tapPreviewImageBlock = nil
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
    
    /// Calculate height for TimelineTableViewCell
    ///
    /// - Parameters:
    ///   - msg: message
    ///   - width: excluding contentInsets.left and contentInsets.right
    ///   - contentInsets: default parameter is CellStyle.ContentInsets
    class func height(forMessage msg: Message, forWidth width: CGFloat, forContentInsets contentInsets: UIEdgeInsets = CellStyle.ContentInsets) -> CGFloat {
        guard let attributedContent = NSAttributedString(htmlData: msg.content.data(using: .utf8), options: CellStyle.ContentAttributes, documentAttributes: nil) else {
            print("Failed to convert \(msg.content) to attributed string with \(CellStyle.ContentAttributes)")
            return 0
        }
        
        let screenNameHeight = msg.realName.height(forFont: CellStyle.ScreenNameFont, forWidth: width)
        let imageHeight = (msg.image == nil) ? 0 : CellStyle.ImageHeight + CellStyle.PreviewVerticalMargin
        
        let contentHeight = attributedContent.height(forOrigin: CGPoint(x: contentInsets.left, y: contentInsets.top),
                                                     forWidth: width)
        
        return contentInsets.top
            + contentHeight + CellStyle.ContentVerticalMargin
            + screenNameHeight
            + imageHeight
            + contentInsets.bottom
    }
    
    @objc private func tapPreviewImage() {
        tapPreviewImageBlock?(previewImageView)
    }
}

