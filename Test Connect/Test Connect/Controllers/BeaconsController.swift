//
//  BeaconsController.swift
//  Speed Beacon
//
//  Created by Miriam Haart on 3/18/18.
//  Copyright © 2018 Miriam Haart. All rights reserved.
//

import UIKit
import EstimoteProximitySDK

class BeaconsController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var proximityObserver: EPXProximityObserver!
    var nearbyBeacons = [Beacon]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    var unregisteredBeacons = [Beacon]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        observeNearbyBeacons()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func observeNearbyBeacons() {
        let estimoteCloudCredentials = EPXCloudCredentials(appID: Constants.EstimoteCloud.appID, appToken: Constants.EstimoteCloud.appToken)
        
        proximityObserver = EPXProximityObserver(credentials: estimoteCloudCredentials, errorBlock: { error in
            print("EPXProximityObserver error: \(error)")
        })
        
        let zone = EPXProximityZone(range: EPXProximityRange.custom(desiredMeanTriggerDistance: 3.0)!,
                                    attachmentKey: "miriamhaart-gmail-com-s-pr-dyg", attachmentValue: "example-proximity-zone")
        zone.onChangeAction = { attachments in
            print(attachments)
            self.nearbyBeacons = attachments.map { attachment in
            
                let title = (attachment.payload["miriamhaart-gmail-com-s-pr-dyg/title"] as? String) ?? "unknown"
                let id = attachment.deviceIdentifier
                
                let beacon = Beacon(title: title, id: id, uid: "")
                
                BeaconService.show(forBeaconID: id, completion: { (b) in
                    if let beac = b {
                        beacon.uid = beac.uid
                        print(beac.uid)
                    }
                    else {
                        print("unregistered")
                    }
                })
                
                return beacon
            }
            self.tableView.reloadData()
        }
        proximityObserver.startObserving([zone])
    }
    
    
    
}

extension BeaconsController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nearbyBeacons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BeaconCell", for: indexPath) as! BeaconCell
        
        
        let beacon = nearbyBeacons[indexPath.row]
        
        cell.beaconLabel.text = beacon.title
        cell.backgroundColor = Utils.color(forColorName: beacon.title)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let beacon = nearbyBeacons[indexPath.row]
        
        let alert = UIAlertController(title: "Are you sure this is your beacon?", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            BeaconService.create(User.current.uid, beacon: beacon)
            
            //create user
            
            UserService.setBeaconId(User.current, bId: beacon.id) { (user) in
                guard let user = user else {
                    return
                }
                User.setCurrent(user, writeToUserDefaults: true)
                print(user.bId)
            }

            let initialViewController = UIStoryboard.initialViewController(for: .main)
            self.view.window?.rootViewController = initialViewController
            self.view.window?.makeKeyAndVisible()
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
        
        
    }
}
