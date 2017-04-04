//
//  Helpers.swift
//  FanfouExpress
//
//  Created by Cencen Zheng on 4/3/17.
//  Copyright © 2017 Cencen Zheng. All rights reserved.
//

import Foundation

class DateUtils {
    
    private init() {}
    
    static let shared: DateUtils = DateUtils()
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    static let chineseDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter
    }()
    
    func randomDay(_ fromDate: Date, _ toDate: Date) -> Date? {
        if let daysBefore = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day {
            let random = Int(arc4random_uniform(UInt32(daysBefore)))
            var components = DateComponents()
            components.day = -1 * random
            return Calendar.current.date(byAdding: components, to: toDate)
        }
        
        return Date()
    }
}
