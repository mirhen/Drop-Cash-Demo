//
//  StripeAccount.swift
//  Test Connect
//
//  Created by Miriam Haart on 6/27/18.
//  Copyright © 2018 Miriam Haart. All rights reserved.
//

import Foundation

struct StripeAccount {
    var id: String = ""
    var pubKey: String = ""
    var privKey: String = ""
    
    var dictValue: [String : String] {
        return ["stripe_account_id" : id,
                "public_key" : pubKey,
                "private_key": privKey ]
    }
    
    init(id: String, pubKey: String, privKey: String) {
        self.id = id
        self.pubKey = pubKey
        self.privKey = privKey
    }
    
    init?(dict: [String: String]) {
        
        guard let id = dict["stripe_account_id"],
        let pubKey = dict["public_key"],
        let privKey = dict["private_key"] else {
            return
        }
        
        self.id = id
        self.pubKey = pubKey
        self.privKey = privKey
    
        
    }
    
}
