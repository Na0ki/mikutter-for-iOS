//
//  AnswerViewController.swift
//  mikutter
//
//  Created by ahiru on 2017/05/03.
//  Copyright © 2017年 mikutter. All rights reserved.
//

import UIKit

class FaqDetailViewController: UIViewController, UIScrollViewDelegate {
    
    var faq: faqModel!
    let contentView: UIView = UIView()
    let margin: CGFloat = 20
    
    let qLabel: UILabel = UILabel()
    let aLabel: UILabel = UILabel()
    
    let scrollView = UIScrollView(frame: UIScreen.main.bounds)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = self.scrollView
        self.scrollView.center = self.view.center
        self.scrollView.delegate = self
        
        let width =  self.view.frame.width
        
        self.title = "mikutter"
                
        self.view.backgroundColor = .white
        
        self.qLabel.text = faq.question
        self.qLabel.font = UIFont.Title
        self.qLabel.textColor = .black
        self.qLabel.lineBreakMode = .byWordWrapping
        self.qLabel.numberOfLines = 0
        self.qLabel.frame.size.width = width * 0.9
        self.qLabel.frame.origin.x = (width * 0.1) / 2
        self.qLabel.frame.origin.y = margin
        self.qLabel.sizeToFit()
        
        let frame = qLabel.frame
        
        self.aLabel.text = faq.answer
        self.aLabel.font = UIFont.Base
        self.aLabel.textColor = .black
        self.aLabel.lineBreakMode = .byWordWrapping
        self.aLabel.numberOfLines = 0
        self.aLabel.frame.size.width = width * 0.9
        self.aLabel.frame.origin.x = (width * 0.1) / 2
        self.aLabel.frame.origin.y =
            frame.origin.y +
            margin +
            frame.size.height
        self.aLabel.sizeToFit()
        
        let scrollHeight = (3 * margin) + self.qLabel.frame.height + self.aLabel.frame.height
        self.scrollView.contentSize = CGSize(width: width, height: scrollHeight)
        
        self.view.addSubview(qLabel)
        self.view.addSubview(aLabel)
    }
}
