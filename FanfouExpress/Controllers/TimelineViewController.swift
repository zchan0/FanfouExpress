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

class TimelineViewController: UITableViewController, PhotoBrowserTransitionSupport {
    
    var digest: Digest?
    var transitionImage: UIImage
    var transitionImageView: UIImageView
    
    var today: String {
        return DateUtils.dateFormatter.string(from: Date())
    }
    var lastDay: String {
        return "2018-02-11"
    }
    
    fileprivate let emptyView: EmptyView
    
    override init(style: UITableViewStyle) {
        self.emptyView = EmptyView()
        self.transitionImage = UIImage()
        self.transitionImageView = UIImageView()
        super.init(style: style)
        
        self.emptyView.refreshBlock = {
            self.reloadData()
        }
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navigation bar
        title = "今日精选"
        navigationController?.hidesBarsOnSwipe = true
        
        // tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 150
        tableView.backgroundColor = UIColor.white
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = false
        tableView.register(TimelineTableViewCell.self)
        
        view.backgroundColor = .white
        
        loadRemoteData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        emptyView.frame = view.bounds
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            showRandomDigest()
        }
    }
}

// MARK: - TableView delegate

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
        if let url = msg.image?.previewURL {
            cell.tapPreviewImageBlock = { (tappedImageView) in
                self.transitionImageView = tappedImageView
                self.transitionImage = tappedImageView.image ?? UIImage.imageWithColor(color: .lightGray)
                
                let photoController = PhotoBrowserController(withURL: url, TLCell.PlaceholderImage)
                photoController.modalPresentationStyle = .custom
                photoController.transitioningDelegate = self
                photoController.modalPresentationCapturesStatusBarAppearance = true
                self.present(photoController, animated: true, completion: nil)
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let msgs = digest?.msgs else {
            print("Failed to retrieve msgs in \(digest?.description ?? "nil digest")")
            return
        }
        
        let msg = msgs[indexPath.row]
        let detailsViewController = DetailsViewController(style: .plain)
        let navigationViewController = FFENavigationController(rootViewController: detailsViewController)
        detailsViewController.msg = msg
        navigationViewController.transitioningDelegate = self
        navigationViewController.modalPresentationStyle = .custom
        navigationViewController.modalPresentationCapturesStatusBarAppearance = true
        present(navigationViewController, animated: true, completion: nil)
    }
}

// MARK: - Transition delegate

extension TimelineViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch presented.self {
        case is PhotoBrowserController:
            return PhotoBrowserAnimator()
        case is FFENavigationController:
            guard presented.unwrapNavigationControllerIfNeeded() is DetailsViewController else { return nil }
            navigationController?.setNavigationBarHidden(false, animated: false)
            let animator = TimelineAnimator()
            animator.presenting = true
            return animator
        default:
            return nil
        }
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch dismissed.self {
        case is PhotoBrowserController:
            return PhotoBrowserAnimator()
        case is FFENavigationController:
            guard dismissed.unwrapNavigationControllerIfNeeded() is DetailsViewController else { return nil }
            let animator = TimelineAnimator()
            animator.presenting = false
            return animator
        default:
            return nil
        }
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        if presented.unwrapNavigationControllerIfNeeded() is DetailsViewController {
            return TimelinePresentationController(presentedViewController: presented, presenting: presenting)
        }
        return nil
    }
}

// MARK: - Private methods

private extension TimelineViewController {
    
    func showRandomDigest() {
        guard let startDate  = DateUtils.dateFormatter.date(from: Constants.StartDate) else { return }
        guard let lastDate = DateUtils.dateFormatter.date(from: lastDay) else { return }
        guard let randomDate = DateUtils.shared.randomDay(startDate, lastDate) else { return }
        
        let randomDateString = DateUtils.dateFormatter.string(from: randomDate)
        fetchDigest(randomDateString, { [weak self, randomDate] in
            guard let `self` = self else { return }
            self.title = DateUtils.chineseDateFormatter.string(from: randomDate)
            self.tableView.reloadData()
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            self.navigationController?.setNavigationBarHidden(false, animated: false)
        })
    }
    
    func loadRemoteData() {
//        fetchDigest(lastDay, {
//            self.tableView.reloadData()
//        })
        showRandomDigest()
    }
    
    func reloadData() {
        loadRemoteData()
    }
    
    func fetchDigest(_ date: String, _ completionHandler: @escaping () -> Void) {
        let router = Router.fetchDailyDigests(date: date)
        
        startLoading()
        Alamofire.request(router).validate().responseJSON { (response) in
            self.stopLoading()
            switch response.result {
            case .success:
                guard let json = response.value as? JSON else { return }
                if let digest = Digest(json: json) {
                    if digest.msgs.isEmpty {
                        self.emptyView.style = .defaultStyle
                        if self.emptyView.superview == nil {
                            self.view.addSubview(self.emptyView)
                        }
                    } else {
                        if self.emptyView.superview != nil {
                            self.emptyView.removeFromSuperview()
                        }
                        self.digest = digest
                        completionHandler()
                    }
                }
            case .failure:
                self.showErrorMsg(withStatus: "加载失败")
                self.emptyView.style = .errorStyle
                if self.emptyView.superview == nil {
                    self.view.addSubview(self.emptyView)
                }
            }
        }
    }
}
