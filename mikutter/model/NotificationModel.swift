//
//  NotificationModel.swift
//  mikutter
//
//  Created by ahiru on 2017/05/03.
//  Copyright © 2017年 mikutter. All rights reserved.
//

import Foundation

// Notification Model
struct notificationModel {
    var text :String
    var url :String
    var expire :Date
    
    init() {
        self.text = ""
        self.url = ""
        self.expire = Date()
    }
    
    init(text: String, url: String, expire: Date) {
        self.text = text
        self.url = url
        self.expire = expire
    }
    
    init(text: String, url: String, expire: String) {
        self.init(text: text, url: url, expire: Date.init(fromISO8601: expire)!)
    }
    
    mutating func set(text: String, url: String, expire: Date) {
        self.text = text
        self.url = url
        self.expire = expire
    }
    
    func get() -> notificationModel {
        return self
    }
}

enum APIError: Error {
    case Network(String)
    case JSONParse(String)
}

// Callback
protocol NotificationTaskDelegate {
    func ntComplete(result: Array<notificationModel>)
    func ntError(error: Error)
}

// Class to Get Notification
final class NotificationModel: NSObject {
    
    private let notificationUrl = "https://mikutter.hachune.net/notification.json?platform=ios"
    
    var delegate: NotificationTaskDelegate?
    
    // FAQ を取得する
    func get() {
        var result :Array<notificationModel> = Array<notificationModel>()
        if let url = URL(string: notificationUrl) {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if error != nil{
                    self.delegate?.ntError(error: APIError.Network((error?.localizedDescription)!))
                    return
                }
                
                do {
                    guard let json: Array =  try JSONSerialization.jsonObject(with: data!, options: []) as? [NSObject] else {
                        self.delegate?.ntError(error: APIError.JSONParse("なんかうまくいかんかった"))
                        return
                    }
                    json.forEach() { events in
                        let text: String = events.value(forKey: "text") as? String ?? ""
                        let url: String = events.value(forKey: "url") as? String ?? ""
                        let expire = Date.init(fromISO8601: events.value(forKey: "expire") as! String) ?? Date()
                        var model = notificationModel.init()
                        model.set(text: text, url: url, expire: expire)
                        result.append(model)
                    }
                    self.delegate?.ntComplete(result: result)
                } catch {
                    self.delegate?.ntError(error: APIError.JSONParse("なんかうまくいかんかった"))
                }
            })
            task.resume()
        }
    }
}

extension Date {
    init?(fromISO8601 string: String) {
        if #available(iOS 10.0, *) {
            let formatter = ISO8601DateFormatter.init()
            guard let date = formatter.date(from: string) else {
                return nil
            }
            self = date
        } else {
            // Fallback on earlier versions
            let formatter = DateFormatter.init()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
            formatter.timeZone = TimeZone.current
            guard let date = formatter.date(from: string) else {
                return nil
            }
            self = date
        }
    }
}
