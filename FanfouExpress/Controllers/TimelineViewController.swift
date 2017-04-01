//
//  TimelineViewController.swift
//  FanfouExpress
//
//  Created by Cencen Zheng on 3/25/17.
//  Copyright © 2017 Cencen Zheng. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class TimelineViewController: UIViewController {
    
    var digest: Digest?
    var today: String {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter.string(from: Date())
        }
    }
    
    private var tableView: UITableView
    private var navigationBar: TimelineNavigationbar
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        tableView = UITableView(frame: .zero, style: .plain)
        navigationBar = TimelineNavigationbar()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 150
        tableView.backgroundColor = UIColor.white
        tableView.showsVerticalScrollIndicator = false
        tableView.register(TimelineTableViewCell.self)
        
        let offsetY = UIDevice.navigationBarHeight() - UIDevice.statusBarHeight()
        tableView.contentOffset = CGPoint(x: 0, y: -offsetY)
        tableView.contentInset  = UIEdgeInsetsMake(offsetY, 0, 0, 0)
        
        navigationBar.title = "每日精选"
        
        view.addSubview(tableView)
        view.addSubview(navigationBar)
        
        fetchDigest({
            self.tableView.reloadData()
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        navigationBar.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: view.bounds.width, height: UIDevice.navigationBarHeight()))
        tableView.frame = view.bounds
    }
}

// MARK: - TableView

extension TimelineViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return digest?.msgs.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let msgs = digest?.msgs else {
            print("Failed to retrieve msgs in \(digest?.description ?? "nil digest")")
            return 0
        }
        
        let msg = msgs[indexPath.row]
        return height(forMessage: msg)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let msgs = digest?.msgs else {
            print("Failed to retrieve msgs in \(digest?.description ?? "nil digest")")
            return UITableViewCell()
        }
        
        let msg = msgs[indexPath.row]
        let cell: TimelineTableViewCell = tableView.dequeue(indexPath: indexPath)
        cell.updateContentWith(msg)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let msgs = digest?.msgs else {
            print("Failed to retrieve msgs in \(digest?.description ?? "nil digest")")
            return
        }
        let msg = msgs[indexPath.row]
        
        let detailsViewController = DetailsViewController(style: .plain)
        detailsViewController.msg = msg
        let navigationController = UINavigationController(rootViewController: detailsViewController)
        present(navigationController, animated: true, completion: nil)
    }
}

private extension TimelineViewController {
    
    func fetchDigest(_ completionHandler: @escaping () -> Void) {
        let router = Router.fetchDailyDigests(date: today)
        Alamofire.request(router).validate().responseJSON { (response) in
            switch response.result {
            case .success:
                guard let json = response.value as? JSON else { return }
                if let digest = Digest(json: json) {
                    self.digest = digest
                    completionHandler()
                }
            case .failure:
                print("reponse error")
            }
        }
    }
    
    func height(forMessage msg: Message) -> CGFloat {
        guard let attributedContent = NSAttributedString(htmlData: msg.content.data(using: .utf8), options: CellStyle.ContentAttributes, documentAttributes: nil) else {
            print("Failed to convert \(msg.content) to attributed string with \(CellStyle.ContentAttributes)")
            return 0
        }
        
        let width = view.bounds.width - CellStyle.ContentInsets.left - CellStyle.ContentInsets.right
        let screenNameHeight = msg.realName.height(forFont: CellStyle.ScreenNameFont, forWidth: width)
        let imageHeight = (msg.image == nil) ? 0 : CellStyle.ImageHeight + CellStyle.PreviewVerticalMargin

        let contentHeight = attributedContent.height(forOrigin: CGPoint(x: CellStyle.ContentInsets.left, y: CellStyle.ContentInsets.top),
                                                     forWidth: width)
        
        return CellStyle.ContentInsets.top
            + contentHeight + CellStyle.ContentVerticalMargin
            + screenNameHeight
            + imageHeight
            + CellStyle.ContentInsets.bottom
    }
}
