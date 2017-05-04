//
//  ViewController.swift
//  mikutter
//
//  Created by ahiru on 2017/05/03.
//  Copyright © 2017年 mikutter. All rights reserved.
//

import UIKit

class FaqTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableView = UITableView()
    let footerSize: CGFloat = 40
    
    var faqList = Array<faqModel>()
    var faq = faqModel()
    var notification = notificationModel()
    
    override func viewWillAppear(_ animated: Bool) {
        let faq = FaqModel.init()
        faq.delegate = self as FaqTaskDelegate
        faq.get()
        
        let notification = NotificationModel.init()
        notification.delegate = self as NotificationTaskDelegate
        notification.get()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "mikutter"
        
        let width = self.view.frame.width
        let height = self.view.frame.height
        tableView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(tableView)
    }
    
    
    // --- UITableViewDataSource --- //
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "question")
        cell.textLabel?.text = faqList[indexPath.row].question
        cell.textLabel?.font = UIFont.Base
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // セルの数を設定
        return faqList.count
    }
    
    
    // --- UITableViewDelegate --- //
    
    // セルがタップされた時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        faq = faqList[indexPath.row]
        let faqDetailViewController = FaqDetailViewController()
        faqDetailViewController.faq = faq
        self.navigationController?.pushViewController(faqDetailViewController, animated: false)
    }
    
    // セルの高さを設定
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }
    
    // フッターの設定
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        // Add Button to Footer
        let screenSize = UIScreen.main.bounds
        let width = screenSize.width
        
        let footerButton: UIButton = UIButton(type: .roundedRect)
        let title = self.notification.text
        footerButton.frame = CGRect(x: 0, y: 0, width: width, height: footerSize)
        footerButton.setTitle(title, for: .normal)
        footerButton.backgroundColor = .white
        footerButton.contentHorizontalAlignment = .left
        footerButton.contentEdgeInsets = UIEdgeInsetsMake(0, CGFloat(10), CGFloat(0), 0)
        footerButton.addTarget(self, action: #selector(self.openLink(_:)), for: .touchUpInside)
        
        return footerButton
    }
    
    // フッターの高さ
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return footerSize
    }
    
    // リンクを開く
    func openLink(_ sender: AnyObject) {
        let url: URL = URL.init(string: self.notification.url)!
        UIApplication.shared.open(url)
    }
}

extension FaqTableViewController: FaqTaskDelegate, NotificationTaskDelegate {
    // FAQ
    func faqComplete(result: Array<faqModel>) {
        DispatchQueue.main.async(execute: { _ in
            self.faqList = result
            self.tableView.reloadData()
        })
    }
    
    func faqError(error: Error) {
        print("Error: \(error.localizedDescription)")
    }
    
    // Notification
    func ntComplete(result: Array<notificationModel>) {
        DispatchQueue.main.async(execute: { _ in
            self.notification = result.first!
            self.tableView.reloadData()
        })
    }
    
    func ntError(error: Error) {
        print("error: \(error.localizedDescription)")
    }
}
