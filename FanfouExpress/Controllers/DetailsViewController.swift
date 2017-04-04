//
//  DetailsViewController.swift
//  FanfouExpress
//
//  Created by Cencen Zheng on 3/30/17.
//  Copyright © 2017 Cencen Zheng. All rights reserved.
//

import UIKit
import DTCoreText
import SafariServices

class DetailsViewController: UITableViewController {
    
    enum RowType: Int {
        case header  = 0
        case content
        case unknown
    }
    
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
        
        loadData()
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
        return dataArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let msg = msg else {
            return 0
        }
        
        switch indexPath.row {
        case RowType.header.rawValue:
            return DetailHeaderCell.height(forWidth: view.bounds.width)
        case RowType.content.rawValue:
            let width = view.bounds.width - DetailCellStyle.ContentInsets.left - DetailCellStyle.ContentInsets.right
            return TimelineTableViewCell.height(forMessage: msg, forWidth: width, forContentInsets: DetailCellStyle.ContentInsets)
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return dataArray[indexPath.row]
    }
}

// MARK: - DTAttributedTextContentViewDelegate

extension DetailsViewController: DTAttributedTextContentViewDelegate {
    
    func attributedTextContentView(_ attributedTextContentView: DTAttributedTextContentView!, viewForLink url: URL!, identifier: String!, frame: CGRect) -> UIView! {
        let linkButton = DTLinkButton(frame: frame)
        linkButton.url = url
        linkButton.addTarget(self, action: #selector(pressedLinkButton), for: .touchUpInside)
        return linkButton
    }
}

// MARK: - SFSafariViewControllerDelegate

extension DetailsViewController: SFSafariViewControllerDelegate {
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Private methods

private extension DetailsViewController {
    
    func loadData() {
        guard let msg = msg else {
            return
        }
        
        let headerCell = DetailHeaderCell(style: .default, reuseIdentifier: nil)
        headerCell.updateCell(withAvatar: msg.avatarURL)
        
        let contentCell = TimelineTableViewCell(style: .default, reuseIdentifier: nil)
        contentCell.textDelegate = self
        contentCell.contentInsets = DetailCellStyle.ContentInsets
        contentCell.updateCell(msg)
        
        dataArray = [headerCell, contentCell]
    }
    
    func configNavigationBar() {
        navigationController?.hidesBarsOnSwipe = true
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

    // MARK: -
    
    @objc func pressDoneButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func pressedShareButton() {
        guard let msg = msg else { return }
        guard let contentCell = dataArray[RowType.content.rawValue] as? TimelineTableViewCell else { return }
        
        var activityItems:[Any] = [contentCell.parsedContent]
        
        if let statusURL = msg.statusURL {
            activityItems.append(statusURL)
        }
        if  let image = contentCell.previewImage {
            activityItems.append(image)
        }
        
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        controller.completionWithItemsHandler = { (activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, activityError: Error?) in
            if completed {
                print("[UIActivityViewController]: Succeed")
            } else {
                print(activityError?.localizedDescription ?? "[UIActivityViewController]: Failed")
            }
        }
        present(controller, animated: true, completion: nil)
    }
    
    @objc func pressedLinkButton(sender: DTLinkButton) {
        guard let url = sender.url else { return }        
        
        if url.scheme == Constants.HTTPScheme || url.scheme == Constants.HTTPSScheme {
            let safariController = SFSafariViewController(url: url)
            safariController.delegate = self
            safariController.preferredControlTintColor = FFEColor.AccentColor
            present(safariController, animated: true, completion: nil)
        }
    }
}

