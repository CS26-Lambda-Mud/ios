//
//  SigninViewController.swift
//  dudeCrawler
//
//  Created by Jake Connerly on 3/3/20.
//  Copyright © 2020 jake connerly. All rights reserved.
//

import UIKit

class SigninViewController: UIViewController {

    @IBOutlet weak var optionsSegmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var password1TextField: UITextField!
    @IBOutlet weak var password2TextField: UITextField!
    @IBOutlet weak var confirmPasswordLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    
    var signInController: SignInController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func uiSetup() {
        if optionsSegmentedControl.selectedSegmentIndex == 0 {
            password2TextField.isHidden = false
            confirmPasswordLabel.isHidden = false
            submitButton.setTitle("Register", for: .normal)
        } else {
            password2TextField.isHidden = true
            confirmPasswordLabel.isHidden = true
            submitButton.setTitle("Login", for: .normal)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func submitButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func optionControlValueChanged(_ sender: UISegmentedControl) {
        uiSetup()
    }
}
