//
//  Digest.swift
//  FanfouExpress
//
//  Created by Cencen Zheng on 3/23/17.
//  Copyright © 2017 Cencen Zheng. All rights reserved.
//

import Foundation

struct Digest {
    let shift: String
    let shiftCN: String
    let date: String
    let msgs: [Message]
    
    var description: String {
        let desc = "shift: \(shift), shiftCN: \(shiftCN), date: \(date)\n"
        let messagesDesc = msgs.flatMap({ $0.description }).joined(separator: ",\n")
        return "Digest: { \(desc), \(messagesDesc) }"
    }
    
    init?(json: JSON) {
        guard let shift = json[JSONResponseKeys.Shift] as? String else { return nil }
        guard let shiftCN = json[JSONResponseKeys.ShiftCN] as? String else { return nil }
        guard let date = json[JSONResponseKeys.Date] as? String else { return nil }
        guard let msgs = json[JSONResponseKeys.Messages] as? [Any] else { return nil }
        
        self.shift = shift
        self.shiftCN = shiftCN
        self.date = date
        self.msgs = msgs.flatMap({
            if let msgDict = $0 as? JSON {
                return Message(json: msgDict)
            }
            return nil
        })
    }

}
