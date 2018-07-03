//
//  User.swift
//  Journal
//
//  Created by Miriam Haart on 3/1/18.
//  Copyright © 2018 Miriam Haart. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot

class User: NSObject {
    
    // MARK: - Properties
    
    let uid: String
    let username: String
    var bId: String = "nil"
    var stripeAccount: StripeAccount?
    var balance: Int = 0
    
    
    // MARK: - Init
    
    init(uid: String, username: String) {
        self.uid = uid
        self.username = username
        super.init()
    }
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
              let username = dict["username"] as? String
            else { return nil }
        if let bId = dict["bId"] as? String {
           self.bId = bId
        }
        if let stripeAccount = dict["stripe_account"] as? [String: String] {
            self.stripeAccount = StripeAccount(dict: stripeAccount)
        }
        self.uid = snapshot.key
        self.username = username
        
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        guard let uid = aDecoder.decodeObject(forKey: Constants.UserDefaults.uid) as? String,
            let username = aDecoder.decodeObject(forKey: Constants.UserDefaults.username) as? String
            else { return nil }

        if let bId = aDecoder.decodeObject(forKey: Constants.UserDefaults.bId) as? String {
            self.bId = bId
        }
        if let stripeAccount = aDecoder.decodeObject(forKey: Constants.UserDefaults.stripeAccount) as? [String: String] {
            self.stripeAccount = StripeAccount(dict: stripeAccount)
        }
        self.uid = uid
        self.username = username
        
        super.init()
    }
    
    //Helper Functions
    
    func isNearby(_ beacons: [Beacon]) -> Bool {
        let bIds = beacons.map { return $0.id }
        if bIds.contains(self.bId) {
            return true
        }
        return false
    }
    
    // MARK: - Singleton
    
    // 1
    private static var _current: User?
    
    // 2
    static var current: User {
        // 3
        guard let currentUser = _current else {
            fatalError("Error: current user doesn't exist")
        }
        
        // 4
        return currentUser
    }
    
    // MARK: - Class Methods
    
    // 5
    class func setCurrent(_ user: User, writeToUserDefaults: Bool = false) {
        // 2
        if writeToUserDefaults {
            // 3
            let data = NSKeyedArchiver.archivedData(withRootObject: user)
            
            // 4
            UserDefaults.standard.set(data, forKey: Constants.UserDefaults.currentUser)
        }
        
        _current = user
    }
}
extension User: NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(uid, forKey: Constants.UserDefaults.uid)
        aCoder.encode(username, forKey: Constants.UserDefaults.username)
        aCoder.encode(bId, forKey: Constants.UserDefaults.bId)
        
        if let stripeAccount = stripeAccount {
            aCoder.encode(stripeAccount.dictValue, forKey: Constants.UserDefaults.stripeAccount)
        }
    }
}
