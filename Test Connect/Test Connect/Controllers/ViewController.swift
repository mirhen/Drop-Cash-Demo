//
//  ViewController.swift
//  Test Connect
//
//  Created by Miriam Haart on 6/22/18.
//  Copyright © 2018 Miriam Haart. All rights reserved.
//

import UIKit
import Alamofire
import Stripe
import Firebase
import EstimoteProximitySDK

class ViewController: UIViewController {

    //IBoutlets
    
    @IBOutlet weak var paymentButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var paymentLabel: UILabel!
    @IBOutlet weak var amountSegmentControl: UISegmentedControl!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    
    
    //Properties
    var users = [User]()
    var proximityObserver: EPXProximityObserver!
    var beacons = [Beacon]() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    var selectedUser: User?
    var amount = 1 {
        didSet {
           setPaymentLabelText()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //Observe Users
        UserService.users { (users) in
            self.users = users
            self.collectionView.reloadData()
            
            if users.count != 0 {
                self.selectedUser = users[0]
                self.setPaymentLabelText()
            }
        }
        
        observeNearbyBeacons()
        
        
    }

    
    // IBActions
    
    @IBAction func amountSegmentTapped(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            case 0:
                amount = 1
            case 1:
                amount = 5
            case 2:
                self.performSegue(withIdentifier: Constants.Segue.toAmountController, sender: self)
            default:
                break
        }
    }
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        
        checkIfUserSetupBankAccount()
        
        let addCardViewController = STPAddCardViewController()
        addCardViewController.delegate = self
        navigationController?.pushViewController(addCardViewController, animated: true)
    }
    
    @IBAction func exitToController(segue: UIStoryboardSegue) { }
    
    // Helper Functions
    
    func setPaymentLabelText() {
        if let user = selectedUser {
            paymentLabel.text = "$\(amount) to \(user.username)"
        } else {
            if users.count != 0 {
                paymentLabel.text = "$\(amount) to \(users[0].username)"
            }
        }
    }
    
    func checkIfUserSetupBankAccount() {
        if let user = selectedUser{
            if user.stripeAccount == nil {
                let alertController = UIAlertController(title: "Cannot make payment", message: "User did not setup bank details", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                present(alertController, animated: true, completion: nil)
                navigationController?.popViewController(animated: true)
                return
            }
        }
        
    }
}

// MARK: - Table View Delegate

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! UserCell
        
        let user = users[indexPath.row]
        
        cell.nameLabel.text = user.username
        cell.nearbyLabel.text = user.isNearby(beacons) ? user.bId : ""
        
        cell.backgroundColor = UIColor(red: CGFloat(arc4random_uniform(255))/255, green: CGFloat(arc4random_uniform(255))/255, blue: CGFloat(arc4random_uniform(255))/255, alpha: 1)
        
        return cell
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        selectedUser = user
        
        setPaymentLabelText()
    }

}


//  MARK: Card Details

extension ViewController: STPAddCardViewControllerDelegate {
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController,
                               didCreateToken token: STPToken,
                               completion: @escaping STPErrorBlock) {
        if let user = selectedUser {
            let payment = Payment(sender: User.current.username, receiver: user.username, amount: amount, date: Date())
                payment.description = descriptionTextField.text ?? payment.getDefaultDescription()
            
                checkIfUserSetupBankAccount()
            
            StripeClient.shared.completeCharge(with: token, user: user, payment: payment) { result in
                switch result {
                // 1
                case .success:
                    completion(nil)
                    UserService.sendPaymentTo(user, payment: payment)
                    let alertController = UIAlertController(title: "Congrats",
                                                            message: "Your payment was successful!",
                                                            preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                        self.navigationController?.popViewController(animated: true)
                    })
                    alertController.addAction(alertAction)
                    self.present(alertController, animated: true)
                // 2
                case .failure(let error):
                    completion(error)
                }
            }
        }
    }
}


// MARK: Beacon Functions

extension ViewController {
    
    func observeNearbyBeacons() {
        let estimoteCloudCredentials = EPXCloudCredentials(appID: Constants.EstimoteCloud.appID, appToken: Constants.EstimoteCloud.appToken)
        
        proximityObserver = EPXProximityObserver(credentials: estimoteCloudCredentials, errorBlock: { error in
            print("EPXProximityObserver error: \(error)")
        })
        
        let zone = EPXProximityZone(range: EPXProximityRange.custom(desiredMeanTriggerDistance: 3.0)!,
                                    attachmentKey: "miriamhaart-gmail-com-s-pr-dyg", attachmentValue: "example-proximity-zone")
        zone.onChangeAction = { attachments in
            print(attachments)
            self.beacons = attachments.map { attachment in
                
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
            self.collectionView.reloadData()
        }
        proximityObserver.startObserving([zone])
    }
}
