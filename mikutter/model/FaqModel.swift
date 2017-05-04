//
//  FaqModel.swift
//  mikutter
//
//  Created by ahiru on 2017/05/03.
//  Copyright © 2017年 mikutter. All rights reserved.
//

import Foundation

// FAQ Model
struct faqModel {
    var id :String
    var question :String
    var answer :String
    
    init() {
        self.id = ""
        self.question = ""
        self.answer = ""
    }
    
    init(id: String, question: String, answer: String) {
        self.id = id
        self.question = question
        self.answer = answer
    }
    
    mutating func set(id: String, question: String, answer: String) {
        self.id = id
        self.question = question
        self.answer = answer
    }
    
    func get() -> faqModel {
        return self
    }
}

// Callback
protocol FaqTaskDelegate {
    func faqComplete(result: Array<faqModel>)
    func faqError(error: Error)
}

// Class to Get FAQ
final class FaqModel: NSObject {
    
    private let faqUrl = "https://mikutter.hachune.net/faq.json"
    
    var delegate: FaqTaskDelegate?
    
    // FAQ を取得する
    func get() {
        var result :Array<faqModel> = Array<faqModel>()
        if let url = URL(string: faqUrl) {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if error != nil{
                    print(error?.localizedDescription ?? "Unknown Error Occurred")
                    self.delegate?.faqError(error: error!)
                    return
                }
                
                do {
                    guard let json: Array =  try JSONSerialization.jsonObject(with: data!, options: []) as? [[String: String]] else {
                        let error: Error = "Failed to parse Json" as! Error
                        self.delegate?.faqError(error: error)
                        return
                    }
                    json.forEach() { faq in
                        var model = faqModel.init()
                        model.set(id: faq["id"] ?? "", question: faq["question"] ?? "", answer: faq["answer"] ?? "")
                        result.append(model)
                    }
                    self.delegate?.faqComplete(result: result)
                } catch {
                    print ("json error")
                }
            })
            task.resume()
        }
    }
}
