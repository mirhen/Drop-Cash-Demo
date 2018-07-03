//
//  AmountController.swift
//  Test Connect
//
//  Created by Miriam Haart on 6/29/18.
//  Copyright © 2018 Miriam Haart. All rights reserved.
//

import UIKit

class AmountController: UIViewController {

    @IBOutlet weak var calculationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calculationLabel.text = "$0"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func numberButtonPressed(_ sender: UIButton) {
        if calculationLabel.text == "$0" {
            calculationLabel!.text! = "$" + sender.titleLabel!.text!
        } else {
            calculationLabel!.text! += sender.titleLabel!.text!
        }
    }
    
    @IBAction func clearButtonPressed(_ sender: Any) {
        calculationLabel.text = "$0"
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.exitToController {
            if let destination = segue.destination as? ViewController {
                let amount = String(calculationLabel.text!.dropFirst())
                
                destination.amount = Int(amount) ?? 1
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
