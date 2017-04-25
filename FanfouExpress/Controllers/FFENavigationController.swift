//
//  FFENavigationController.swift
//  FanfouExpress
//
//  Created by Cencen Zheng on 4/20/17.
//  Copyright © 2017 Cencen Zheng. All rights reserved.
//

import UIKit

class FFENavigationController: UINavigationController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        guard let visible = visibleViewController else {
            return super.preferredStatusBarStyle
        }
        return visible.preferredStatusBarStyle
    }
}
