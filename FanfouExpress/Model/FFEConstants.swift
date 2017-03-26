//
//  FFEConstants.swift
//  FanfouExpress
//
//  Created by Cencen Zheng on 3/24/17.
//  Copyright © 2017 Cencen Zheng. All rights reserved.
//

import Foundation
import UIKit

typealias JSON = [String : Any]

struct Constants {
    static let defaultFontName = "Pingfang SC"
}

// - MARK:

struct CellStyle {
    
    // Font
    static let ContentSize: CGFloat = 24
    static let ContentFont: UIFont = UIFont.defaultFont(ofSize: CellStyle.ContentSize)

    static let ScreenNameSize: CGFloat = 17
    static let ScrrenNameFont: UIFont = UIFont.defaultFont(ofSize: CellStyle.ScreenNameSize)
    
    // Spacing
    static let ContentVerticalMargin: CGFloat = 15  // margin between contentLabel and the element below it
    static let PreviewVerticalMargin: CGFloat = 15  // margin between previewImageView and the element below it
    static let ContentInsets = UIEdgeInsets(top: 15, left: 20, bottom: 10, right: 20)  // paddings
    
    // Image
    static let ImageHeight: CGFloat = 250
}

// - MARK:

extension Digest {
    
    struct JSONResponseKeys {
        static let Shift = "shift"
        static let ShiftCN = "shift_cn"
        static let Date = "date"
        static let Messages = "msgs"
    }
}

// - MARK:

extension Message {
    
    struct Constants {
        static let EmptyAvatar = "http://s3.meituan.net/v1/mss_3d027b52ec5a4d589e68050845611e68/avatar/l0/00/00/00.jpg"
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

// - MARK:

extension Image {
    
    struct JSONResponseKeys {
        static let Preview = "preview"
        static let Page = "page"
    }
}
