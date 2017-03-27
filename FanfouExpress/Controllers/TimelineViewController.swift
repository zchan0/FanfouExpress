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
    private var tableView: UITableView
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        tableView = UITableView(frame: .zero, style: .plain)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
        tableView.register(TimelineTableViewCell.self)
        tableView.estimatedRowHeight = 150
        view.addSubview(tableView)
        
        title = "每日精选"
        
        fetchDigest({
            self.tableView.reloadData()
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
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
            print("Failed to retrieve msgs in \(digest)")
            return 0
        }
        
        let msg = msgs[indexPath.row]
        return height(forMessage: msg)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let msgs = digest?.msgs else {
            print("Failed to retrieve msgs in \(digest)")
            return UITableViewCell()
        }
        
        let msg = msgs[indexPath.row]
        let cell: TimelineTableViewCell = tableView.dequeue(indexPath: indexPath)
        cell.updateContentWith(msg)
        
        return cell
    }
}

private extension TimelineViewController {
    
    func fetchDigest(_ completionHandler: @escaping () -> Void) {
        let router = Router.fetchDailyDigests(date: "2016-11-13")
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
        let width = view.bounds.width - CellStyle.ContentInsets.left - CellStyle.ContentInsets.right
        let contentHeight = msg.content.height(forFont: CellStyle.ContentFont, forWidth: width)
        let screenNameHeight = msg.realName.height(forFont: CellStyle.ScreenNameFont, forWidth: width)
        
        return CellStyle.ContentInsets.top
            + contentHeight + CellStyle.ContentVerticalMargin
            + screenNameHeight 
            + (msg.image == nil ? 0 : CellStyle.ImageHeight + CellStyle.PreviewVerticalMargin)
            + CellStyle.ContentInsets.bottom
    }
}
