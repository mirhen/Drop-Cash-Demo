//
//  LoginViewController.swift
//  Journal
//
//  Created by Miriam Haart on 3/1/18.
//  Copyright © 2018 Miriam Haart. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseAuthUI
import FirebaseDatabase
import Firebase

typealias FIRUser = FirebaseAuth.User

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        // 1
        guard let authUI = FUIAuth.defaultAuthUI()
            else { return }
        
        // 2
        authUI.delegate = self
        
        // 3
        let authViewController = authUI.authViewController()
        present(authViewController, animated: true)
    }
}

extension LoginViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith user: FIRUser?, error: Error?) {
        if let error = error {
            print("Error signing in: \(error.localizedDescription)")
            return
        }
        
        guard let user = user else {
            return
        }
        UserService.show(forUID: user.uid) { (userObject) in
            if let userObject = userObject {
                // handle existing user
                User.setCurrent(userObject, writeToUserDefaults: true)
                
                let initialViewController = UIStoryboard.initialViewController(for: .main)
                self.view.window?.rootViewController = initialViewController
                self.view.window?.makeKeyAndVisible()
            } else {
                //create user
                UserService.create(user, completion: { (user) in
                    
                    if let user = user {
                        User.setCurrent(user, writeToUserDefaults: true)
                        
                        self.performSegue(withIdentifier: Constants.Segue.toRegisterBeacon , sender: self)
                    }
                })
            }
        }
    }
}
