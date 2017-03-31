//
//  DetailsViewController.swift
//  FanfouExpress
//
//  Created by Cencen Zheng on 3/30/17.
//  Copyright © 2017 Cencen Zheng. All rights reserved.
//

import UIKit

class DetailsViewController: UITableViewController {
    
    private let headerView: DetailsHeaderView
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        headerView = DetailsHeaderView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configNavigationBar()
        
        tableView.separatorStyle = .none
        tableView.tableHeaderView = headerView
        
        headerView.avatar = #imageLiteral(resourceName: "avatar")
    }

}

private extension DetailsViewController {
    func configNavigationBar() {
        // UI
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer.width = 5
        
        let doneButton = UIBarButtonItem(image: #imageLiteral(resourceName: "navi-down"), style: .plain, target: self, action: #selector(pressDoneButton))
        doneButton.tintColor = FFEColor.PrimaryColor
        navigationItem.leftBarButtonItems = [spacer, doneButton]
        
        let shareButton = UIBarButtonItem(image: #imageLiteral(resourceName: "navi-share"), style: .plain, target: self, action: #selector(pressedShareButton))
        shareButton.tintColor = FFEColor.PrimaryColor
        navigationItem.rightBarButtonItems = [spacer, shareButton]
    }
    
    @objc func pressDoneButton() {
        
    }
    
    @objc func pressedShareButton() {
        
    }
}

