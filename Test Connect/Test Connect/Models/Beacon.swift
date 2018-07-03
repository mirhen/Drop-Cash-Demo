//
//  Beacon.swift
//  Safe Beacon
//
//  Created by Miriam Haart on 3/17/18.
//  Copyright © 2018 Miriam Haart. All rights reserved.
//

import Foundation
import FirebaseAuth.FIRUser
import FirebaseDatabase

class Beacon {
    let title: String
    let id: String
    var uid: String

    init(title: String, id: String, uid: String) {
        self.title = title
        self.id = id
        self.uid = uid
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let uid = dict["uid"] as? String,
            let title = dict["title"] as? String
            else { return nil }
        
        self.id = snapshot.key
        self.uid = uid
        self.title = title
    
    }
}
