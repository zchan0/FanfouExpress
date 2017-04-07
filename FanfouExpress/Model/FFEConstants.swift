//
//  FFEConstants.swift
//  FanfouExpress
//
//  Created by Cencen Zheng on 3/24/17.
//  Copyright © 2017 Cencen Zheng. All rights reserved.
//

import Foundation
import UIKit
import DTCoreText

typealias JSON = [String : Any]

struct Constants {
    static let DefaultFontName = "STKaiti"
    static let HTTPScheme  = "http"
    static let HTTPSScheme = "https"
    
    static let StartDate = "2015-10-05"
}

struct FFEColor {
    static let PrimaryColor = UIColor(red: 64 / 255, green: 64 / 255, blue: 64 / 255, alpha: 1)
    static let AccentColor = UIColor(red: 255 / 255, green: 45 / 255, blue: 85 / 255, alpha: 1)
}

struct CellStyle {
    
    // Font
    static let ContentSize: CGFloat = 24
    static let ContentFont: UIFont = UIFont.defaultFont(ofSize: CellStyle.ContentSize)
    static let ContentAttributes = [
        DTDefaultFontName: Constants.DefaultFontName,
        DTDefaultFontSize: CellStyle.ContentSize,
        DTDefaultLinkColor: FFEColor.AccentColor,
        DTDefaultLineHeightMultiplier: 1.2,
        DTDefaultLinkDecoration: false
    ] as [String: Any]

    static let ScreenNameSize: CGFloat = 17
    static let ScreenNameFont: UIFont = UIFont.defaultFont(ofSize: CellStyle.ScreenNameSize)
    
    // Spacing
    static let ContentVerticalMargin: CGFloat = 15  // margin between contentLabel and the element below it
    static let PreviewVerticalMargin: CGFloat = 15  // margin between previewImageView and the element below it
    static let ContentInsets = UIEdgeInsets(top: 10, left: 25, bottom: 10, right: 20)  // paddings
    
    // Image
    static let ImageHeight: CGFloat = 250
}

struct DetailCellStyle {
    
    // Font
    static let QuotationFont: UIFont  = UIFont(name: "Arial Rounded MT Bold", size: 50)!
    
    // Spacing
    static let ContentInsets: UIEdgeInsets  = UIEdgeInsets(top: 0, left: 40, bottom: 20, right: 25)

    // Button
    static let ButtonSize: CGFloat = 20
    static let ButtonVerticalMargin: CGFloat = 15
    static let ButtonHorizontalMargin: CGFloat = 20
    
    // Quotation
    static let QuotationVerticalMargin: CGFloat = 8    // margin beween quotationLabel and avatarImageView
    static let QuotationHorizontalPadding: CGFloat = 20
    
    // Image
    static let AvatarHeight: CGFloat = 96
    static let AvatarVerticalMargin: CGFloat = 30   // margin between avatarImageView and buttons above it
}

struct TransitionStyle {
    
    static let BackgroundOriginX: CGFloat = 25
    static let BackgroundVerticalMargin: CGFloat = 8    // margin between presenting and presented view
}

struct NavigationBarAppearance {
    
    // Font
    static let TitleSize: CGFloat = 19
    static let TitleFont: UIFont = UIFont.defaultFont(ofSize: NavigationBarAppearance.TitleSize)
}

extension Digest {
    
    struct JSONResponseKeys {
        static let Shift = "shift"
        static let ShiftCN = "shift_cn"
        static let Date = "date"
        static let Messages = "msgs"
    }
}

extension Message {
    
    struct Constants {
        static let EmptyAvatar = "http://s3.meituan.net/v1/mss_3d027b52ec5a4d589e68050845611e68/avatar/l0/00/00/00.jpg"
        static let StatusBaseUrl = "http://fanfou.com/statuses"
    }
    
    struct JSONResponseKeys {
        static let Identifier = "id"
        static let Count = "count"
        static let Realname = "realname"
        static let Loginname = "loginname"
        static let Avatar = "avatar"
        static let Time = "time"
        static let StatusID = "statusid"
        static let Content = "msg"
        static let Image = "img"
    }
}

extension Image {
    
    struct JSONResponseKeys {
        static let Preview = "preview"
        static let Page = "page"
    }
}
