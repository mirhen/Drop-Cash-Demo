//
//  ProfileController.swift
//  Test Connect
//
//  Created by Miriam Haart on 6/29/18.
//  Copyright © 2018 Miriam Haart. All rights reserved.
//

import UIKit
import Firebase

class ProfileController: UIViewController {
    
    //IBOutlets
    @IBOutlet weak var setupBankAccountButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //Properties
    var payments = [Payment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setInitialUI()
        
        //Observe Payments
        UserService.payments { (payments) in
            self.payments = payments
            self.tableView.reloadData()
        }
    }
    
    // IBActions
    
    @IBAction func setupBankAccount(_ sender: Any) {
        StripeClient.shared.signInToConnectWithUser(User.current)
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        print(#function)
        do {
            try Auth.auth().signOut()
            let initialViewController = UIStoryboard.initialViewController(for: .login)
            self.view.window?.rootViewController = initialViewController
            self.view.window?.makeKeyAndVisible()
        } catch let error as NSError {
            assertionFailure("Error signing out: \(error.localizedDescription)")
        }
    }
    
    //UI Functions
    
    func setInitialUI() {
        nameLabel.text = User.current.username
        
        if User.current.stripeAccount == nil {
            setupBankAccountButton.setTitle("Setup Bank Account", for: .normal)
        } else {
            setupBankAccountButton.setTitle("Change Bank Account", for: .normal)
        }
    }
}


//MARK: - Table View

extension ProfileController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return payments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let payment = payments[indexPath.row]
        
        cell.textLabel!.text = payment.getDefaultDescription()
        
        
        return cell
    }
}
