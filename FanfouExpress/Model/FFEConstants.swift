//
//  FFEConstants.swift
//  FanfouExpress
//
//  Created by Cencen Zheng on 3/24/17.
//  Copyright © 2017 Cencen Zheng. All rights reserved.
//

import Foundation

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
