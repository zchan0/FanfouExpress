//
//  EmptyView.swift
//  FanfouExpress
//
//  Created by Cencen Zheng on 17/05/2017.
//  Copyright © 2017 Cencen Zheng. All rights reserved.
//

import UIKit

class EmptyView: UIView {
    enum EmptyViewStyle: Int {
        case defaultStyle
        case errorStyle
    }
    
    var style: EmptyViewStyle {
        didSet {
            customStyle()
        }
    }
    
    var refreshBlock: (() -> ())?
    
    private let titleLable: UILabel
    private let subtitleLabel: UILabel
    
    override init(frame: CGRect) {
        style = .defaultStyle
        titleLable = UILabel()
        subtitleLabel = UILabel()
        super.init(frame: frame)
        
        titleLable.font = UIFont.defaultFont(ofSize: 24)
        titleLable.textAlignment = .center

        subtitleLabel.attributedText = NSAttributedString(string: "点击刷新",
                                                          attributes: [NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue, NSAttributedStringKey.font: UIFont.defaultFont(ofSize: 18)])
        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = .gray
        
        addSubview(titleLable)
        addSubview(subtitleLabel)
        
        backgroundColor = .white
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleRefreshGesture)))
        
        customStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let contentSize = bounds.size
        
        subtitleLabel.frame = {
            let labelH = subtitleLabel.sizeThatFits(contentSize).height
            let originY = (contentSize.height - labelH) / 2.0
            return CGRect(x: 0, y: originY, width: contentSize.width, height: labelH)
        }()
        
        titleLable.frame = {
            let labelH = titleLable.sizeThatFits(contentSize).height
            let originY = subtitleLabel.frame.minY - 5.0 - labelH
            return CGRect(x: 0, y: originY, width: contentSize.width, height: labelH)
        }()
    }
    
    private func customStyle() {
        subtitleLabel.isHidden = false
        
        switch style {
        case .defaultStyle:
            titleLable.text = "空空如也🙀"
        case .errorStyle:
            titleLable.text = "加载失败🙈"
        }
    }
    
    @objc private func handleRefreshGesture() {
        subtitleLabel.isHidden = true
        refreshBlock?()
    }
}
