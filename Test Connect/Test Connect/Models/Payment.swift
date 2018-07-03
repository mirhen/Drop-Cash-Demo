//
//  Payment.swift
//  Test Connect
//
//  Created by Miriam Haart on 6/28/18.
//  Copyright © 2018 Miriam Haart. All rights reserved.
//

import Foundation
import Firebase

class Payment {
    
    var sender: String = ""
    var receiver: String = ""
    var amount: Int = 0
    var description: String?
    var date: Date = Date()
    
    var dictValue: [String : Any] {
        let createdAgo = date.timeIntervalSince1970
        
        guard let description = description
        else {
            return ["sender" : sender,
                    "receiver": receiver,
                    "amount" : amount,
                    "date": createdAgo]
        }
        return ["sender" : sender,
                "receiver": receiver,
                "amount" : amount,
                "description": description,
                "date": createdAgo  ]
    }
    
    init(sender: String, receiver: String, amount: Int, date: Date) {
        self.sender = sender
        self.receiver = receiver
        self.amount = amount
        self.date = date
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let sender = dict["sender"] as? String,
            let receiver = dict["receiver"] as? String,
            let amount = dict["amount"] as? Int,
            let date = dict["date"] as? Double
            else { return nil }
        
        if let description = dict["description"] as? String {
            self.description = description
        }
        
        self.sender = sender
        self.receiver = receiver
        self.amount = amount
        self.date = Date(timeIntervalSince1970: date)
        
        
        
    }
    
    init?(dict: [String: Any]) {
        
        guard let sender = dict["sender"] as? String,
            let receiver = dict["receiver"] as? String,
            let amount = dict["amount"] as? Int,
            let date = dict["date"] as? Double
        else {
            return
        }
        
        self.sender = sender
        self.receiver = receiver
        self.amount = amount
        self.date = Date(timeIntervalSince1970: date)
        
        if let description = dict["description"] as? String {
            self.description = description
        }
        
    }
    
    func getDefaultDescription() -> String {
        if User.current.username == receiver {
            return "\(sender) sent $\(amount) to you"
        }
        return "You sent $\(amount) to \(receiver)"
    }
    
}
