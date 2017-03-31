//
//  DetailsViewController.swift
//  FanfouExpress
//
//  Created by Cencen Zheng on 3/30/17.
//  Copyright © 2017 Cencen Zheng. All rights reserved.
//

import UIKit

class DetailsViewController: UITableViewController {
    
    var msg: Message?
    var dataArray: [UITableViewCell]
    
    override init(style: UITableViewStyle) {
        self.msg = nil
        self.dataArray = [UITableViewCell]()
        super.init(style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configNavigationBar()
        
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        
        guard let msg = msg else {
            return
        }
        
        let headerCell = DetailHeaderCell(style: .default, reuseIdentifier: nil)
        headerCell.updateCell(withAvatar: msg.avatarURL)
        
        let contentCell = DetailContentCell(style: .default, reuseIdentifier: nil)
        contentCell.updateCell(withContent: msg.content, withImage: msg.image?.previewURL)
        
        let footerCell = DetailFooterCell(realName: msg.realName)
        
        dataArray = [headerCell, contentCell, footerCell]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
}

// MARK: - TableView Delegate

extension DetailsViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let msg = msg else {
            return 0
        }
        
        switch indexPath.row {
        case 0:
            return 200
        case 1:
            let font = msg.image == nil ? DetailCellStyle.ContentFontWithoutImage : DetailCellStyle.ContentFontWithImage
            let contentWidth = view.bounds.width - DetailCellStyle.ContentInsets.left - DetailCellStyle.ContentInsets.right
            let contentHeight = msg.content.height(forFont: font, forWidth: contentWidth)
            return DetailCellStyle.ContentInsets.top + contentHeight + DetailCellStyle.ContentVerticalMargin + (msg.image == nil ? 0 : DetailCellStyle.ImageHeight)
        case 2:
            let contentWidth = view.bounds.width - DetailCellStyle.ContentInsets.left - DetailCellStyle.ContentInsets.right
            return msg.realName.height(forFont: DetailCellStyle.ScreenNameFont, forWidth: contentWidth)
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return dataArray[indexPath.row]
    }
}

// MARK: - 

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
        dismiss(animated: true, completion: nil)
    }
    
    @objc func pressedShareButton() {
        
    }
}

