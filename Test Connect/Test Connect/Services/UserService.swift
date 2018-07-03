//
//  UserService.swift
//  Journal
//
//  Created by Miriam Haart on 3/1/18.
//  Copyright © 2018 Miriam Haart. All rights reserved.
//

import Foundation
import FirebaseAuth.FIRUser
import FirebaseDatabase
import Alamofire

struct UserService {
    
    static func create(_ firUser: FIRUser, completion: @escaping (User?) -> Void) {
        let userAttrs = ["username": firUser.displayName!] as [String : Any]
        
        let ref = Database.database().reference().child("users").child(firUser.uid)
        ref.setValue(userAttrs) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let user = User(snapshot: snapshot)
                completion(user)
            })
        }
    }
    
    static func addStripeAccountTo(_ user: User, stripeAccount: StripeAccount, completion: @escaping (User?) -> Void) {
        let userAttrs = ["stripe_account": stripeAccount.dictValue] as [String : Any]
        
        let ref = Database.database().reference().child("users").child(user.uid)
        ref.updateChildValues(userAttrs)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            let user = User(snapshot: snapshot)
            completion(user)
        })
        
    }
    static func setBeaconId(_ user: User, bId: String, completion: @escaping (User?) -> Void) {
        let userAttrs = ["bId": bId]
        
        let ref = Database.database().reference().child("users").child(user.uid)
        ref.updateChildValues(userAttrs) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let user = User(snapshot: snapshot)
                completion(user)
            })
        }
    }
    
    static func addAttributeFor(_ user: User, key: String, value: String) {
        let ref = Database.database().reference().child("users").child(user.uid)
        ref.updateChildValues([key: value])
    }
    
    static func show(forUID uid: String, completion: @escaping (User?) -> Void) {
        let ref = Database.database().reference().child("users").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let user = User(snapshot: snapshot) else {
                return completion(nil)
            }
            
            completion(user)
        })
    }
    
    static func payments(completion: @escaping ([Payment]) -> Void) {
        let ref = Database.database().reference().child("users").child(User.current.uid).child("payments")
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return completion([])
            }
            
            let payments = snapshot.reversed().compactMap(Payment.init)
            
            print(payments)
            completion(payments)
        })
        
    }
    
    static func sendPaymentTo(_ user: User, payment: Payment) {
        var ref = Database.database().reference().child("users").child(user.uid).child("payments")
        let key = ref.childByAutoId()
        
        ref.child(key.key).setValue(payment.dictValue)
        
        ref = Database.database().reference().child("users").child(User.current.uid).child("payments")
        
        ref.child(key.key).setValue(payment.dictValue)
       
    }
    
    static func users(completion: @escaping ([User]) -> Void) {
        let ref = Database.database().reference().child("users")
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return completion([])
            }
            
            let users = snapshot.reversed().compactMap(User.init)
            print(users)
            completion(users)
        })
    }
    
    

}



