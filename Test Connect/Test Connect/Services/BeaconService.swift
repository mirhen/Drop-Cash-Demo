//
//  BeaconService.swift
//  Safe Beacon
//
//  Created by Miriam Haart on 3/17/18.
//  Copyright © 2018 Miriam Haart. All rights reserved.
//

import Foundation
import EstimoteProximitySDK
import FirebaseAuth.FIRUser
import FirebaseDatabase

class BeaconService {
    
    
    static let estimoteCloudCredentials = EPXCloudCredentials(appID: Constants.EstimoteCloud.appID, appToken: Constants.EstimoteCloud.appToken)
    
    static let proximityObserver = EPXProximityObserver(credentials: BeaconService.estimoteCloudCredentials, errorBlock: { error in
        print("EPXProximityObserver error: \(error)")
    })
    
    static func create(_ uid: String, beacon: Beacon) {
        let beaconAttrs = ["uid": uid, "title": beacon.title]
        
        let ref = Database.database().reference().child("beacons").child(beacon.id)
        ref.setValue(beaconAttrs) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return 
            }
            print("beacon registered")
            
        }
    }
    static func show(forBeaconID id: String, completion: @escaping (Beacon?) -> Void) {
        let ref = Database.database().reference().child("beacons").child(id)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let beacon = Beacon(snapshot: snapshot) else {
                return completion(nil)
            }
            completion(beacon)
        })
    }
    
    static func observeNearbyBeacons(completion: @escaping (Beacon?) -> Void) {
        
        let zone = EPXProximityZone(range: .near, attachmentKey: "miriamhaart-gmail-com-s-pr-dyg", attachmentValue: "example-proximity-zone")
        
        zone.onChangeAction = { attachments in
            
            for attachment in attachments {
                
                let title = attachment.payload["miriamhaart-gmail-com-s-pr-dyg/title"] as! String
                let bId = attachment.deviceIdentifier
                if bId == User.current.bId {
                    let beacon = Beacon(title: title, id: bId, uid: User.current.uid)
                    completion(beacon)
                }
            }
            completion(nil)
        }
        
        BeaconService.proximityObserver.startObserving([zone])
    }
    

    
    static func observeBeaconMotion(_ beacon: Beacon) {
        
        let deviceManager = ESTDeviceManager()
        
        let tempNotification = ESTTelemetryNotificationTemperature { (tempInfo) in
            print("beacon ID: \(tempInfo.shortIdentifier), "
                + "temperature: \(tempInfo.temperatureInCelsius) °C")
        }
        deviceManager.register(forTelemetryNotification: tempNotification)
        
    }

    
}
