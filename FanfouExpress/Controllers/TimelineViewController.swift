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

class TimelineViewController: UITableViewController {
    
    var digest: Digest?
    var today: String {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter.string(from: Date())
        }
    }
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configNavigationBar()
        
        view.backgroundColor = UIColor.clear
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 150
        tableView.backgroundColor = UIColor.white
        tableView.showsVerticalScrollIndicator = false
        tableView.register(TimelineTableViewCell.self)
        
        fetchDigest({
            self.tableView.reloadData()
        })
    }
}

// MARK: - TableView

extension TimelineViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return digest?.msgs.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let msgs = digest?.msgs else {
            print("Failed to retrieve msgs in \(digest?.description ?? "nil digest")")
            return 0
        }
        
        let msg = msgs[indexPath.row]
        let width = view.bounds.width - CellStyle.ContentInsets.left - CellStyle.ContentInsets.right

        return TimelineTableViewCell.height(forMessage: msg, forWidth: width)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let msgs = digest?.msgs else {
            print("Failed to retrieve msgs in \(digest?.description ?? "nil digest")")
            return UITableViewCell()
        }
        
        let msg = msgs[indexPath.row]
        let cell: TimelineTableViewCell = tableView.dequeue(indexPath: indexPath)
        cell.updateCell(msg)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
    
    func configNavigationBar() {
        title = "每日精选"
        
        navigationController?.navigationBar.titleTextAttributes = [
            NSFontAttributeName : NavigationBarAppearance.TitleFont,
        ]
        
        navigationController?.hidesBarsOnSwipe = true
        navigationController?.navigationBar.isTranslucent = false
    }
    
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
}
