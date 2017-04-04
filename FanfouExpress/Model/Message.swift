//
//  Message.swift
//  FanfouExpress
//
//  Created by Cencen Zheng on 3/23/17.
//  Copyright © 2017 Cencen Zheng. All rights reserved.
//

import Foundation
import Alamofire

struct Message {
    let identifier: String
    let count: Int
    let realName: String
    let loginName: String
    let avatarURL: URL
    let time: String
    let statusID: String
    let content: String
    let image: Image?
    
    var statusURL: URL? {
        get {
            return URL(string: "\(Constants.StatusBaseUrl)" + "/\(statusID)")
        }
    }
    
    var description: String {
        return "Message: { id: \(identifier), count: \(count), realname: \(realName), loginname: \(loginName), avatar: \(avatarURL), time: \(time), statusid: \(statusID), content: \(content), \(image?.description ?? "") }"
    }
    
    init?(json: Dictionary<String, Any>) {
        guard let identifier = json[JSONResponseKeys.Identifier] as? String else { return nil }
        guard let count = json[JSONResponseKeys.Count] as? String else { return nil }
        guard let realName  = json[JSONResponseKeys.Realname] as? String else { return nil }
        guard let loginName = json[JSONResponseKeys.Loginname] as? String else { return nil }
        guard let avatarUrl = json[JSONResponseKeys.Avatar] as? String else { return nil }
        guard let time = json[JSONResponseKeys.Time] as? String else { return nil }
        guard let statusID = json[JSONResponseKeys.StatusID] as? String else { return nil }
        guard let content  = json[JSONResponseKeys.Content] as? String else { return nil }
        
        self.identifier = identifier
        self.realName   = realName
        self.loginName  = loginName
        self.time       = time
        self.statusID   = statusID
        self.content    = content
        
        self.count = Int(count) ?? 0
        self.avatarURL = URL(string: avatarUrl.replacingOccurrences(of: "/s0/", with: "/l0/")) ?? URL(string: Constants.EmptyAvatar)!
        
        if let image = json[JSONResponseKeys.Image] as? [String : String] {
            self.image = Image(json: image)
        } else {
            self.image = nil
        }
    }
}

struct Image {
    let previewURL: URL //  缩略图地址
    let pageURL: URL // 图片在饭否上的页面地址
    
    var description: String {
        return "Image: { preview: \(previewURL.absoluteString), page: \(pageURL.absoluteString) }"
    }
    
    init?(json: Dictionary<String, String>) {
        guard let pageUrl = json[JSONResponseKeys.Page], pageUrl.isEmpty == false else { return nil }
        guard let previewUrl = json[JSONResponseKeys.Preview], previewUrl.isEmpty == false else { return nil }
        
        guard let pageURL = URL(string: pageUrl) else { return nil }
        guard let previewURL = URL(string: previewUrl.replacingOccurrences(of: "/m0/", with: "/n0/")) else { return nil }
        
        self.pageURL = pageURL
        self.previewURL = previewURL
    }
}
