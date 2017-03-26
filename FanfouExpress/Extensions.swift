//
//  Extensions.swift
//  FanfouExpress
//
//  Created by Cencen Zheng on 3/26/17.
//  Copyright © 2017 Cencen Zheng. All rights reserved.
//

import UIKit
import Alamofire

extension String {
    func height(forFont font: UIFont, forWidth width: CGFloat) -> CGFloat {
        let boundingBox = (self as NSString).boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
                                                          options: .usesLineFragmentOrigin,
                                                          attributes: [NSFontAttributeName : font], context: nil) as CGRect
        return CGFloat(ceilf(Float(boundingBox.height)))
    }
    
}

extension UIFont {
    class func defaultFont(ofSize size: CGFloat) -> UIFont {
        guard let font = UIFont(name: Constants.defaultFontName, size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        return font
    }
}

extension UIImageView {
    
    func setImage(withURL URL: URL) {
        Alamofire.request(URL).validate().responseData { (response) in
            guard let data = response.value else {
                print("Failed to download image")
                return
            }
            let image = UIImage(data: data)
            self.image = image
        }
    }
}

extension UITableView {
    
    private func reuseIdentifier(ofClass T: AnyClass) -> String {
         return String(describing: T)
    }
    
    func register<T: UITableViewCell>(_ : T.Type) {
        register(T.self, forCellReuseIdentifier: reuseIdentifier(ofClass: T.self))
    }
    
    func dequeue<T: UITableViewCell>(indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: reuseIdentifier(ofClass: T.self), for: indexPath) as? T else {
            print("Failed to find \(reuseIdentifier(ofClass: T.self)) for \(T.self)")
            return T.init()
        }
        return cell
    }
}
